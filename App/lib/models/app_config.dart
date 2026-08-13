import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum OutputMode {
  virtualGamepad,
  oscInputController,
  keyboardWasd,
  none,
}

extension OutputModeExtension on OutputMode {
  String get label {
    switch (this) {
      case OutputMode.virtualGamepad:
        return '仮想ゲームパッド';
      case OutputMode.oscInputController:
        return 'OSC as Input Controller';
      case OutputMode.keyboardWasd:
        return 'WASD キーボード';
      case OutputMode.none:
        return '出力 OFF';
    }
  }

  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case OutputMode.virtualGamepad:
        return l10n.modeLabelVirtualGamepad;
      case OutputMode.oscInputController:
        return l10n.modeLabelOscInput;
      case OutputMode.keyboardWasd:
        return l10n.modeLabelWasd;
      case OutputMode.none:
        return l10n.modeLabelNone;
    }
  }
}

class AppConfig {
  Locale locale;
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

  // WASD モード設定
  double wasdThreshold;
  bool invertWasdX;
  bool invertWasdY;

  // ジャンプ検出設定
  bool enableJump;
  double jumpThresholdKg;
  int jumpHoldMs;

  AppConfig({
    this.locale = const Locale('en'),
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
    this.wasdThreshold = 0.15,
    this.invertWasdX = false,
    this.invertWasdY = false,
    this.enableJump = true,
    this.jumpThresholdKg = 5.0,
    this.jumpHoldMs = 150,
  });
}



