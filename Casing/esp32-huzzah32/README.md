# Adafruit HUZZAH32 向けケース設計 (OpenSCAD)

本ディレクトリには、**Adafruit HUZZAH32 (Feather ESP32)** 開発ボード専用の 3D プリントケース設計スクリプト（OpenSCAD）を格納しています。

---

## 📐 ボード概要 & 寸法

- **対象ボード**: Adafruit HUZZAH32 – ESP32 Feather Board
- **ボード外形寸法**: 約 51.0mm × 22.8mm × 8.0mm
- **取付ネジ穴間隔**: 
  - X軸: `45.72mm` (1.8 インチ)
  - Y軸: `17.78mm` (0.7 インチ)
- **インターフェース**:
  - Micro-USB ポート（給電 & USB シリアル通信）
  - リセットボタン
  - JST-PH 2ピン バッテリーコネクタ（LiPo）
  - ESP32-WROOM モジュール部

---

## 📁 ファイル構成

```text
esp32-huzzah32/
├── README.md                 # 本ドキュメント
├── huzzah32_case.scad        # OpenSCAD パラメトリックモデルスクリプト
├── huzzah32_case_top.stl     # トップカバー STL（生成物）
└── huzzah32_case_bottom.stl  # ボトムケース STL（生成物）
```

---

## ⚙️ 主な設計パラメータ (`huzzah32_case.scad`)

OpenSCAD の Customizer またはスクリプト先頭の変数を変更することで、お使いの環境に合わせて微調整が可能です。

| パラメータ名 | デフォルト値 | 説明 |
| :--- | :--- | :--- |
| `part` | `"preview"` | レンダリング対象 (`"preview"` / `"all"` / `"bottom"` / `"top"` / `"exploded"`) |
| `wall_t` | `2.0 mm` | ケース側壁の厚み |
| `floor_t` / `lid_t` | `2.0 mm` / `1.8 mm` | 底面および天面の厚み |
| `clearance` | `0.6 mm` | 基板外周クリアランス（遊び） |
| `screw_hole_dia` | `2.4 mm` | M2 ネジ下穴 / 熱圧入インサートナット用穴径 |
| `boss_outer_dia` | `5.2 mm` | ネジ固定ボスの外径 |
| `jst_cutout_enable` | `true` | LiPo 用 JST コネクタ開口部の有無 |
| `reset_hole_enable`| `true` | リセットボタン用アクセス穴の有無 |
| `vent_slits_enable`| `true` | ケース底面通気スリットの有無 |

---

## 🚀 STL 生成コマンド (CLI)

OpenSCAD CLI を使用して STL を書き出せます：

```bash
# ボトムケースの書き出し
openscad -o huzzah32_case_bottom.stl -D 'part="bottom"' huzzah32_case.scad

# トップカバーの書き出し
openscad -o huzzah32_case_top.stl -D 'part="top"' huzzah32_case.scad

# 2パーツ一括出力用
openscad -o huzzah32_case_all.stl -D 'part="all"' huzzah32_case.scad
```

---

## 🔩 組み立てガイド

1. **インサートナット挿入（推奨）**:
   - ボトムケースの四隅のボス穴に M2 熱圧入インサートナット（深さ 3mm〜4mm）をハンダゴテ等で垂直に圧入します。
2. **基板のセット**:
   - Micro-USB ポートの位置をボトムケースの開口部に合わせて差し込み、スタンドオフ上に水平に載せます。
3. **トップカバーの固定**:
   - 合わせ目リップ（凸凹）を合わせてトップカバーを被せ、M2 × 6mm ネジ 4 本で締め付けて固定します。
