import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class EsptoolFlasherService {
  /// esptool コマンド経由での ESP32 ファームウェア書き込み処理
  Future<void> flashFirmware({
    required String portName,
    required File firmwareFile,
    void Function(double progress)? onProgress,
    void Function(String message)? onLog,
  }) async {
    final log = onLog ?? (msg) => debugPrint('[ESPTOOL] $msg');

    log('書き込み環境 (Python / esptool) を確認中...');
    final runner = await _findEsptoolRunner(log);
    if (runner == null) {
      throw Exception(
        'esptool および Python3 が見つかりませんでした。\n'
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

  /// esptool 実行ランナーの自動検出
  Future<_EsptoolRunner?> _findEsptoolRunner(void Function(String) log) async {
    final pythonCmd = Platform.isWindows ? 'python' : 'python3';

    // 1. python3 -m esptool の確認
    try {
      final result = await Process.run(pythonCmd, ['-m', 'esptool', 'version']);
      if (result.exitCode == 0) {
        log('Python esptool モジュールを検出しました: ${result.stdout.toString().trim()}');
        return _EsptoolRunner(executable: pythonCmd, baseArgs: ['-m', 'esptool']);
      }
    } catch (_) {}

    // 2. esptool スタンドアロンコマンドの確認
    try {
      final result = await Process.run('esptool', ['version']);
      if (result.exitCode == 0) {
        log('スタンドアロン esptool コマンドを検出しました');
        return _EsptoolRunner(executable: 'esptool', baseArgs: []);
      }
    } catch (_) {}

    // 3. python3 はあるが esptool 未インストールの場合は自動 pip install 試行
    try {
      final pyCheck = await Process.run(pythonCmd, ['--version']);
      if (pyCheck.exitCode == 0) {
        log('Python を検出しました (${pyCheck.stdout.toString().trim()})。esptool を自動インストール中...');
        final pipRes = await Process.run(pythonCmd, ['-m', 'pip', 'install', 'esptool']);
        if (pipRes.exitCode == 0) {
          log('esptool の自動インストールに成功しました！');
          return _EsptoolRunner(executable: pythonCmd, baseArgs: ['-m', 'esptool']);
        } else {
          log('esptool の自動インストールに失敗しました: ${pipRes.stderr}');
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
