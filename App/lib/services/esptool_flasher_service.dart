import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EsptoolFlasherService {
  /// esptool コマンド経由での ESP32 ファームウェア書き込み処理
  Future<void> flashFirmware({
    required String portName,
    required File firmwareFile,
    void Function(double progress)? onProgress,
    void Function(String message)? onLog,
  }) async {
    final log = onLog ?? (msg) => debugPrint('[ESPTOOL] $msg');

    log('書き込み環境 (同梱 esptool / Python) を確認中...');
    final runner = await _findEsptoolRunner(log);
    if (runner == null) {
      throw Exception(
        'esptool 実行環境の検出に失敗しました。\n'
        'Python3 をインストールするか、`pip install esptool` を実行してください。',
      );
    }

    log('esptool 実行引数を構築中...');
    final List<String> args = [...runner.baseArgs];
    args.addAll([
      '--chip',
      'esp32',
      '--port',
      portName,
      '--baud',
      '460800',
      'write_flash',
      '0x10000',
      firmwareFile.path,
    ]);

    log('esptool 起動: ${runner.executable} ${args.join(" ")}');

    final process = await Process.start(
      runner.executable,
      args,
      environment: Platform.environment,
    );

    final stderrBuffer = StringBuffer();
    final progressRegex = RegExp(r'\((\d+)\s*%\)');

    final stdoutSub = process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        log(trimmed);

        // プログレス抽出 (例: Writing at 0x00010000... (10 %))
        final match = progressRegex.firstMatch(trimmed);
        if (match != null) {
          final pctInt = int.tryParse(match.group(1) ?? '');
          if (pctInt != null) {
            onProgress?.call(0.3 + (pctInt / 100.0) * 0.7);
          }
        }
      }
    });

    final stderrSub = process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        stderrBuffer.writeln(trimmed);
        log('[STDERR] $trimmed');
      }
    });

    final exitCode = await process.exitCode;
    await stdoutSub.cancel();
    await stderrSub.cancel();

    if (exitCode != 0) {
      final errStr = stderrBuffer.toString().trim();
      throw Exception('esptool の書き込み処理が失敗しました (ExitCode: $exitCode)\n$errStr');
    }

    log('esptool によるファームウェア書き込みが完了しました！');
  }

  /// esptool 実行ランナーの自動検出 (優先度: 同梱バイナリ -> Python esptool -> システム esptool -> pip インストール)
  Future<_EsptoolRunner?> _findEsptoolRunner(void Function(String) log) async {
    // 1. 同梱のスタンドアロン esptool バイナリの展開・確認
    try {
      final assetPath = Platform.isWindows
          ? 'assets/esptool/bin/windows/esptool.exe'
          : 'assets/esptool/bin/macos/esptool';
      final byteData = await rootBundle.load(assetPath);

      final tempDir = await getTemporaryDirectory();
      final targetFileName = Platform.isWindows ? 'esptool_bundled.exe' : 'esptool_bundled';
      final exeFile = File(p.join(tempDir.path, targetFileName));

      if (!await exeFile.parent.exists()) {
        await exeFile.parent.create(recursive: true);
      }

      await exeFile.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes), flush: true);

      if (!Platform.isWindows) {
        await Process.run('chmod', ['+x', exeFile.path]);
      }

      final testResult = await Process.run(exeFile.path, ['version']);
      if (testResult.exitCode == 0) {
        log('同梱されたスタンドアロン esptool バイナリを使用します (Python不要: v${testResult.stdout.toString().trim()})');
        return _EsptoolRunner(executable: exeFile.path, baseArgs: []);
      }
    } catch (e) {
      debugPrint('[ESPTOOL] 同梱バイナリ読み込み失敗、Python検出へ移行: $e');
    }

    // 2. python3 -m esptool の確認
    final pythonCmd = Platform.isWindows ? 'python' : 'python3';
    try {
      final result = await Process.run(pythonCmd, ['-m', 'esptool', 'version']);
      if (result.exitCode == 0) {
        log('Python esptool モジュールを使用します: ${result.stdout.toString().trim()}');
        return _EsptoolRunner(executable: pythonCmd, baseArgs: ['-m', 'esptool']);
      }
    } catch (_) {}

    // 3. esptool スタンドアロンコマンド (PATH上) の確認
    try {
      final result = await Process.run('esptool', ['version']);
      if (result.exitCode == 0) {
        log('システム PATH 上の esptool コマンドを使用します');
        return _EsptoolRunner(executable: 'esptool', baseArgs: []);
      }
    } catch (_) {}

    // 4. python3 はあるが esptool 未インストールの場合は自動 pip install 試行
    try {
      final pyCheck = await Process.run(pythonCmd, ['--version']);
      if (pyCheck.exitCode == 0) {
        log('Python を検出しました (${pyCheck.stdout.toString().trim()})。esptool を自動インストール中...');
        final pipRes = await Process.run(pythonCmd, ['-m', 'pip', 'install', 'esptool']);
        if (pipRes.exitCode == 0) {
          log('esptool の自動インストールに成功しました！');
          return _EsptoolRunner(executable: pythonCmd, baseArgs: ['-m', 'esptool']);
        }
      }
    } catch (_) {}

    return null;
  }
}

class _EsptoolRunner {
  final String executable;
  final List<String> baseArgs;

  _EsptoolRunner({required this.executable, required this.baseArgs});
}
