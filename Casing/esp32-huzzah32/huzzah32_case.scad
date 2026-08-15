// ====================================================================
// BalanceBoard-Gamepad: Adafruit HUZZAH32 (Feather) Case
// Parametric 3D Printable Enclosure in OpenSCAD
// ====================================================================

/* [Render Options] */
// 出力パーツの選択
part = "preview"; // [preview: 全体プレビュー (基板モック付), all: 出力用並列配置, bottom: ボトムケースのみ, top: トップカバーのみ, exploded: 分解図]

// 円・曲面の分割数
$fn = $preview ? 32 : 64;

/* [Board Dimensions (Adafruit Feather Standard)] */
// 基板長さ (X) [mm]
board_l = 51.0;
// 基板幅 (Y) [mm]
board_w = 22.8;
// 基板厚み (Z) [mm]
board_h = 1.6;
// 基板天面パーツ最大高さ (USB/ESP32モジュール等) [mm]
board_comp_h_top = 6.2;
// 基板底面クリアランス / スタンドオフ高さ [mm]
standoff_h = 3.0;

/* [Mounting Holes & Screws (M2 Standard Fastening)] */
// ネジ穴X間隔 (1.8inch = 45.72mm) [mm]
hole_dist_x = 45.72;
// ネジ穴Y間隔 (0.7inch = 17.78mm) [mm]
hole_dist_y = 17.78;
// M2 ネジ下穴径 (ボトムケース固定用: 1.9〜2.0mm) [mm]
screw_hole_dia = 2.0;
// M2 ネジ通し穴径 (トップカバー貫通用: 2.4mm) [mm]
screw_through_dia = 2.4;
// M2 ネジ頭部ザグリ径 (なべ頭・トラス頭用: 4.6mm) [mm]
screw_head_dia = 4.6;
// M2 ネジ頭部ザグリ深さ [mm]
screw_head_depth = 0.5;
// ボス外径 [mm]
boss_outer_dia = 5.2;

/* [Case Parameters] */
// 側壁厚み [mm]
wall_t = 2.0;
// 底面厚み [mm]
floor_t = 2.0;
// 天面厚み [mm]
lid_t = 1.8;
// 基板周囲クリアランス [mm]
clearance = 0.6;
// 外周角丸半径 [mm]
corner_r = 3.0;
// 合わせ目リップの高さ [mm]
lip_h = 1.2;
// 合わせ目リップのクリアランス [mm]
lip_clearance = 0.2;

/* [Cutout Features] */
// Micro-USB 開口部幅 [mm]
usb_cutout_w = 11.0;
// Micro-USB 開口部高さ (ボトム側) [mm]
usb_cutout_h = 7.0;
// Micro-USB 開口部高さ (トップ側) [mm]
usb_cutout_top_h = 4.0;
// JST バッテリーコネクタ開口部の有効化
jst_cutout_enable = true;
// JST 開口部幅 [mm]
jst_cutout_w = 9.5;
// JST コネクタ中心位置 (ネジ穴中心基準Xオフセット: 元位置より+5mm移動) [mm]
jst_offset_x = -hole_dist_x/2 + 10;
// リセットボタン穴の有効化
reset_hole_enable = false;
// リセットボタン中心位置 (USB端面からのX距離) [mm]
reset_btn_offset_x = 10.5;
// リセットボタン中心位置 (Y軸オフセット: RSTピン列側) [mm]
reset_btn_offset_y = -5.8;
// リセット穴径 [mm]
reset_hole_dia = 3.5;
// 底面通気スリットの有効化
vent_slits_enable = true;


// --- 計算パラメータ ---
inner_l = board_l + clearance * 2;
inner_w = board_w + clearance * 2;

outer_l = inner_l + wall_t * 2;
outer_w = inner_w + wall_t * 2;

inner_h_bot = standoff_h + board_h;
outer_h_bot = inner_h_bot + floor_t;

