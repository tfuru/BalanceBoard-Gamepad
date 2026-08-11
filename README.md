# BalanceBoard-Gamepad 🎮

Wii Balance Board と ESP-WROOM-32 (Adafruit HUZZAH32) を使用した、体感型アナログゲームパッド化プロジェクトです。

Wii Balance Board の4隅に搭載されている圧力・重量センサーの値を ESP32 で取得し、PC 向けのゲームパッド（アナログ入力）として認識させることができます。

---

## 🏗 システムアーキテクチャ

```mermaid
flowchart LR
    WBB["Wii Balance Board\n(圧力センサー ×4)"] -- Bluetooth Classic --> ESP["ESP-WROOM-32\n(HUZZAH32)"]
    ESP -- USB (HID/Gamepad) --> PC["PC / ゲーム機"]
    PC <--> App["設定アプリ\n(App)"]
```

---

## ✨ 特長・機能

- **体感型アナログ制御**: Wii Balance Board 上での体重移動（前・後・左・右・重心位置）をゲームパッドのアナログ入力（X/Y軸等）にマッピング。
- **簡単ビルド・書き込み (PlatformIO + Make)**: `make build` や `make upload` などのシンプルな Make コマンドでファームウェアの開発・管理が可能。
- **設定アプリ連携**: 重心のリアルタイムモニタリング、感度・デッドゾーン・キャリブレーションの調整をアプリで実施可能。

---

## 🔌 必要デバイス & ハードウェア

| デバイス / コンポーネント | 概要 / 入手先目安 |
| :--- | :--- |
| **Wii Balance Board** | 任天堂 Wii 用バランスボード（中古店等で約1,000円〜入手可能） |
| **ESP-WROOM-32 (Adafruit HUZZAH32)** | Bluetooth Classic 対応の ESP32 開発用ボード |
| **USB ケーブル** | ESP32 と PC 接続・給電用ケーブル |

---

## 🛠 開発・動作環境

- **ファームウェア**: [PlatformIO Core (CLI)](https://docs.platformio.org/) / `make`
- **PC設定アプリ**: [Flutter](https://flutter.dev/) (macOS / Windows / Linux デスクトップ対応)

---

## 🚀 クイックスタート (ファームウェアのビルド & 書き込み)

### 1. リポジトリのクローン
```bash
git clone https://github.com/.../BalanceBoard-Gamepad.git
cd BalanceBoard-Gamepad/Firmware
```

### 2. ファームウェアの操作 (Make コマンド)

[Firmware](./Firmware/README.md) ディレクトリ内で以下のコマンドを実行します：

```bash
# ファームウェアのビルド
make build

# ESP32 への書き込み
make upload

# シリアルモニタの起動
make monitor

# ビルド成果物の削除
make clean
```

---

## 📁 リポジトリ構造

```text
BalanceBoard-Gamepad/
├── README.md               # 本ドキュメント
├── Firmware/               # ESP32 用ファームウェア
│   ├── Makefile            # PlatformIO 操作用 Makefile
│   ├── README.md           # ファームウェア詳細ドキュメント
│   └── ...
└── App/                    # PC用設定アプリケーション
    ├── README.md           # 設定アプリ詳細ドキュメント
    └── ...
```

- 各コンポーネントの詳細は [ファームウェア README](./Firmware/README.md) および [設定アプリ README](./App/README.md) を参照してください。

---

## 📄 ライセンス

MIT License
