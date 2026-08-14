# Freenove ESP32-WROVER 向けケース設計 (OpenSCAD)

本ディレクトリには、**Freenove ESP32-WROVER Dev Board (FNK0090)** 開発ボード専用の 3D プリントケース設計スクリプト（OpenSCAD）を格納しています。

---

## 📐 ボード概要 & 寸法

- **対象ボード**: Freenove ESP32-WROVER Dev Board (FNK0090)
- **ボード外形寸法**: 約 68.0mm × 28.0mm × 10.0mm (ピンヘッダ除く)
- **取付ネジ穴間隔**: 
  - X軸: `61.0mm`
  - Y軸: `22.0mm`
- **インターフェース**:
  - Micro-USB または USB-C ポート（給電 & USB シリアル通信）
  - EN (Reset) / BOOT ボタン
  - ESP32-WROVER モジュール & PCB アンテナ
  - カメラモジュールソケット（天面クリアランス確保）

---

## 📁 ファイル構成

```text
esp32-wrover/
├── README.md                 # 本ドキュメント
├── wrover_case.scad          # OpenSCAD パラメトリックモデルスクリプト
├── wrover_case_top.stl       # トップカバー STL（生成物）
└── wrover_case_bottom.stl    # ボトムケース STL（生成物）
```

---

## ⚙️ 主な設計パラメータ (`wrover_case.scad`)

OpenSCAD の Customizer またはスクリプト先頭の変数を変更することで、お使いの環境に合わせて微調整が可能です。

| パラメータ名 | デフォルト値 | 説明 |
| :--- | :--- | :--- |
| `part` | `"preview"` | レンダリング対象 (`"preview"` / `"all"` / `"bottom"` / `"top"` / `"exploded"`) |
| `wall_t` | `2.0 mm` | ケース側壁の厚み |
| `floor_t` / `lid_t` | `2.0 mm` / `2.0 mm` | 底面および天面の厚み |
| `clearance` | `0.6 mm` | 基板外周クリアランス（遊び） |
| `screw_hole_dia` | `2.4 mm` | M2 / M2.5 ネジ下穴 / 熱圧入インサートナット用穴径 |
| `boss_outer_dia` | `5.4 mm` | ネジ固定ボスの外径 |
| `usb_cutout_w` / `_h` | `12.0 mm` / `7.5 mm` | Micro-USB / Type-C 兼用開口サイズ |
| `antenna_vent_enable` | `true` | アンテナ側スリットの有無 |
| `button_holes_enable` | `true` | EN / BOOT ボタン穴の有無 |
| `top_vents_enable` | `true` | 天面放熱スリットの有無 |
| `bottom_vents_enable`| `true` | 底面通気スリットの有無 |

---

## 🚀 STL 生成コマンド (CLI)

OpenSCAD CLI を使用して STL を書き出せます：

```bash
# ボトムケースの書き出し
openscad -o wrover_case_bottom.stl -D 'part="bottom"' wrover_case.scad

# トップカバーの書き出し
openscad -o wrover_case_top.stl -D 'part="top"' wrover_case.scad

# 2パーツ一括出力用
openscad -o wrover_case_all.stl -D 'part="all"' wrover_case.scad
```

---

## 🔩 組み立てガイド

1. **インサートナット挿入（推奨）**:
   - ボトムケースの四隅のボス穴に M2 または M2.5 熱圧入インサートナットをハンダゴテ等で垂直に圧入します。
2. **基板のセット**:
   - USB ポートの位置をボトムケースの開口部に合わせて差し込み、スタンドオフ上に水平に載せます。
3. **トップカバーの固定**:
   - 合わせ目リップ（凸凹）を合わせてトップカバーを被せ、M2 / M2.5 × 8mm ネジ 4 本で締め付けて固定します。
