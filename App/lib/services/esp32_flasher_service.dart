import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class Esp32FlasherService {
  static const int flashBlockSize = 4096;
  static const int appOffset = 0x10000; // ESP32 アプリケーションパーティション標準オフセット

  /// ピュア Dart による ESP32 ROM ブートローダー書き込み処理
  Future<void> flashFirmware({
    required String portName,
    required File firmwareFile,
    void Function(double progress)? onProgress,
    void Function(String message)? onLog,
  }) async {
    final log = onLog ?? (msg) => debugPrint('[FLASHER] $msg');
    log('シリアルポート $portName をオープン中...');

    final port = SerialPort(portName);
    if (!port.openReadWrite()) {
      throw Exception('シリアルポート $portName のオープンに失敗しました');
    }

    try {
      final config = port.config;
      config.baudRate = 115200;
      config.bits = 8;
      config.stopBits = 1;
      config.parity = SerialPortParity.none;
      config.setFlowControl(SerialPortFlowControl.none);
      port.config = config;

      // 1. ESP32 の DTR/RTS 自動リセットシーケンス
      log('ESP32 をブートローダーモードへリセット中...');
      await _resetToBootloader(port);

      // 2. ブートローダーとの SYNC 確立
      log('ブートローダーと同期中 (SYNC)...');
      await _sendSync(port, log);

      // 3. SPI Flash アタッチ
      log('SPI Flash を初期化中 (SPI_ATTACH)...');
      await _sendCommand(port, 0x0A, Uint8List(8), timeoutMs: 5000);

      // 4. ファームウェア読み込み & Flash Begin
      final firmwareBytes = await firmwareFile.readAsBytes();
      final totalSize = firmwareBytes.length;
      final packetCount = (totalSize + flashBlockSize - 1) ~/ flashBlockSize;
      final eraseSize = packetCount * flashBlockSize; // 4KB セクター境界アラインメント

      log('ファームウェアサイズ: $totalSize バイト (ブロック数: $packetCount)');
      log('Flash 消去・開始要求 (Offset: 0x${appOffset.toRadixString(16)}, EraseSize: $eraseSize)...');

      final beginPayload = Uint8List(16);
      final beginData = ByteData.view(beginPayload.buffer);
      beginData.setUint32(0, eraseSize, Endian.little);
      beginData.setUint32(4, packetCount, Endian.little);
      beginData.setUint32(8, flashBlockSize, Endian.little);
      beginData.setUint32(12, appOffset, Endian.little);

      // セクター消去待ち時間のため長めのタイムアウト (30秒) を設定
      await _sendCommand(port, 0x02, beginPayload, timeoutMs: 30000);

      // 5. データブロック送信 (FLASH_DATA)
      log('ファームウェア書き込み開始...');
      for (int i = 0; i < packetCount; i++) {
        final start = i * flashBlockSize;
        final end = (start + flashBlockSize > totalSize) ? totalSize : start + flashBlockSize;
        final blockData = firmwareBytes.sublist(start, end);

        // 4KB に満たない最終ブロックの 0xFF パディング
        final paddedBlock = Uint8List(flashBlockSize);
        paddedBlock.setAll(0, blockData);
        if (blockData.length < flashBlockSize) {
          paddedBlock.fillRange(blockData.length, flashBlockSize, 0xFF);
        }

        final checksum = _calculateChecksum(paddedBlock);

        final dataPayload = Uint8List(16 + flashBlockSize);
        final dataData = ByteData.view(dataPayload.buffer);
        dataData.setUint32(0, paddedBlock.length, Endian.little);
        dataData.setUint32(4, i, Endian.little);
        dataData.setUint32(8, 0, Endian.little);
        dataData.setUint32(12, 0, Endian.little);
        dataPayload.setAll(16, paddedBlock);

        await _sendCommand(port, 0x03, dataPayload, checksum: checksum, timeoutMs: 10000);

        final progress = (i + 1) / packetCount;
        onProgress?.call(progress);
        if ((i + 1) % 10 == 0 || i + 1 == packetCount) {
          log('書き込み中: ${(progress * 100).toStringAsFixed(1)}% (${i + 1}/$packetCount ブロック)');
        }
      }

      // 6. Flash End & リセット
      log('書き込み完了。再起動コマンド送信中...');
      final endPayload = Uint8List(4);
      ByteData.view(endPayload.buffer).setUint32(0, 1, Endian.little); // 1 = reboot
      await _sendCommand(port, 0x04, endPayload, timeoutMs: 5000);

      // マイコン再起動
      await _resetToApp(port);
      log('ファームウェアの書き込みが正常に完了しました！');
    } finally {
      if (port.isOpen) {
        port.close();
      }
      port.dispose();
    }
  }

  /// DTR / RTS トグルによる ESP32 ブートローダーリセット
  Future<void> _resetToBootloader(SerialPort port) async {
    _setPins(port, rts: false, dtr: false);
    await Future.delayed(const Duration(milliseconds: 50));

    // EN = LOW (Reset)
    _setPins(port, rts: true, dtr: false);
    await Future.delayed(const Duration(milliseconds: 150));

    // IO0 = LOW, EN = HIGH (Enter Bootloader)
    _setPins(port, rts: false, dtr: true);
    await Future.delayed(const Duration(milliseconds: 100));

    // Release pins
    _setPins(port, rts: false, dtr: false);
    await Future.delayed(const Duration(milliseconds: 50));
  }

  /// 通常動作用リセット
  Future<void> _resetToApp(SerialPort port) async {
    _setPins(port, rts: true, dtr: false);
    await Future.delayed(const Duration(milliseconds: 150));
    _setPins(port, rts: false, dtr: false);
    await Future.delayed(const Duration(milliseconds: 150));
  }

  /// SerialPortConfig を使用して RTS / DTR ピン状態を設定
  void _setPins(SerialPort port, {required bool rts, required bool dtr}) {
    final config = port.config;
    config.rts = rts ? SerialPortRts.on : SerialPortRts.off;
    config.dtr = dtr ? SerialPortDtr.on : SerialPortDtr.off;
    port.config = config;
  }

  /// SYNC コマンド送信 (esptool 互換の連続送信ループ)
  Future<void> _sendSync(SerialPort port, void Function(String) log) async {
    final syncPayload = Uint8List(36);
    syncPayload[0] = 0x07;
    syncPayload[1] = 0x07;
    syncPayload[2] = 0x12;
    syncPayload[3] = 0x20;
    for (int i = 4; i < 36; i++) {
      syncPayload[i] = 0x55;
    }

    final pkt = Uint8List(8 + syncPayload.length);
    pkt[0] = 0x00; // Request
    pkt[1] = 0x08; // SYNC
    final view = ByteData.view(pkt.buffer);
    view.setUint16(2, syncPayload.length, Endian.little);
    view.setUint32(4, 0, Endian.little);
    pkt.setAll(8, syncPayload);
    final slipSync = _encodeSlip(pkt);

    final rxBuffer = <int>[];

    for (int attempt = 1; attempt <= 40; attempt++) {
      port.flush(SerialPortBuffer.both);
      port.write(slipSync);

      final startTime = DateTime.now();
      while (DateTime.now().difference(startTime).inMilliseconds < 60) {
        final readData = port.read(1024, timeout: 15);
        if (readData.isNotEmpty) {
          rxBuffer.addAll(readData);
          final decoded = _tryDecodeSlipResponse(rxBuffer, 0x08);
          if (decoded != null) {
            log('ESP32 との同期 (SYNC) に成功しました！');
            return;
          }
        }
      }

      if (attempt == 20) {
        log('SYNC 応答待ち... リセット信号を再送中');
        await _resetToBootloader(port);
      } else if (attempt % 10 == 0) {
        log('SYNC 送信中 ($attempt/40)...');
      }
    }

    throw Exception('ESP32 との同期 (SYNC) に失敗しました。COMポートの選択を確認するか、BOOTボタンを押しながら再試行してください。');
  }

  /// SLIP パケット生成・送信およびレスポンス受信
  Future<Uint8List> _sendCommand(
    SerialPort port,
    int op,
    Uint8List payload, {
    int checksum = 0,
    int timeoutMs = 2000,
  }) async {
    final pkt = Uint8List(8 + payload.length);
    pkt[0] = 0x00; // Request
    pkt[1] = op;
    final view = ByteData.view(pkt.buffer);
    view.setUint16(2, payload.length, Endian.little);
    view.setUint32(4, checksum, Endian.little);
    pkt.setAll(8, payload);

    final slipEncoded = _encodeSlip(pkt);
    port.flush(SerialPortBuffer.both);
    port.write(slipEncoded);

    // レスポンス受信
    final startTime = DateTime.now();
    final rxBuffer = <int>[];

    while (DateTime.now().difference(startTime).inMilliseconds < timeoutMs) {
      final readData = port.read(1024, timeout: 50);
      if (readData.isNotEmpty) {
        rxBuffer.addAll(readData);
        final decoded = _tryDecodeSlipResponse(rxBuffer, op);
        if (decoded != null) {
          return decoded;
        }
      }
    }

    throw Exception('コマンド 0x${op.toRadixString(16)} のレスポンスタイムアウト (${timeoutMs}ms)');
  }

  /// XOR チェックサム計算
  int _calculateChecksum(Uint8List data) {
    int checksum = 0xEF;
    for (final b in data) {
      checksum ^= b;
    }
    return checksum;
  }

  /// SLIP エンコード (0xC0 -> 0xDB 0xDC, 0xDB -> 0xDB 0xDD)
  Uint8List _encodeSlip(Uint8List data) {
    final bytes = <int>[0xC0];
    for (final b in data) {
      if (b == 0xC0) {
        bytes.addAll([0xDB, 0xDC]);
      } else if (b == 0xDB) {
        bytes.addAll([0xDB, 0xDD]);
      } else {
        bytes.add(b);
      }
    }
    bytes.add(0xC0);
    return Uint8List.fromList(bytes);
  }

  /// SLIP デコード & レスポンス判定 (ゴミフレームを自動スキップ)
  Uint8List? _tryDecodeSlipResponse(List<int> rxBuffer, int expectedOp) {
    while (true) {
      int startIdx = rxBuffer.indexOf(0xC0);
      if (startIdx == -1) {
        rxBuffer.clear();
        return null;
      }
      if (startIdx > 0) {
        rxBuffer.removeRange(0, startIdx);
        startIdx = 0;
      }

      int endIdx = rxBuffer.indexOf(0xC0, 1);
      if (endIdx == -1) {
        return null;
      }

      final rawFrame = rxBuffer.sublist(1, endIdx);
      rxBuffer.removeRange(0, endIdx + 1);

      // SLIP デコード
      final decoded = <int>[];
      for (int i = 0; i < rawFrame.length; i++) {
        if (rawFrame[i] == 0xDB && i + 1 < rawFrame.length) {
          if (rawFrame[i + 1] == 0xDC) {
            decoded.add(0xC0);
            i++;
          } else if (rawFrame[i + 1] == 0xDD) {
            decoded.add(0xDB);
            i++;
          }
        } else {
          decoded.add(rawFrame[i]);
        }
      }

      if (decoded.length >= 2) {
        final respOp = decoded[1];
        if (respOp == expectedOp) {
          return Uint8List.fromList(decoded);
        }
      }
    }
  }

}

