# BalanceBoard-Gamepad ファームウェア

Wii Balance Board と Bluetooth Classic 通信を行い、取得したセンサー・重心データを USB シリアル通信 (115200bps / JSON) 経由で PC の **常駐中継アプリ (App)** へ送信する ESP-WROOM-32 (Adafruit HUZZAH32) 用ファームウェアです。

---

## 🛠 開発環境 (PlatformIO + Make)

本ファームウェアの開発・ビルド環境には **PlatformIO CLI / Core** および **Make** を使用します。

### 前提条件

- [PlatformIO Core (CLI)](https://docs.platformio.org/en/latest/core/index.html) のインストール
- `make` コマンドが実行できる環境 (macOS / Linux / Windows WSL / MSYS2 等)

---

## 🚀 使い方 (Make コマンド)

`Firmware` ディレクトリ内で以下の `make` コマンドを使用して操作を行います。

| コマンド | 説明 | 実行される PlatformIO コマンド |
| :--- | :--- | :--- |
| `make build` または `make` | ファームウェアのビルド | `pio run` |
| `make upload` | ESP32 へのファームウェア書き込み | `pio run --target upload` |
| `make monitor` | シリアルモニタの起動 | `pio device monitor` |
| `make clean` | ビルド成果物の削除 | `pio run --target clean` |
| `make help` | 利用可能なターゲットの表示 | - |

---

## 📁 ディレクトリ構造

```text
Firmware/
├── Makefile          # PlatformIO 操作用 Makefile
├── README.md         # ファームウェアドキュメント
├── platformio.ini    # PlatformIO 設定ファイル (`featheresp32`)
└── src/              # ソースコード
    ├── config.h             # 共通設定・定数
    ├── main.cpp            # メインプログラム
    ├── sensor_processor.cpp # 重心計算・フィルター処理
    ├── sensor_processor.h   # 重心計算ヘッダー
    ├── serial_protocol.cpp  # JSONシリアル通信プロトコル
    ├── serial_protocol.h    # シリアル通信ヘッダー
    ├── wii_balance_board.cpp# Wii Balance Board 接続処理
    └── wii_balance_board.h  # Wii Balance Board ヘッダー
```

---

## 🔗 関連ドキュメント
- [ルート README](../README.md)
- [常駐中継アプリ README](../App/README.md)
