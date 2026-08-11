enum OutputMode {
  virtualGamepad,
  oscInputController,
  none,
}

extension OutputModeExtension on OutputMode {
  String get label {
    switch (this) {
      case OutputMode.virtualGamepad:
        return '仮想ゲームパッド';
      case OutputMode.oscInputController:
        return 'OSC as Input Controller';
      case OutputMode.none:
        return '出力 OFF';
    }
  }
}

class AppConfig {
  String selectedPort;
  int baudRate;
  double sensitivity;
  double deadzone;
  bool autoConnect;

  // 出力モード & OSC 設定
  OutputMode outputMode;
  String oscHost;
  int oscPort;
  bool invertOscX;
  bool invertOscY;

  AppConfig({
    this.selectedPort = '',
    this.baudRate = 115200,
    this.sensitivity = 1.0,
    this.deadzone = 0.05,
    this.autoConnect = false,
    this.outputMode = OutputMode.virtualGamepad,
    this.oscHost = '127.0.0.1',
    this.oscPort = 9000,
    this.invertOscX = false,
    this.invertOscY = false,
  });
}

