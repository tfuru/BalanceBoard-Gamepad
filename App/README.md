# BalanceBoard-Gamepad 設定アプリ

Wii Balance Board と ESP32 を組み合わせた BalanceBoard-Gamepad の動作確認、リアルタイムモニタリング、各種キャリブレーション・感度調整を行うための **Flutter (Desktop)** アプリケーションです。

---

## 🛠 開発環境 & 技術スタック

- **フレームワーク**: [Flutter](https://flutter.dev/) (macOS / Windows / Linux デスクトップ対応)
- **言語**: Dart
- **前提条件**:
  - Flutter SDK がインストールされていること (`flutter doctor` で確認)
  - 使用ターゲット OS のデスクトップビルド環境 (Xcode, Visual Studio 等)

---

## 💡 主な機能 (予定)

- **リアルタイム重心モニタリング**: Wii Balance Board の4隅のセンサー値および重心位置 (`CustomPainter` によるグラフィカル表示)。
- **デバイス通信**: シリアル通信 (USB) または Bluetooth 通信による ESP32 とのリアルタイムデータ受発信。
- **キャリブレーション調整**: 零点補正および最大・最小感度の調整。
- **デッドゾーン & アナログマッピング設定**: ゲームパッドのアナログ軸 (X/Y軸、トリガー等) への割り当て変更。
- **プロファイル管理**: ゲームごとの設定プロファイルの保存・切り替え。

---

## 🚀 ビルド & 実行手順

`App` ディレクトリ内で以下のコマンドを実行します：

### 依存パッケージの取得
```bash
flutter pub get
```

### アプリの起動 (開発モード)
```bash
# macOS の場合
flutter run -d macos

# Windows の場合
flutter run -d windows

# Linux の場合
flutter run -d linux
```

### リリースビルドの生成
```bash
# macOS
flutter build macos

# Windows
flutter build windows
```

---

## 📁 ディレクトリ構造 (予定)

```text
App/
├── README.md         # 本ドキュメント
├── pubspec.yaml      # Flutter 依存関係・パッケージ設定
├── lib/              # Dart ソースコード
│   ├── main.dart     # エントリーポイント
│   ├── models/       # センサーデータ・設定モデル
│   ├── services/     # 通信サービス (Serial / Bluetooth)
│   └── views/        # UI画面 (モニタリング、設定画面)
├── assets/           # 画像・アイコン等のリソース
└── test/             # ユニットテスト
```

---

## 🔗 関連ドキュメント
- [ルート README](../README.md)
- [ファームウェア README](../Firmware/README.md)
