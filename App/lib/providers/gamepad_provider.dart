import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../models/app_config.dart';
import '../services/serial_service.dart';
import '../services/osc_service.dart';

class GamepadProvider extends ChangeNotifier {
  final SerialService _serialService = SerialService();
  late final OscService _oscService;
  StreamSubscription<String>? _dataSubscription;

  SensorData _currentData = const SensorData();
  final AppConfig _config = AppConfig();
  List<String> _availablePorts = [];
  bool _isSerialConnected = false;
  String _statusMessage = '未接続';

  SensorData get currentData => _currentData;
  AppConfig get config => _config;
  List<String> get availablePorts => _availablePorts;
  bool get isSerialConnected => _isSerialConnected;
  String get statusMessage => _statusMessage;

  GamepadProvider() {
    _oscService = OscService(host: _config.oscHost, port: _config.oscPort);
    refreshPorts();
  }

  void refreshPorts() {
    _availablePorts = SerialService.getAvailablePorts();
    if (_availablePorts.isNotEmpty && _config.selectedPort.isEmpty) {
      _config.selectedPort = _availablePorts.first;
    }
    notifyListeners();
  }

  void setSelectedPort(String port) {
    _config.selectedPort = port;
    notifyListeners();
  }

  void setDeadzone(double value) {
    _config.deadzone = value;
    notifyListeners();
  }

  void setSensitivity(double value) {
    _config.sensitivity = value;
    notifyListeners();
  }

  void setOutputMode(OutputMode mode) {
    _config.outputMode = mode;
    notifyListeners();
  }

  void setOscHost(String host) {
    _config.oscHost = host;
    _oscService.updateDestination(host: _config.oscHost, port: _config.oscPort);
    notifyListeners();
  }

  void setOscPort(int port) {
    _config.oscPort = port;
    _oscService.updateDestination(host: _config.oscHost, port: _config.oscPort);
    notifyListeners();
  }

  void setInvertOscX(bool invert) {
    _config.invertOscX = invert;
    notifyListeners();
  }

  void setInvertOscY(bool invert) {
    _config.invertOscY = invert;
    notifyListeners();
  }

  bool connect() {
    if (_config.selectedPort.isEmpty) {
      _statusMessage = 'シリアルポートが選択されていません';
      notifyListeners();
      return false;
    }

    bool success = _serialService.connect(_config.selectedPort, baudRate: _config.baudRate);
    if (success) {
      _isSerialConnected = true;
      _statusMessage = '接続中: ${_config.selectedPort}';

      _dataSubscription?.cancel();
      _dataSubscription = _serialService.dataStream.listen((rawJson) {
        debugPrint('[PROVIDER RX] Parsing: $rawJson');
        _currentData = SensorData.fromRawString(rawJson);
        _handleDataOutput(_currentData);
        notifyListeners();
      });
    } else {
      _isSerialConnected = false;
      _statusMessage = '接続失敗: ${_config.selectedPort}';
    }

    notifyListeners();
    return success;
  }

  /// 出力モードに応じたデータ中継処理
  void _handleDataOutput(SensorData data) {
    switch (_config.outputMode) {
      case OutputMode.oscInputController:
        // OSC as Input Controller モードが ON の場合、仮想ゲームパッド出力を OFF にして OSC 送信
        _sendOscInput(data);
        break;
      case OutputMode.virtualGamepad:
        // 仮想ゲームパッド モード (OSC 送信は停止)
        _relayVirtualGamepad(data);
        break;
      case OutputMode.none:
        // 出力 OFF
        break;
    }
  }

  /// OSC as Input Controller パケットの計算と送信
  void _sendOscInput(SensorData data) {
    double rawX = data.centerX;
    double rawY = data.centerY;

    // デッドゾーン処理
    double x = (rawX.abs() < _config.deadzone) ? 0.0 : rawX;
    double y = (rawY.abs() < _config.deadzone) ? 0.0 : rawY;

    // 感度補正
    x *= _config.sensitivity;
    y *= _config.sensitivity;

    // クランプ (-1.0 〜 +1.0)
    x = x.clamp(-1.0, 1.0);
    y = y.clamp(-1.0, 1.0);

    // 軸反転設定の適用
    if (_config.invertOscX) x = -x;
    if (_config.invertOscY) y = -y;

    // VRChat OSC Input Controller アドレス宛にパケット送信
    _oscService.sendFloat('/input/Horizontal', x);
    _oscService.sendFloat('/input/Vertical', y);
  }

  /// 仮想ゲームパッド入力中継（OSC モード時は OFF）
  void _relayVirtualGamepad(SensorData data) {
    // 仮想ゲームパッド出力処理（現状は OSC モード ON 時に停止する構造）
  }

  void disconnect() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
    _serialService.disconnect();
    _isSerialConnected = false;
    _currentData = const SensorData();
    _statusMessage = '切断完了';
    notifyListeners();
  }

  void sendTareCommand() {
    if (_isSerialConnected) {
      _serialService.sendCommand('{"cmd":"tare"}');
    }
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _serialService.dispose();
    _oscService.dispose();
    super.dispose();
  }
}