inner_h_top = board_comp_h_top + 0.5;
outer_h_top = inner_h_top + lid_t;


// ====================================================================
// メイン出力切替
// ====================================================================

if (part == "preview") {
    // プレビュー表示（透明ケース＋基板モック）
    color([0.2, 0.4, 0.8, 0.5]) huzzah32_bottom();
    translate([0, 0, floor_t + standoff_h]) board_mockup();
    color([0.8, 0.3, 0.3, 0.5]) 
        translate([0, 0, outer_h_bot + outer_h_top]) 
        rotate([180, 0, 0]) 
        huzzah32_top();
} 
else if (part == "exploded") {
    // 分解図プレビュー
    color([0.2, 0.4, 0.8, 0.8]) huzzah32_bottom();
    translate([0, 0, floor_t + standoff_h + 12]) board_mockup();
    color([0.8, 0.3, 0.3, 0.8]) 
        translate([0, 0, outer_h_bot + outer_h_top + 28]) 
        rotate([180, 0, 0]) 
        huzzah32_top();
}
else if (part == "bottom") {
    // ボトムケース単体（プリント向き）
    huzzah32_bottom();
} 
else if (part == "top") {
    // トップカバー単体（天面を下にしてプリント向き）
    translate([0, 0, outer_h_top]) 
    rotate([180, 0, 0]) 
    huzzah32_top();
} 
else if (part == "all") {
    // 2パーツ並列配置
    translate([0, -(outer_w/2 + 5), 0]) 
        huzzah32_bottom();
    translate([0, (outer_w/2 + 5), outer_h_top]) 
        rotate([180, 0, 0]) 
        huzzah32_top();
}


// ====================================================================
// モジュール定義
// ====================================================================

// --- 2D 角丸四角形押し出しヘルパー ---
module rounded_box(l, w, h, r) {
    linear_extrude(height = h) {
        offset(r = r) {
            square([l - 2*r, w - 2*r], center = true);
        }
    }
}

// --- ボトムケース ---
module huzzah32_bottom() {
    difference() {
        union() {
            // 外殻
            rounded_box(outer_l, outer_w, outer_h_bot, corner_r);
            
            // 合わせ目リップ（外周内側に凸）
            translate([0, 0, outer_h_bot])
                rounded_box(outer_l - wall_t, outer_w - wall_t, lip_h, max(0.5, corner_r - wall_t/2));
        }

        // 内部くり抜き
        translate([0, 0, floor_t])
            rounded_box(inner_l, inner_w, outer_h_bot + lip_h + 1, max(0.5, corner_r - wall_t));

        // Micro-USB 開口部 (-X側)
        translate([-outer_l/2 - 1, 0, floor_t + standoff_h + board_h + usb_cutout_h/2 - 1.5])
            cube([wall_t * 2 + 2, usb_cutout_w, usb_cutout_h], center = true);

        // JST バッテリーコネクタ開口部 (+Y側 / USB寄り)
        if (jst_cutout_enable) {
            translate([jst_offset_x, outer_w/2, floor_t + standoff_h + board_h + 3])
                cube([jst_cutout_w, wall_t * 2 + 2, 8], center = true);
        }

        // 底面通気スリット
        if (vent_slits_enable) {
            for (x = [-14 : 7 : 14]) {
                translate([x, 0, -1])
                    rounded_box(2.0, inner_w - 6, floor_t + 2, 0.8);
            }
        }
    }

    // ネジ固定ボス & スタンドオフ (M2貫通締結用)
    hx = hole_dist_x / 2;
    hy = hole_dist_y / 2;
    for (pos = [[-hx, -hy], [-hx, hy], [hx, -hy], [hx, hy]]) {
        translate([pos[0], pos[1], floor_t]) {
            difference() {
                cylinder(d = boss_outer_dia, h = standoff_h);
                // ボトム側下穴 (深さ: スタンドオフ + 底面半分)
                translate([0, 0, -floor_t/2])
                    cylinder(d = screw_hole_dia, h = standoff_h + floor_t + 0.2);
            }
        }
    }
}

