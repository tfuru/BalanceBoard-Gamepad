class AppConfig {
  String selectedPort;
  int baudRate;
  double sensitivity;
  double deadzone;
  bool autoConnect;

  AppConfig({
    this.selectedPort = '',
    this.baudRate = 115200,
    this.sensitivity = 1.0,
    this.deadzone = 0.05,
    this.autoConnect = false,
  });
}
