import 'dart:async';
import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../models/app_config.dart';
import '../services/serial_service.dart';

class GamepadProvider extends ChangeNotifier {
  final SerialService _serialService = SerialService();
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
        print('[PROVIDER RX] Parsing: $rawJson');
        _currentData = SensorData.fromRawString(rawJson);
        notifyListeners();
      });
    } else {
      _isSerialConnected = false;
      _statusMessage = '接続失敗: ${_config.selectedPort}';
    }

    notifyListeners();
    return success;
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
    super.dispose();
  }
}