// --- トップカバー ---
module huzzah32_top() {
    difference() {
        // 天面外殻
        rounded_box(outer_l, outer_w, outer_h_top, corner_r);

        // 内部くり抜き
        translate([0, 0, -0.1])
            rounded_box(inner_l, inner_w, inner_h_top + 0.1, max(0.5, corner_r - wall_t));

        // 合わせ目リップ受け溝 (一段広い座繰り)
        translate([0, 0, -0.1])
            rounded_box(outer_l - wall_t + lip_clearance * 2, outer_w - wall_t + lip_clearance * 2, lip_h + 0.2, max(0.5, corner_r - wall_t/2));

        // Micro-USB 上部クリアランス逃げ (高さ 4.0mm)
        translate([-outer_l/2 - 1, 0, usb_cutout_top_h / 2])
            cube([wall_t * 2 + 2, usb_cutout_w + 1.0, usb_cutout_top_h + 0.2], center = true);

        // JST バッテリーコネクタ逃げ・開口部 (+Y側側壁)
        if (jst_cutout_enable) {
            translate([jst_offset_x, outer_w/2, -0.1])
                cube([jst_cutout_w, wall_t * 2 + 2, inner_h_top * 2], center = true);
        }

        // リセットボタン穴 (RSTピン列側オフセット)
        if (reset_hole_enable) {
            translate([-board_l/2 + reset_btn_offset_x, reset_btn_offset_y, -1])
                cylinder(d = reset_hole_dia, h = outer_h_top + 2);
        }

        // M2 ネジ通し穴 & なべ頭・トラス頭用ザグリ (4箇所貫通固定)
        hx = hole_dist_x / 2;
        hy = hole_dist_y / 2;
        for (pos = [[-hx, -hy], [-hx, hy], [hx, -hy], [hx, hy]]) {
            translate([pos[0], pos[1], -1]) {
                // M2 ネジシャフト通し穴 (2.4mm)
                cylinder(d = screw_through_dia, h = outer_h_top + 2);
                // M2 ネジ頭部ザグリ (天面側: 4.6mm径 / 深さ 0.5mm)
                translate([0, 0, outer_h_top + 1 - screw_head_depth])
                    cylinder(d = screw_head_dia, h = screw_head_depth + 2);
            }
        }
    }
}

// --- 基板モックアップ（確認用） ---
module board_mockup() {
    color([0.1, 0.6, 0.2]) {
        difference() {
            // PCB 本体
            rounded_box(board_l, board_w, board_h, 1.5);

            // ネジ穴
            hx = hole_dist_x / 2;
            hy = hole_dist_y / 2;
            for (pos = [[-hx, -hy], [-hx, hy], [hx, -hy], [hx, hy]]) {
                translate([pos[0], pos[1], -1])
                    cylinder(d = 2.5, h = board_h + 2);
            }
        }
    }

    // Micro-USB コネクタ (-X側)
    color([0.8, 0.8, 0.8])
        translate([-board_l/2 + 2.5, 0, board_h + 1.5])
            cube([7.5, 8.0, 3.0], center = true);

    // ESP32-WROOM / HUZZAH32 モジュール (+X側)
    color([0.3, 0.3, 0.3])
        translate([8, 0, board_h + 1.6])
            cube([18, 16, 3.2], center = true);

    // JST コネクタ (+Y側)
    if (jst_cutout_enable) {
        color([0.2, 0.2, 0.2])
            translate([jst_offset_x, board_w/2 - 3.5, board_h + 3.75])
                cube([7.0, 6.0, 7.5], center = true);
    }

    // リセットボタン (-Y側 / RSTピン寄り)
    color([0.7, 0.7, 0.7])
        translate([-board_l/2 + reset_btn_offset_x, reset_btn_offset_y, board_h + 1.0])
            cube([3.5, 6.0, 2.0], center = true);
}
