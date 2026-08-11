# BalanceBoard-Gamepad 常駐中継アプリ 🔄

Wii Balance Board と ESP32 を組み合わせた BalanceBoard-Gamepad からのセンサーデータ（重心・重量）を USB シリアル経由で受領し、**PC 上のバックグラウンドで仮想ゲームパッド入力へリアルタイム変換・中継を行う Flutter (Desktop) アプリケーション** です。

---

## 💡 主な機能・役割

1. **バックグラウンド中継 & 仮想ゲームパッド変換**:
   - タスクトレイ / メニューバーに常駐し、ESP32 からの USB シリアルデータを受信。
   - 重心 (X, Y 軸) および重量データを PC の仮想コントローラー（XInput / DirectInput / OS Virtual Controller）としてゲームに中継。
2. **OSC as Input Controller モード (VRChat 対応)**:
   - Wii Balance Board の重心移動データを VRChat 向けの OSC メッセージ (`/input/Horizontal`, `/input/Vertical`) として UDP 送信 (デフォルト: `127.0.0.1:9000`)。
3. **WASD キーボードモード**:
   - 重心移動（前後左右）が閾値を超えた場合に、PC 上で W, A, S, D キー入力（KeyDown/KeyUp）をエミュレート。
   - キーボード操作専用の PC ゲームやシミュレーターに対応。
   - **※ 各出力モード（仮想ゲームパッド / OSC / WASD）は互いに排他制御されます。**
4. **ジャンプ検出機能 (Jump Detection)**:
   - バランスボード上で跳び上がった（足が浮いて合計重量が急減した）瞬間を検知し、自動でジャンプ信号を出力。
   - **WASD モード**: `Space` キー（スペースキー）入力
   - **OSC モード**: `/input/Jump` (`1` -> `0`) UDP 送信
   - **仮想ゲームパッドモード**: A ボタン入力

4. **リアルタイムモニタリング GUI**:
   - ウィンドウを開くことで、Wii Balance Board の4隅のセンサー値および重心位置を視覚的に表示 (`CustomPainter`)。
5. **キャリブレーション & カスタマイズ**:
   - 零点補正 (Tare) リセットコマンドの送信。
   - 感度・デッドゾーン・WASD 反応閾値・送信先 IP / ポート・軸反転の調整。

---

## 🛠 開発環境 & 技術スタック

- **フレームワーク**: [Flutter](https://flutter.dev/) (macOS / Windows / Linux デスクトップ)
- **言語**: Dart
- **前提条件**:
  - Flutter SDK (`flutter doctor`)
  - 各 OS のデスクトップビルド環境 (Xcode, Visual Studio 等)

---

## 🚀 ビルド & 実行手順

`App` ディレクトリ内で以下のコマンドを実行します：

### 依存パッケージの取得
```bash
flutter pub get
```

### アプリの起動 (開発モード)
```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

---

## 📁 ディレクトリ構造 (予定)

```text
App/
├── README.md         # 本ドキュメント
├── pubspec.yaml      # Flutter 依存関係設定
├── lib/              # Dart ソースコード
│   ├── main.dart     # エントリーポイント & 常駐トレイ初期化
│   ├── models/       # センサーデータ・プロファイルモデル
│   ├── services/     # USB シリアル受信 & 仮想 Gamepad 中継サービス
│   └── views/        # UI 画面 (モニタリング、キャリブレーション設定)
├── assets/           # トレイアイコン・画像リソース
└── test/             # ユニットテスト
```

---

## 🔗 関連ドキュメント
- [ルート README](../README.md)
- [ファームウェア README](../Firmware/README.md)
