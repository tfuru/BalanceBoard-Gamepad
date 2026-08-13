import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BalanceBoard Gamepad Relay'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @disconnectComplete.
  ///
  /// In en, this message translates to:
  /// **'Disconnected successfully'**
  String get disconnectComplete;

  /// No description provided for @noPortSelected.
  ///
  /// In en, this message translates to:
  /// **'No serial port selected'**
  String get noPortSelected;

  /// No description provided for @connectFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectFailed;

  /// No description provided for @selectPortHint.
  ///
  /// In en, this message translates to:
  /// **'Select COM Port'**
  String get selectPortHint;

  /// No description provided for @refreshPortsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh port list'**
  String get refreshPortsTooltip;

  /// No description provided for @connectBtn.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectBtn;

  /// No description provided for @disconnectBtn.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectBtn;

  /// No description provided for @tareBtn.
  ///
  /// In en, this message translates to:
  /// **'Tare (Zero Calibration)'**
  String get tareBtn;

  /// No description provided for @helpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Realtime Sensor Status'**
  String get dashboardTitle;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get totalWeight;

  /// No description provided for @centerPosition.
  ///
  /// In en, this message translates to:
  /// **'Center of Gravity'**
  String get centerPosition;

  /// No description provided for @sensorsFourCorners.
  ///
  /// In en, this message translates to:
  /// **'4-Corner Sensor Raw Values'**
  String get sensorsFourCorners;

  /// No description provided for @topLeft.
  ///
  /// In en, this message translates to:
  /// **'Top Left (TL)'**
  String get topLeft;

  /// No description provided for @topRight.
  ///
  /// In en, this message translates to:
  /// **'Top Right (TR)'**
  String get topRight;

  /// No description provided for @bottomLeft.
  ///
  /// In en, this message translates to:
  /// **'Bottom Left (BL)'**
  String get bottomLeft;

  /// No description provided for @bottomRight.
  ///
  /// In en, this message translates to:
  /// **'Bottom Right (BR)'**
  String get bottomRight;

  /// No description provided for @activeOutputMode.
  ///
  /// In en, this message translates to:
  /// **'Active Output Mode'**
  String get activeOutputMode;

  /// No description provided for @modeLabelVirtualGamepad.
  ///
  /// In en, this message translates to:
  /// **'Virtual Gamepad'**
  String get modeLabelVirtualGamepad;

  /// No description provided for @modeLabelOscInput.
  ///
  /// In en, this message translates to:
  /// **'OSC as Input Controller'**
  String get modeLabelOscInput;

  /// No description provided for @modeLabelWasd.
  ///
  /// In en, this message translates to:
  /// **'WASD Keyboard'**
  String get modeLabelWasd;

  /// No description provided for @modeLabelNone.
  ///
  /// In en, this message translates to:
  /// **'Output OFF'**
  String get modeLabelNone;

  /// No description provided for @wasdOutputState.
  ///
  /// In en, this message translates to:
  /// **'WASD Output State'**
  String get wasdOutputState;

  /// No description provided for @oscActiveOutput.
  ///
  /// In en, this message translates to:
  /// **'OSC Active Transmitted Values'**
  String get oscActiveOutput;

  /// No description provided for @gamepadActiveOutput.
  ///
  /// In en, this message translates to:
  /// **'Virtual Gamepad Active Values'**
  String get gamepadActiveOutput;

  /// No description provided for @jumpActive.
  ///
  /// In en, this message translates to:
  /// **'JUMP (SPACE / /input/Jump)'**
  String get jumpActive;

  /// No description provided for @jumping.
  ///
  /// In en, this message translates to:
  /// **'JUMPING!'**
  String get jumping;

  /// No description provided for @normalState.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normalState;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get settingsTitle;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @outputModeSetting.
  ///
  /// In en, this message translates to:
  /// **'Output Mode Settings'**
  String get outputModeSetting;

  /// No description provided for @modeVirtualGamepadDesc.
  ///
  /// In en, this message translates to:
  /// **'Send data to virtual Xbox/vJoy device via OSC'**
  String get modeVirtualGamepadDesc;

  /// No description provided for @modeOscDesc.
  ///
  /// In en, this message translates to:
  /// **'Move via VRChat /input/Horizontal & /input/Vertical'**
  String get modeOscDesc;

  /// No description provided for @modeWasdDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically send WASD key presses based on weight shift'**
  String get modeWasdDesc;

  /// No description provided for @modeNoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Sensor reception only (no external output)'**
  String get modeNoneDesc;

  /// No description provided for @sensorSetting.
  ///
  /// In en, this message translates to:
  /// **'Sensor Sensitivity & Deadzone'**
  String get sensorSetting;

  /// No description provided for @deadzone.
  ///
  /// In en, this message translates to:
  /// **'Deadzone'**
  String get deadzone;

  /// No description provided for @sensitivity.
  ///
  /// In en, this message translates to:
  /// **'Sensitivity'**
  String get sensitivity;

  /// No description provided for @oscDetailSetting.
  ///
  /// In en, this message translates to:
  /// **'OSC Detailed Settings'**
  String get oscDetailSetting;

  /// No description provided for @oscHost.
  ///
  /// In en, this message translates to:
  /// **'OSC Destination Host (IP)'**
  String get oscHost;

  /// No description provided for @oscPort.
  ///
  /// In en, this message translates to:
  /// **'OSC Destination Port'**
  String get oscPort;

  /// No description provided for @invertOscX.
  ///
  /// In en, this message translates to:
  /// **'Invert OSC X-axis (Horizontal)'**
  String get invertOscX;

  /// No description provided for @invertOscY.
  ///
  /// In en, this message translates to:
  /// **'Invert OSC Y-axis (Vertical)'**
  String get invertOscY;

  /// No description provided for @wasdDetailSetting.
  ///
  /// In en, this message translates to:
  /// **'WASD Detailed Settings'**
  String get wasdDetailSetting;

  /// No description provided for @wasdThreshold.
  ///
  /// In en, this message translates to:
  /// **'WASD Trigger Threshold'**
  String get wasdThreshold;

  /// No description provided for @invertWasdX.
  ///
  /// In en, this message translates to:
  /// **'Invert WASD X-axis (A/D)'**
  String get invertWasdX;

  /// No description provided for @invertWasdY.
  ///
  /// In en, this message translates to:
  /// **'Invert WASD Y-axis (W/S)'**
  String get invertWasdY;

  /// No description provided for @jumpSetting.
  ///
  /// In en, this message translates to:
  /// **'Jump Detection Settings'**
  String get jumpSetting;

  /// No description provided for @enableJump.
  ///
  /// In en, this message translates to:
  /// **'Enable Jump Detection'**
  String get enableJump;

  /// No description provided for @jumpThreshold.
  ///
  /// In en, this message translates to:
  /// **'Jump Detection Threshold (kg)'**
  String get jumpThreshold;

  /// No description provided for @fwUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'ESP32 Firmware Online Update'**
  String get fwUpdateTitle;

  /// No description provided for @targetPortSelect.
  ///
  /// In en, this message translates to:
  /// **'Target Serial Port for Flashing'**
  String get targetPortSelect;

  /// No description provided for @fwTagSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Firmware Tag'**
  String get fwTagSelect;

  /// No description provided for @tagSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Please select a firmware tag to flash'**
  String get tagSelectHint;

  /// No description provided for @noReleasesFound.
  ///
  /// In en, this message translates to:
  /// **'No release information found'**
  String get noReleasesFound;

  /// No description provided for @releaseFetchError.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch release list'**
  String get releaseFetchError;

  /// No description provided for @refreshReleases.
  ///
  /// In en, this message translates to:
  /// **'Refresh Releases'**
  String get refreshReleases;

  /// No description provided for @startFlashBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Flashing Firmware'**
  String get startFlashBtn;

  /// No description provided for @flashingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Flashing firmware...'**
  String get flashingInProgress;

  /// No description provided for @flashLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashing Log'**
  String get flashLogTitle;

  /// No description provided for @appVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'App Version Information'**
  String get appVersionTitle;

  /// No description provided for @currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersion;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest Release'**
  String get latestVersion;

  /// No description provided for @checkUpdateBtn.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkUpdateBtn;

  /// No description provided for @checkingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checkingUpdate;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new version is available!'**
  String get updateAvailable;

  /// No description provided for @downloadLatest.
  ///
  /// In en, this message translates to:
  /// **'Download Latest Version'**
  String get downloadLatest;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'You are using the latest version'**
  String get upToDate;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Guide & Troubleshooting'**
  String get helpTitle;

  /// No description provided for @helpSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Overview & System Configuration'**
  String get helpSection1Title;

  /// No description provided for @helpSection1Body.
  ///
  /// In en, this message translates to:
  /// **'This application receives Wii Balance Board data via ESP32 (Bluetooth), reads sensor values over serial connection, and relays them as OSC or WASD keyboard input on your PC.'**
  String get helpSection1Body;

  /// No description provided for @helpSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. First-Time Connection Steps'**
  String get helpSection2Title;

  /// No description provided for @helpSection2Step1.
  ///
  /// In en, this message translates to:
  /// **'1. Flash the firmware onto ESP32 (you can update directly online via Settings).'**
  String get helpSection2Step1;

  /// No description provided for @helpSection2Step2.
  ///
  /// In en, this message translates to:
  /// **'2. Connect ESP32 to PC via USB cable, select the COM port in the top bar, and click \'Connect\'.'**
  String get helpSection2Step2;

  /// No description provided for @helpSection2Step3.
  ///
  /// In en, this message translates to:
  /// **'3. Press the red \'SYNC\' button inside the Wii Balance Board battery compartment to pair.'**
  String get helpSection2Step3;

  /// No description provided for @helpSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Choosing Output Mode'**
  String get helpSection3Title;

  /// No description provided for @helpSection3Osc.
  ///
  /// In en, this message translates to:
  /// **'・OSC as Input Controller: Recommended for avatar movement in VRChat.'**
  String get helpSection3Osc;

  /// No description provided for @helpSection3Wasd.
  ///
  /// In en, this message translates to:
  /// **'・WASD Keyboard: Automatically inputs W/A/S/D keys based on weight movement for PC games.'**
  String get helpSection3Wasd;

  /// No description provided for @helpSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Troubleshooting'**
  String get helpSection4Title;

  /// No description provided for @helpSection4Item1.
  ///
  /// In en, this message translates to:
  /// **'・COM Port missing: Ensure USB drivers (CP210x / CH340) are properly installed.'**
  String get helpSection4Item1;

  /// No description provided for @helpSection4Item2.
  ///
  /// In en, this message translates to:
  /// **'・Unstable / Off-center values: Clear the balance board and click \'Tare (Zero Calibration)\'.'**
  String get helpSection4Item2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
