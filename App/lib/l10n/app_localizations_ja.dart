// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'BalanceBoard Gamepad Relay';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'キャンセル';

  @override
  String get close => '閉じる';

  @override
  String get connected => '接続中';

  @override
  String get disconnected => '未接続';

  @override
  String get disconnectComplete => '切断完了';

  @override
  String get selectPortHint => 'COMポート選択';

  @override
  String get refreshPortsTooltip => 'ポート一覧更新';

  @override
  String get connectBtn => '接続';

  @override
  String get disconnectBtn => '切断';

  @override
  String get tareBtn => '風袋引き(ゼロ点調整)';

  @override
  String get helpTooltip => '接続手順・ヘルプ';

  @override
  String get settingsTooltip => '設定';

  @override
  String get dashboardTitle => 'リアルタイムセンサーステータス';

  @override
  String get totalWeight => '総重量';

  @override
  String get centerPosition => '重心位置';

  @override
  String get sensorsFourCorners => '4隅センサーRaw値';

  @override
  String get topLeft => '左上 (TL)';

  @override
  String get topRight => '右上 (TR)';

  @override
  String get bottomLeft => '左下 (BL)';

  @override
  String get bottomRight => '右下 (BR)';

  @override
  String get activeOutputMode => 'アクティブ出力モード';

  @override
  String get modeLabelVirtualGamepad => '仮想ゲームパッド';

  @override
  String get modeLabelOscInput => 'OSC as Input Controller';

  @override
  String get modeLabelWasd => 'WASD キーボード';

  @override
  String get modeLabelNone => '出力 OFF';

  @override
  String get wasdOutputState => 'WASD 出力状態';

  @override
  String get oscActiveOutput => 'OSC アクティブ送信値';

  @override
  String get gamepadActiveOutput => '仮想ゲームパッド アクティブ送信値';

  @override
  String get jumpActive => 'JUMP (SPACE / /input/Jump)';

  @override
  String get jumping => 'JUMPING!';

  @override
  String get normalState => '通常';

  @override
  String get settingsTitle => 'アプリ設定';

  @override
  String get languageSetting => '言語 / Language';

  @override
  String get outputModeSetting => '出力モード設定';

  @override
  String get modeVirtualGamepadDesc => 'OSC 経由で仮想 Xbox/vJoy 等にデータ送信';

  @override
  String get modeOscDesc => 'VRChat の /input/Horizontal, /input/Vertical 経由で移動';

  @override
  String get modeWasdDesc => '重心移動に応じて WASD キー入力を自動送信';

  @override
  String get modeNoneDesc => 'センサー受信のみ（外部入力を送信しない）';

  @override
  String get sensorSetting => 'センサー感度・デッドゾーン';

  @override
  String get deadzone => 'デッドゾーン';

  @override
  String get sensitivity => '感度 (Sensitivity)';

  @override
  String get oscDetailSetting => 'OSC 詳細設定';

  @override
  String get oscHost => 'OSC 送信先 Host (IP)';

  @override
  String get oscPort => 'OSC 送信先 Port';

  @override
  String get invertOscX => 'OSC X軸 (Horizontal) 反転';

  @override
  String get invertOscY => 'OSC Y軸 (Vertical) 反転';

  @override
  String get wasdDetailSetting => 'WASD 詳細設定';

  @override
  String get wasdThreshold => 'WASD 反応閾値';

  @override
  String get invertWasdX => 'WASD X軸 (A/D) 反転';

  @override
  String get invertWasdY => 'WASD Y軸 (W/S) 反転';

  @override
  String get jumpSetting => 'ジャンプ検出設定';

  @override
  String get enableJump => 'ジャンプ検出を有効化';

  @override
  String get jumpThreshold => 'ジャンプ検出 閾値 (kg)';

  @override
  String get fwUpdateTitle => 'ESP32 ファームウェアオンライン更新';

  @override
  String get targetPortSelect => '書き込み対象シリアルポート';

  @override
  String get fwTagSelect => 'ファームウェア Tag 選択';

  @override
  String get tagSelectHint => '書き込み Tag を選択してください';

  @override
  String get noReleasesFound => 'リリース情報が見つかりません';

  @override
  String get releaseFetchError => 'リリース一覧の取得に失敗しました';

  @override
  String get refreshReleases => 'リリース一覧更新';

  @override
  String get startFlashBtn => 'ファームウェア書き込み開始';

  @override
  String get flashingInProgress => 'ファームウェア書き込み中...';

  @override
  String get flashLogTitle => '書き込みログ';

  @override
  String get appVersionTitle => 'アプリバージョン情報';

  @override
  String get currentVersion => '現在のバージョン';

  @override
  String get latestVersion => '最新リリース';

  @override
  String get checkUpdateBtn => '更新を確認';

  @override
  String get checkingUpdate => '確認中...';

  @override
  String get updateAvailable => '新しいバージョンが利用可能です！';

  @override
  String get downloadLatest => '最新版をダウンロード';

  @override
  String get upToDate => '最新バージョンを使用中です';

  @override
  String get helpTitle => '接続手順・トラブルシューティング';

  @override
  String get helpSection1Title => '1. 全体概要とシステム構成';

  @override
  String get helpSection1Body =>
      '本アプリは、Wii Balance Board と ESP32 (Bluetooth) を接続し、センサーデータをシリアル通信経由で取得して PC 上で OSC や WASD キーボード入力などに変換・中継するソフトです。';

  @override
  String get helpSection2Title => '2. 初回接続手順';

  @override
  String get helpSection2Step1 =>
      '1. ESP32 に専用ファームウェアを書き込みます（設定画面から直接オンライン更新が可能です）。';

  @override
  String get helpSection2Step2 =>
      '2. PC と ESP32 を USB ケーブルで接続し、アプリ上部で COM ポートを選択して「接続」ボタンを押します。';

  @override
  String get helpSection2Step3 =>
      '3. Wii Balance Board の電池カバー内にある赤い「SYNC」ボタンを押してペアリングを完了させます。';

  @override
  String get helpSection3Title => '3. 出力モードの選び方';

  @override
  String get helpSection3Osc =>
      '・OSC as Input Controller: VRChat などのアバター移動制御に最適です。';

  @override
  String get helpSection3Wasd =>
      '・WASD キーボード: 重心移動に応じて W/A/S/D キーを自動打鍵し、一般的 PC ゲームを操作できます。';

  @override
  String get helpSection4Title => '4. トラブルシューティング';

  @override
  String get helpSection4Item1 =>
      '・COMポートが表示されない場合: USBドライバ (CP210x / CH340等) が正しくインストールされているか確認してください。';

  @override
  String get helpSection4Item2 =>
      '・数値が安定しない / ズレている場合: バランスボード上に何も乗せずに「風袋引き(ゼロ点調整)」を押してください。';
}
