import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// VRChat などの OSC 入力受信機能に向けて OSC メッセージを UDP 送信するサービス
class OscService {
  RawDatagramSocket? _socket;
  String _host = '127.0.0.1';
  int _port = 9000;

  String get host => _host;
  int get port => _port;

  OscService({String host = '127.0.0.1', int port = 9000}) {
    _host = host;
    _port = port;
    _initSocket();
  }

  Future<void> _initSocket() async {
    if (_socket != null) return;
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    } catch (e) {
      debugPrint('[OSC Service] UDP ソケット バインドエラー: $e');
    }
  }

  void updateDestination({required String host, required int port}) {
    _host = host;
    _port = port;
  }

  /// OSC アドレスに対して float32 値を送信
  void sendFloat(String address, double value) {
    if (_socket == null) {
      _initSocket().then((_) => _sendFloatInternal(address, value));
    } else {
      _sendFloatInternal(address, value);
    }
  }

  void _sendFloatInternal(String address, double value) {
    if (_socket == null) return;
    final Uint8List bytes = encodeOscFloat(address, value);
    try {
      final destination = InternetAddress(_host);
      _socket!.send(bytes, destination, _port);
    } catch (e) {
      debugPrint('[OSC Service] パケット送信エラー: $e');
    }
  }

  /// OSC メッセージ (Address + ',f' + float32) のバイト配列エンコード
  static Uint8List encodeOscFloat(String address, double value) {
    final List<int> bytes = [];

    // 1. OSC Address
    bytes.addAll(utf8.encode(address));
    bytes.add(0); // NULL 終端
    while (bytes.length % 4 != 0) {
      bytes.add(0);
    }

    // 2. Type Tag String (',f')
    bytes.addAll(utf8.encode(',f'));
    bytes.add(0); // NULL 終端
    while (bytes.length % 4 != 0) {
      bytes.add(0);
    }

    // 3. Float32 Argument (Big-Endian)
    final byteData = ByteData(4);
    byteData.setFloat32(0, value, Endian.big);
    bytes.addAll(byteData.buffer.asUint8List());

    return Uint8List.fromList(bytes);
  }

  /// OSC アドレスに対して int32 値を送信
  void sendInt(String address, int value) {
    if (_socket == null) {
      _initSocket().then((_) => _sendIntInternal(address, value));
    } else {
      _sendIntInternal(address, value);
    }
  }

  void _sendIntInternal(String address, int value) {
    if (_socket == null) return;
    final Uint8List bytes = encodeOscInt(address, value);
    try {
      final destination = InternetAddress(_host);
      _socket!.send(bytes, destination, _port);
    } catch (e) {
      debugPrint('[OSC Service] パケット送信エラー: $e');
    }
  }

  /// OSC メッセージ (Address + ',i' + int32) のバイト配列エンコード
  static Uint8List encodeOscInt(String address, int value) {
    final List<int> bytes = [];

    // 1. OSC Address
    bytes.addAll(utf8.encode(address));
    bytes.add(0); // NULL 終端
    while (bytes.length % 4 != 0) {
      bytes.add(0);
    }

    // 2. Type Tag String (',i')
    bytes.addAll(utf8.encode(',i'));
    bytes.add(0); // NULL 終端
    while (bytes.length % 4 != 0) {
      bytes.add(0);
    }

    // 3. Int32 Argument (Big-Endian)
    final byteData = ByteData(4);
    byteData.setInt32(0, value, Endian.big);
    bytes.addAll(byteData.buffer.asUint8List());

    return Uint8List.fromList(bytes);
  }

  void dispose() {
    _socket?.close();
    _socket = null;
  }
}

