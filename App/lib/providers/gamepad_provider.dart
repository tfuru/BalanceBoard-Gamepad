import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../models/app_config.dart';
import '../services/serial_service.dart';
import '../services/osc_service.dart';

import '../services/keyboard_service.dart';
import '../services/jump_detector.dart';


class GamepadProvider extends ChangeNotifier {
  final SerialService _serialService = SerialService();
  late final OscService _oscService;
  late final KeyboardService _keyboardService;
  final JumpDetector _jumpDetector = JumpDetector();
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
  KeyboardService get keyboardService => _keyboardService;
  bool get isJumping => _jumpDetector.isJumping;

  // モニタリング用のアクティブ出力計算値 Getter
  double get activeOscX {
    double rawX = _currentData.centerX;
    double x = (rawX.abs() < _config.deadzone) ? 0.0 : rawX;
    x *= _config.sensitivity;
    x = x.clamp(-1.0, 1.0);
    return _config.invertOscX ? -x : x;
  }

  double get activeOscY {
    double rawY = _currentData.centerY;
    double y = (rawY.abs() < _config.deadzone) ? 0.0 : rawY;
    y *= _config.sensitivity;
    y = y.clamp(-1.0, 1.0);
    return _config.invertOscY ? -y : y;
  }

  double get activeGamepadX {
    double rawX = _currentData.centerX;
    double x = (rawX.abs() < _config.deadzone) ? 0.0 : rawX;
    x *= _config.sensitivity;
    return x.clamp(-1.0, 1.0);
  }

  double get activeGamepadY {
    double rawY = _currentData.centerY;
    double y = (rawY.abs() < _config.deadzone) ? 0.0 : rawY;
    y *= _config.sensitivity;
    return y.clamp(-1.0, 1.0);
  }

  GamepadProvider() {
    _oscService = OscService(host: _config.oscHost, port: _config.oscPort);
    _keyboardService = KeyboardService();
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
    if (_config.outputMode == OutputMode.keyboardWasd && mode != OutputMode.keyboardWasd) {
      _keyboardService.releaseAllKeys();
    }
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

  void setWasdThreshold(double value) {
    _config.wasdThreshold = value;
    notifyListeners();
  }

  void setInvertWasdX(bool invert) {
    _config.invertWasdX = invert;
    notifyListeners();
  }

  void setInvertWasdY(bool invert) {
    _config.invertWasdY = invert;
    notifyListeners();
  }

  void setEnableJump(bool enable) {
    _config.enableJump = enable;
    if (!enable) _jumpDetector.reset();
    notifyListeners();
  }

  void setJumpThresholdKg(double value) {
    _config.jumpThresholdKg = value;
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

  /// 出力モードに応じたデータ中継処理およびジャンプ判定
  void _handleDataOutput(SensorData data) {
    // リアルタイムジャンプ検知
    bool newlyJumping = _jumpDetector.processWeight(
      data.weightKg,
      thresholdKg: _config.jumpThresholdKg,
      enabled: _config.enableJump,
      holdMs: _config.jumpHoldMs,
    );

    if (newlyJumping) {
      _dispatchJumpSignal();
    }

    switch (_config.outputMode) {
      case OutputMode.oscInputController:
        _keyboardService.releaseAllKeys();
        _sendOscInput(data);
        break;
      case OutputMode.virtualGamepad:
        _keyboardService.releaseAllKeys();
        _relayVirtualGamepad(data);
        break;
      case OutputMode.keyboardWasd:
        _sendWasdInput(data);
        break;
      case OutputMode.none:
        _keyboardService.releaseAllKeys();
        break;
    }
  }

  /// 各出力モードに応じたジャンプ信号の発行
  void _dispatchJumpSignal() {
    switch (_config.outputMode) {
      case OutputMode.keyboardWasd:
        _keyboardService.sendSpaceKey(true);
        Timer(Duration(milliseconds: _config.jumpHoldMs), () {
          _keyboardService.sendSpaceKey(false);
          notifyListeners();
        });
        break;
      case OutputMode.oscInputController:
        _oscService.sendInt('/input/Jump', 1);
        Timer(Duration(milliseconds: _config.jumpHoldMs), () {
          _oscService.sendInt('/input/Jump', 0);
          notifyListeners();
        });
        break;
      case OutputMode.virtualGamepad:
        // 仮想ゲームパッド A ボタンパースト
        break;
      case OutputMode.none:
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

  /// WASD キーボード入力をエミュレート
  void _sendWasdInput(SensorData data) {
    double rawX = data.centerX;
    double rawY = data.centerY;

    if (_config.invertWasdX) rawX = -rawX;
    if (_config.invertWasdY) rawY = -rawY;

    double threshold = _config.wasdThreshold;

    bool w = rawY > threshold;
    bool s = rawY < -threshold;
    bool d = rawX > threshold;
    bool a = rawX < -threshold;

    _keyboardService.updateKeyStates(w: w, a: a, s: s, d: d);
  }

  /// 仮想ゲームパッド入力中継（OSC / WASD モード時は OFF）
  void _relayVirtualGamepad(SensorData data) {
    // 仮想ゲームパッド出力処理
  }

  void disconnect() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
    _serialService.disconnect();
    _keyboardService.releaseAllKeys();
    _jumpDetector.reset();
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
    _keyboardService.dispose();
    _jumpDetector.dispose();
    super.dispose();
  }
}



