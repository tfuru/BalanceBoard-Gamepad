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
  - リセットボタン（RSTピン側オフセット）
  - JST-PH 2ピン バッテリーコネクタ（LiPo）
  - ESP32-WROOM モジュール部

---

## 📁 ファイル構成

```text
esp32-huzzah32/
├── README.md                 # 本ドキュメント
├── huzzah32_case.scad        # OpenSCAD パラメトリックモデルスクリプト
├── huzzah32_case_top.stl     # トップカバー STL（生成物）
├── huzzah32_case_bottom.stl  # ボトムケース STL（生成物）
└── huzzah32_case_all.stl     # 2パーツ並列一括出力用 STL（生成物）
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
| `screw_hole_dia` | `2.0 mm` | ボトムケース側 M2 ネジ下穴径（直接締結・タッピング用） |
| `screw_through_dia` | `2.4 mm` | トップカバー側 M2 ネジシャフト通し穴径 |
| `screw_head_dia` | `4.6 mm` | M2 なべ頭・トラス頭ネジ用天面ザグリ径 |
| `screw_head_depth` | `0.5 mm` | 天面ネジ頭ザグリ深さ |
| `boss_outer_dia` | `5.2 mm` | ネジ固定ボス・スタンドオフの外径 |
| `usb_cutout_top_h` | `4.0 mm` | トップカバー側 Micro-USB 切り欠き高さ |
| `jst_cutout_enable` | `false` | JST バッテリーコネクタ開口部（無効：穴なし） |
| `jst_offset_x` | `-12.86 mm` | JST コネクタ中心位置（ネジ穴中心基準、元位置より+5mm移動） |
| `reset_hole_enable`| `false` | リセットボタン用アクセス穴（無効：穴なし） |
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

## 🔩 組み立てガイド (M2 貫通締結)

本ケースは、**トップカバー天面から 1 本の M2 長ネジでボトムケースまで貫通・締結**する設計となっています。

1. **基板のセット**:
   - Micro-USB ポートの位置をボトムケースの開口部に合わせて差し込み、四隅のスタンドオフボス上に水平に載せます。
2. **トップカバーの装着**:
   - 合わせ目リップ（凸凹）と JST コネクタ・Micro-USB の切り欠きを合わせて、上からトップカバーを被せます。
3. **M2 ネジによる貫通固定**:
   - 天面の 4 箇所のザグリ穴から **M2 × 10mm 〜 12mm なべネジ** を挿入し、ドライバーでボトムケースのネジ穴にねじ込んで均等に締め付けます。
