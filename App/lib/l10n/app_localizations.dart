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
  /// In ja, this message translates to:
  /// **'BalanceBoard Gamepad Relay'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get close;

  /// No description provided for @connected.
  ///
  /// In ja, this message translates to:
  /// **'接続中'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In ja, this message translates to:
  /// **'未接続'**
  String get disconnected;

  /// No description provided for @disconnectComplete.
  ///
  /// In ja, this message translates to:
  /// **'切断完了'**
  String get disconnectComplete;

  /// No description provided for @selectPortHint.
  ///
  /// In ja, this message translates to:
  /// **'COMポート選択'**
  String get selectPortHint;

  /// No description provided for @refreshPortsTooltip.
  ///
  /// In ja, this message translates to:
  /// **'ポート一覧更新'**
  String get refreshPortsTooltip;

  /// No description provided for @connectBtn.
  ///
  /// In ja, this message translates to:
  /// **'接続'**
  String get connectBtn;

  /// No description provided for @disconnectBtn.
  ///
  /// In ja, this message translates to:
  /// **'切断'**
  String get disconnectBtn;

  /// No description provided for @tareBtn.
  ///
  /// In ja, this message translates to:
  /// **'風袋引き(ゼロ点調整)'**
  String get tareBtn;

  /// No description provided for @helpTooltip.
  ///
  /// In ja, this message translates to:
  /// **'接続手順・ヘルプ'**
  String get helpTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTooltip;

  /// No description provided for @dashboardTitle.
  ///
  /// In ja, this message translates to:
  /// **'リアルタイムセンサーステータス'**
  String get dashboardTitle;

  /// No description provided for @totalWeight.
  ///
  /// In ja, this message translates to:
  /// **'総重量'**
  String get totalWeight;

  /// No description provided for @centerPosition.
  ///
  /// In ja, this message translates to:
  /// **'重心位置'**
  String get centerPosition;

  /// No description provided for @sensorsFourCorners.
  ///
  /// In ja, this message translates to:
  /// **'4隅センサーRaw値'**
  String get sensorsFourCorners;

  /// No description provided for @topLeft.
  ///
  /// In ja, this message translates to:
  /// **'左上 (TL)'**
  String get topLeft;

  /// No description provided for @topRight.
  ///
  /// In ja, this message translates to:
  /// **'右上 (TR)'**
  String get topRight;

  /// No description provided for @bottomLeft.
  ///
  /// In ja, this message translates to:
  /// **'左下 (BL)'**
  String get bottomLeft;

  /// No description provided for @bottomRight.
  ///
  /// In ja, this message translates to:
  /// **'右下 (BR)'**
  String get bottomRight;

  /// No description provided for @activeOutputMode.
  ///
  /// In ja, this message translates to:
  /// **'アクティブ出力モード'**
  String get activeOutputMode;

  /// No description provided for @modeLabelVirtualGamepad.
  ///
  /// In ja, this message translates to:
  /// **'仮想ゲームパッド'**
  String get modeLabelVirtualGamepad;

  /// No description provided for @modeLabelOscInput.
  ///
  /// In ja, this message translates to:
  /// **'OSC as Input Controller'**
  String get modeLabelOscInput;

  /// No description provided for @modeLabelWasd.
  ///
  /// In ja, this message translates to:
  /// **'WASD キーボード'**
  String get modeLabelWasd;

  /// No description provided for @modeLabelNone.
  ///
  /// In ja, this message translates to:
  /// **'出力 OFF'**
  String get modeLabelNone;

  /// No description provided for @wasdOutputState.
  ///
  /// In ja, this message translates to:
  /// **'WASD 出力状態'**
  String get wasdOutputState;

  /// No description provided for @oscActiveOutput.
  ///
  /// In ja, this message translates to:
  /// **'OSC アクティブ送信値'**
  String get oscActiveOutput;

  /// No description provided for @gamepadActiveOutput.
  ///
  /// In ja, this message translates to:
  /// **'仮想ゲームパッド アクティブ送信値'**
  String get gamepadActiveOutput;

  /// No description provided for @jumpActive.
  ///
  /// In ja, this message translates to:
  /// **'JUMP (SPACE / /input/Jump)'**
  String get jumpActive;

  /// No description provided for @jumping.
  ///
  /// In ja, this message translates to:
  /// **'JUMPING!'**
  String get jumping;

  /// No description provided for @normalState.
  ///
  /// In ja, this message translates to:
  /// **'通常'**
  String get normalState;

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'アプリ設定'**
  String get settingsTitle;

  /// No description provided for @languageSetting.
  ///
  /// In ja, this message translates to:
  /// **'言語 / Language'**
  String get languageSetting;

  /// No description provided for @outputModeSetting.
  ///
  /// In ja, this message translates to:
  /// **'出力モード設定'**
  String get outputModeSetting;

  /// No description provided for @modeVirtualGamepadDesc.
  ///
  /// In ja, this message translates to:
  /// **'OSC 経由で仮想 Xbox/vJoy 等にデータ送信'**
  String get modeVirtualGamepadDesc;

  /// No description provided for @modeOscDesc.
  ///
  /// In ja, this message translates to:
  /// **'VRChat の /input/Horizontal, /input/Vertical 経由で移動'**
  String get modeOscDesc;

  /// No description provided for @modeWasdDesc.
  ///
  /// In ja, this message translates to:
  /// **'重心移動に応じて WASD キー入力を自動送信'**
  String get modeWasdDesc;

  /// No description provided for @modeNoneDesc.
  ///
  /// In ja, this message translates to:
  /// **'センサー受信のみ（外部入力を送信しない）'**
  String get modeNoneDesc;

  /// No description provided for @sensorSetting.
  ///
  /// In ja, this message translates to:
  /// **'センサー感度・デッドゾーン'**
  String get sensorSetting;

  /// No description provided for @deadzone.
  ///
  /// In ja, this message translates to:
  /// **'デッドゾーン'**
  String get deadzone;

  /// No description provided for @sensitivity.
  ///
  /// In ja, this message translates to:
  /// **'感度 (Sensitivity)'**
  String get sensitivity;

  /// No description provided for @oscDetailSetting.
  ///
  /// In ja, this message translates to:
  /// **'OSC 詳細設定'**
  String get oscDetailSetting;

  /// No description provided for @oscHost.
  ///
  /// In ja, this message translates to:
  /// **'OSC 送信先 Host (IP)'**
  String get oscHost;

  /// No description provided for @oscPort.
  ///
  /// In ja, this message translates to:
  /// **'OSC 送信先 Port'**
  String get oscPort;

  /// No description provided for @invertOscX.
  ///
  /// In ja, this message translates to:
  /// **'OSC X軸 (Horizontal) 反転'**
  String get invertOscX;

  /// No description provided for @invertOscY.
  ///
  /// In ja, this message translates to:
  /// **'OSC Y軸 (Vertical) 反転'**
  String get invertOscY;

  /// No description provided for @wasdDetailSetting.
  ///
  /// In ja, this message translates to:
  /// **'WASD 詳細設定'**
  String get wasdDetailSetting;

  /// No description provided for @wasdThreshold.
  ///
  /// In ja, this message translates to:
  /// **'WASD 反応閾値'**
  String get wasdThreshold;

  /// No description provided for @invertWasdX.
  ///
  /// In ja, this message translates to:
  /// **'WASD X軸 (A/D) 反転'**
  String get invertWasdX;

  /// No description provided for @invertWasdY.
  ///
  /// In ja, this message translates to:
  /// **'WASD Y軸 (W/S) 反転'**
  String get invertWasdY;

  /// No description provided for @jumpSetting.
  ///
  /// In ja, this message translates to:
  /// **'ジャンプ検出設定'**
  String get jumpSetting;

  /// No description provided for @enableJump.
  ///
  /// In ja, this message translates to:
  /// **'ジャンプ検出を有効化'**
  String get enableJump;

  /// No description provided for @jumpThreshold.
  ///
  /// In ja, this message translates to:
  /// **'ジャンプ検出 閾値 (kg)'**
  String get jumpThreshold;

  /// No description provided for @fwUpdateTitle.
  ///
  /// In ja, this message translates to:
  /// **'ESP32 ファームウェアオンライン更新'**
  String get fwUpdateTitle;

  /// No description provided for @targetPortSelect.
  ///
  /// In ja, this message translates to:
  /// **'書き込み対象シリアルポート'**
  String get targetPortSelect;

  /// No description provided for @fwTagSelect.
  ///
  /// In ja, this message translates to:
  /// **'ファームウェア Tag 選択'**
  String get fwTagSelect;

  /// No description provided for @tagSelectHint.
  ///
  /// In ja, this message translates to:
  /// **'書き込み Tag を選択してください'**
  String get tagSelectHint;

  /// No description provided for @noReleasesFound.
  ///
  /// In ja, this message translates to:
  /// **'リリース情報が見つかりません'**
  String get noReleasesFound;

  /// No description provided for @releaseFetchError.
  ///
  /// In ja, this message translates to:
  /// **'リリース一覧の取得に失敗しました'**
  String get releaseFetchError;

  /// No description provided for @refreshReleases.
  ///
  /// In ja, this message translates to:
  /// **'リリース一覧更新'**
  String get refreshReleases;

  /// No description provided for @startFlashBtn.
  ///
  /// In ja, this message translates to:
  /// **'ファームウェア書き込み開始'**
  String get startFlashBtn;

  /// No description provided for @flashingInProgress.
  ///
  /// In ja, this message translates to:
  /// **'ファームウェア書き込み中...'**
  String get flashingInProgress;

  /// No description provided for @flashLogTitle.
  ///
  /// In ja, this message translates to:
  /// **'書き込みログ'**
  String get flashLogTitle;

  /// No description provided for @appVersionTitle.
  ///
  /// In ja, this message translates to:
  /// **'アプリバージョン情報'**
  String get appVersionTitle;

  /// No description provided for @currentVersion.
  ///
  /// In ja, this message translates to:
  /// **'現在のバージョン'**
  String get currentVersion;

  /// No description provided for @latestVersion.
  ///
  /// In ja, this message translates to:
  /// **'最新リリース'**
  String get latestVersion;

  /// No description provided for @checkUpdateBtn.
  ///
  /// In ja, this message translates to:
  /// **'更新を確認'**
  String get checkUpdateBtn;

  /// No description provided for @checkingUpdate.
  ///
  /// In ja, this message translates to:
  /// **'確認中...'**
  String get checkingUpdate;

  /// No description provided for @updateAvailable.
  ///
  /// In ja, this message translates to:
  /// **'新しいバージョンが利用可能です！'**
  String get updateAvailable;

  /// No description provided for @downloadLatest.
  ///
  /// In ja, this message translates to:
  /// **'最新版をダウンロード'**
  String get downloadLatest;

  /// No description provided for @upToDate.
  ///
  /// In ja, this message translates to:
  /// **'最新バージョンを使用中です'**
  String get upToDate;

  /// No description provided for @helpTitle.
  ///
  /// In ja, this message translates to:
  /// **'接続手順・トラブルシューティング'**
  String get helpTitle;

  /// No description provided for @helpSection1Title.
  ///
  /// In ja, this message translates to:
  /// **'1. 全体概要とシステム構成'**
  String get helpSection1Title;

  /// No description provided for @helpSection1Body.
  ///
  /// In ja, this message translates to:
  /// **'本アプリは、Wii Balance Board と ESP32 (Bluetooth) を接続し、センサーデータをシリアル通信経由で取得して PC 上で OSC や WASD キーボード入力などに変換・中継するソフトです。'**
  String get helpSection1Body;

  /// No description provided for @helpSection2Title.
  ///
  /// In ja, this message translates to:
  /// **'2. 初回接続手順'**
  String get helpSection2Title;

  /// No description provided for @helpSection2Step1.
  ///
  /// In ja, this message translates to:
  /// **'1. ESP32 に専用ファームウェアを書き込みます（設定画面から直接オンライン更新が可能です）。'**
  String get helpSection2Step1;

  /// No description provided for @helpSection2Step2.
  ///
  /// In ja, this message translates to:
  /// **'2. PC と ESP32 を USB ケーブルで接続し、アプリ上部で COM ポートを選択して「接続」ボタンを押します。'**
  String get helpSection2Step2;

  /// No description provided for @helpSection2Step3.
  ///
  /// In ja, this message translates to:
  /// **'3. Wii Balance Board の電池カバー内にある赤い「SYNC」ボタンを押してペアリングを完了させます。'**
  String get helpSection2Step3;

  /// No description provided for @helpSection3Title.
  ///
  /// In ja, this message translates to:
  /// **'3. 出力モードの選び方'**
  String get helpSection3Title;

  /// No description provided for @helpSection3Osc.
  ///
  /// In ja, this message translates to:
  /// **'・OSC as Input Controller: VRChat などのアバター移動制御に最適です。'**
  String get helpSection3Osc;

  /// No description provided for @helpSection3Wasd.
  ///
  /// In ja, this message translates to:
  /// **'・WASD キーボード: 重心移動に応じて W/A/S/D キーを自動打鍵し、一般的 PC ゲームを操作できます。'**
  String get helpSection3Wasd;

  /// No description provided for @helpSection4Title.
  ///
  /// In ja, this message translates to:
  /// **'4. トラブルシューティング'**
  String get helpSection4Title;

  /// No description provided for @helpSection4Item1.
  ///
  /// In ja, this message translates to:
  /// **'・COMポートが表示されない場合: USBドライバ (CP210x / CH340等) が正しくインストールされているか確認してください。'**
  String get helpSection4Item1;

  /// No description provided for @helpSection4Item2.
  ///
  /// In ja, this message translates to:
  /// **'・数値が安定しない / ズレている場合: バランスボード上に何も乗せずに「風袋引き(ゼロ点調整)」を押してください。'**
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
