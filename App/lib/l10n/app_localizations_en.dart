// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BalanceBoard Gamepad Relay';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get disconnectComplete => 'Disconnected successfully';

  @override
  String get noPortSelected => 'No serial port selected';

  @override
  String get connectFailed => 'Connection failed';

  @override
  String get selectPortHint => 'Select COM Port';

  @override
  String get refreshPortsTooltip => 'Refresh port list';

  @override
  String get connectBtn => 'Connect';

  @override
  String get disconnectBtn => 'Disconnect';

  @override
  String get tareBtn => 'Tare (Zero Calibration)';

  @override
  String get helpTooltip => 'Help & Guide';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get dashboardTitle => 'Realtime Sensor Status';

  @override
  String get totalWeight => 'Total Weight';

  @override
  String get centerPosition => 'Center of Gravity';

  @override
  String get sensorsFourCorners => '4-Corner Sensor Raw Values';

  @override
  String get topLeft => 'Top Left (TL)';

  @override
  String get topRight => 'Top Right (TR)';

  @override
  String get bottomLeft => 'Bottom Left (BL)';

  @override
  String get bottomRight => 'Bottom Right (BR)';

  @override
  String get activeOutputMode => 'Active Output Mode';

  @override
  String get modeLabelVirtualGamepad => 'Virtual Gamepad';

  @override
  String get modeLabelOscInput => 'OSC as Input Controller';

  @override
  String get modeLabelWasd => 'WASD Keyboard';

  @override
  String get modeLabelNone => 'Output OFF';

  @override
  String get wasdOutputState => 'WASD Output State';

  @override
  String get oscActiveOutput => 'OSC Active Transmitted Values';

  @override
  String get gamepadActiveOutput => 'Virtual Gamepad Active Values';

  @override
  String get jumpActive => 'JUMP (SPACE / /input/Jump)';

  @override
  String get jumping => 'JUMPING!';

  @override
  String get normalState => 'Normal';

  @override
  String get settingsTitle => 'App Settings';

  @override
  String get languageSetting => 'Language';

  @override
  String get outputModeSetting => 'Output Mode Settings';

  @override
  String get modeVirtualGamepadDesc =>
      'Send data to virtual Xbox/vJoy device via OSC';

  @override
  String get modeOscDesc =>
      'Move via VRChat /input/Horizontal & /input/Vertical';

  @override
  String get modeWasdDesc =>
      'Automatically send WASD key presses based on weight shift';

  @override
  String get modeNoneDesc => 'Sensor reception only (no external output)';

  @override
  String get sensorSetting => 'Sensor Sensitivity & Deadzone';

  @override
  String get deadzone => 'Deadzone';

  @override
  String get sensitivity => 'Sensitivity';

  @override
  String get oscDetailSetting => 'OSC Detailed Settings';

  @override
  String get oscHost => 'OSC Destination Host (IP)';

  @override
  String get oscPort => 'OSC Destination Port';

  @override
  String get invertOscX => 'Invert OSC X-axis (Horizontal)';

  @override
  String get invertOscY => 'Invert OSC Y-axis (Vertical)';

  @override
  String get wasdDetailSetting => 'WASD Detailed Settings';

  @override
  String get wasdThreshold => 'WASD Trigger Threshold';

  @override
  String get invertWasdX => 'Invert WASD X-axis (A/D)';

  @override
  String get invertWasdY => 'Invert WASD Y-axis (W/S)';

  @override
  String get jumpSetting => 'Jump Detection Settings';

  @override
  String get enableJump => 'Enable Jump Detection';

  @override
  String get jumpThreshold => 'Jump Detection Threshold (kg)';

  @override
  String get fwUpdateTitle => 'ESP32 Firmware Online Update';

  @override
  String get targetPortSelect => 'Target Serial Port for Flashing';

  @override
  String get fwTagSelect => 'Select Firmware Tag';

  @override
  String get tagSelectHint => 'Please select a firmware tag to flash';

  @override
  String get noReleasesFound => 'No release information found';

  @override
  String get releaseFetchError => 'Failed to fetch release list';

  @override
  String get refreshReleases => 'Refresh Releases';

  @override
  String get startFlashBtn => 'Start Flashing Firmware';

  @override
  String get flashingInProgress => 'Flashing firmware...';

  @override
  String get flashLogTitle => 'Flashing Log';

  @override
  String get appVersionTitle => 'App Version Information';

  @override
  String get currentVersion => 'Current Version';

  @override
  String get latestVersion => 'Latest Release';

  @override
  String get checkUpdateBtn => 'Check for Updates';

  @override
  String get checkingUpdate => 'Checking...';

  @override
  String get updateAvailable => 'A new version is available!';

  @override
  String get downloadLatest => 'Download Latest Version';

  @override
  String get upToDate => 'You are using the latest version';

  @override
  String get helpTitle => 'Connection Guide & Troubleshooting';

  @override
  String get helpSection1Title => '1. Overview & System Configuration';

  @override
  String get helpSection1Body =>
      'This application receives Wii Balance Board data via ESP32 (Bluetooth), reads sensor values over serial connection, and relays them as OSC or WASD keyboard input on your PC.';

  @override
  String get helpSection2Title => '2. First-Time Connection Steps';

  @override
  String get helpSection2Step1 =>
      '1. Flash the firmware onto ESP32 (you can update directly online via Settings).';

  @override
  String get helpSection2Step2 =>
      '2. Connect ESP32 to PC via USB cable, select the COM port in the top bar, and click \'Connect\'.';

  @override
  String get helpSection2Step3 =>
      '3. Press the red \'SYNC\' button inside the Wii Balance Board battery compartment to pair.';

  @override
  String get helpSection3Title => '3. Choosing Output Mode';

  @override
  String get helpSection3Osc =>
      '・OSC as Input Controller: Recommended for avatar movement in VRChat.';

  @override
  String get helpSection3Wasd =>
      '・WASD Keyboard: Automatically inputs W/A/S/D keys based on weight movement for PC games.';

  @override
  String get helpSection4Title => '4. Troubleshooting';

  @override
  String get helpSection4Item1 =>
      '・COM Port missing: Ensure USB drivers (CP210x / CH340) are properly installed.';

  @override
  String get helpSection4Item2 =>
      '・Unstable / Off-center values: Clear the balance board and click \'Tare (Zero Calibration)\'.';
}
