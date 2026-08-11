# BalanceBoard-Gamepad ファームウェア

Wii Balance Board と Bluetooth Classic 通信を行い、入力値を PC 向けのゲームパッド信号（USB HID 等）に変換して出力する ESP-WROOM-32 (Adafruit HUZZAH32) 用ファームウェアです。

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

## 📁 ディレクトリ構造 (予定)

```text
Firmware/
├── Makefile          # PlatformIO 操作用 Makefile
├── README.md         # ファームウェアドキュメント
├── platformio.ini    # PlatformIO 設定ファイル
└── src/              # ソースコード
    └── main.cpp      # メインプログラム
```

---

## 🔗 関連ドキュメント
- [ルート README](../README.md)
- [設定アプリ README](../App/README.md)
