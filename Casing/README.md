# BalanceBoard-Gamepad 3Dプリントケース (Casing)

本ディレクトリでは、BalanceBoard-Gamepad プロジェクトで使用する ESP32 ボード（Adafruit HUZZAH32、Freenove ESP32-WROVER 等）を保護・設置するための 3D プリント用ケース設計データ（**OpenSCAD** スクリプト `.scad` および出力 STL）を管理しています。

---

## 📁 ディレクトリ構成

```text
Casing/
├── README.md                 # 本ドキュメント (共通ガイドライン・推奨プリント設定・CLI出力手順)
├── esp32-huzzah32/         # Adafruit HUZZAH32 (Feather) 向けケース
│   ├── README.md           # 個別寸法・パラメータ・組み立てガイド
│   └── huzzah32_case.scad  # OpenSCAD モデルスクリプト
└── esp32-wrover/           # Freenove ESP32-WROVER Dev Board 向けケース
    ├── README.md           # 個別寸法・パラメータ・組み立てガイド
    └── wrover_case.scad    # OpenSCAD モデルスクリプト
```

---

## 🔌 対応ボード & ケース仕様一覧

| ボード名 | 規格 / 特徴 | ディレクトリ | ケース特徴 |
| :--- | :--- | :--- | :--- |
| **Adafruit HUZZAH32** | Feather フォームファクタ / スリム | [esp32-huzzah32/](./esp32-huzzah32/) | コンパクト設計・Micro-USB ポート・リセットボタンアクセス |
| **Freenove ESP32-WROVER** | WROVER Dev Board / ピンヘッダ搭載 | [esp32-wrover/](./esp32-wrover/) | アンテナ部クリアランス確保・USB-C/Micro-B 対応・通気スリット |

---

## 🖨 3Dプリント推奨設定

FDM方式の一般的な 3D プリンタ（Bambu Lab、Prusa、Ender 等）での出力を想定した推奨スライサー設定です。

| 設定項目 | 推奨値 | 備考 |
| :--- | :--- | :--- |
| **推奨素材 (フィラメント)** | **PLA** / **PETG** | 耐久性・耐熱性を重視する場合は PETG 推奨 |
| **ノズル径** | 0.4 mm | 標準ノズル |
| **積層ピッチ (Layer Height)** | 0.20 mm (0.16 mm 〜 0.20 mm) | 精密な勘合が必要な場合は 0.16 mm |
| **インフィル率 (Infill)** | 20% 〜 30% | パターンは Gyroid または Grid 推奨 |
| **ウォール厚 (Wall Loops / Perimeters)** | 3 〜 4 周 (約 1.2mm 〜 1.6mm) | ネジ固定部の強度確保のため |
| **サポート (Supports)** | 原則不要 (設計による) | ポート穴のオーバーハングに必要に応じてツリーサポート適用 |
| **ビルドプレート密着性 (Brim)** | 通常不要 (反りやすい素材時は外周 Brim 5mm) | |

---

## 🔩 組み立て & 必要パーツ目安 (BOM)

ケースの組み立てや基板固定には、以下の汎用パーツを使用することを想定しています：

1. **固定ネジ**:
   - M2 または M2.5 × 4mm 〜 8mm なべネジ / 皿ネジ
2. **インサートナット (オプション)**:
   - M2 / M2.5 熱圧入インサートナット（ハンダゴテ等でケースボス部に埋め込み）
3. **滑り止め / 振動防止**:
   - 直径 6mm 〜 8mm の円形ウレタンゴム足（ケース底部に貼り付け）

---

## 🛠 OpenSCAD での編集 & STL エクスポート

本プロジェクトの CAD データは、コードベースの 3D CAD **[OpenSCAD](https://openscad.org/)** で管理されています。

### 1. GUI での操作 & パラメータ調整
1. OpenSCAD で各ボードフォルダの `.scad` ファイル（例: `huzzah32_case.scad`）を開きます。
2. スクリプト先頭のパラメータ（壁厚、クリアランス、ネジ穴径等）を変更して `F5`（プレビュー）で確認します。
3. `F6`（レンダー）を実行後、`F7` で STL ファイルとしてエクスポートします。

### 2. CLI による STL 自動書き出し
ターミナルから直接 STL ファイルを出力することも可能です：

```bash
# トップパーツのエクスポート例
openscad -o huzzah32_top.stl -D 'part="top"' huzzah32_case.scad

# ボトムパーツのエクスポート例
openscad -o huzzah32_bottom.stl -D 'part="bottom"' huzzah32_case.scad
```
