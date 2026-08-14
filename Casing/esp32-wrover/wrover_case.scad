// ====================================================================
// BalanceBoard-Gamepad: Freenove ESP32-WROVER Dev Board Case
// Parametric 3D Printable Enclosure in OpenSCAD
// ====================================================================

/* [Render Options] */
// 出力パーツの選択
part = "preview"; // [preview: 全体プレビュー (基板モック付), all: 出力用並列配置, bottom: ボトムケースのみ, top: トップカバーのみ, exploded: 分解図]

// 円・曲面の分割数
$fn = $preview ? 32 : 64;

/* [Board Dimensions (Freenove ESP32-WROVER FNK0090)] */
// 基板長さ (X) [mm]
board_l = 68.0;
// 基板幅 (Y) [mm]
board_w = 28.0;
// 基板厚み (Z) [mm]
board_h = 1.6;
// 基板天面パーツ最大高さ (カメラ/ESP32モジュール/コンデンサ等) [mm]
board_comp_h_top = 8.5;
// 基板底面クリアランス / スタンドオフ高さ (ピンヘッダ足用) [mm]
standoff_h = 4.0;

/* [Mounting Holes] */
// ネジ穴X間隔 [mm]
hole_dist_x = 61.0;
// ネジ穴Y間隔 [mm]
hole_dist_y = 22.0;
// ネジ下穴 / インサート穴径 (M2/M2.5用) [mm]
screw_hole_dia = 2.4;
// ボス外径 [mm]
boss_outer_dia = 5.4;

/* [Case Parameters] */
// 側壁厚み [mm]
wall_t = 2.0;
// 底面厚み [mm]
floor_t = 2.0;
// 天面厚み [mm]
lid_t = 2.0;
// 基板周囲クリアランス [mm]
clearance = 0.6;
// 外周角丸半径 [mm]
corner_r = 3.5;
// 合わせ目リップの高さ [mm]
lip_h = 1.4;
// 合わせ目リップのクリアランス [mm]
lip_clearance = 0.2;

/* [Cutout & Opening Features] */
// USB 開口部幅 (Micro-USB / Type-C 兼用) [mm]
usb_cutout_w = 12.0;
// USB 開口部高さ [mm]
usb_cutout_h = 7.5;
// アンテナ部通気スリットの有効化 (+X側)
antenna_vent_enable = true;
// EN / BOOT ボタンアクセス穴の有効化
button_holes_enable = true;
// ボタン穴径 [mm]
button_hole_dia = 3.2;
// 天面通気・放熱スリットの有効化
top_vents_enable = true;
// 底面通気スリットの有効化
bottom_vents_enable = true;


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
    color([0.2, 0.4, 0.8, 0.5]) wrover_bottom();
    translate([0, 0, floor_t + standoff_h]) wrover_mockup();
    color([0.8, 0.3, 0.3, 0.5]) 
        translate([0, 0, outer_h_bot + outer_h_top]) 
        rotate([180, 0, 0]) 
        wrover_top();
} 
else if (part == "exploded") {
    // 分解図プレビュー
    color([0.2, 0.4, 0.8, 0.8]) wrover_bottom();
    translate([0, 0, floor_t + standoff_h + 14]) wrover_mockup();
    color([0.8, 0.3, 0.3, 0.8]) 
        translate([0, 0, outer_h_bot + outer_h_top + 32]) 
        rotate([180, 0, 0]) 
        wrover_top();
}
else if (part == "bottom") {
    // ボトムケース単体（プリント向き）
    wrover_bottom();
} 
else if (part == "top") {
    // トップカバー単体（天面を下にしてプリント向き）
    translate([0, 0, outer_h_top]) 
    rotate([180, 0, 0]) 
    wrover_top();
} 
else if (part == "all") {
    // 2パーツ並列配置
    translate([0, -(outer_w/2 + 5), 0]) 
        wrover_bottom();
    translate([0, (outer_w/2 + 5), outer_h_top]) 
        rotate([180, 0, 0]) 
        wrover_top();
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
module wrover_bottom() {
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

        // USB 開口部 (-X側)
        translate([-outer_l/2 - 1, 0, floor_t + standoff_h + board_h + usb_cutout_h/2 - 1.5])
            cube([wall_t * 2 + 2, usb_cutout_w, usb_cutout_h], center = true);

        // アンテナ部スリット (+X側)
        if (antenna_vent_enable) {
            translate([outer_l/2 + 1, 0, floor_t + standoff_h + board_h + 1.5])
                cube([wall_t * 2 + 2, 14.0, 4.0], center = true);
        }

        // 底面通気スリット
        if (bottom_vents_enable) {
            for (x = [-20 : 8 : 20]) {
                translate([x, 0, -1])
                    rounded_box(2.2, inner_w - 7, floor_t + 2, 0.8);
            }
        }
    }

    // ネジ固定ボス & スタンドオフ (4隅)
    hx = hole_dist_x / 2;
    hy = hole_dist_y / 2;
    for (pos = [[-hx, -hy], [-hx, hy], [hx, -hy], [hx, hy]]) {
        translate([pos[0], pos[1], floor_t]) {
            difference() {
                cylinder(d = boss_outer_dia, h = standoff_h);
                translate([0, 0, -0.1])
                    cylinder(d = screw_hole_dia, h = standoff_h + 0.2);
            }
        }
    }
}

// --- トップカバー ---
module wrover_top() {
    difference() {
        // 天面外殻
        rounded_box(outer_l, outer_w, outer_h_top, corner_r);

        // 内部くり抜き
        translate([0, 0, -0.1])
            rounded_box(inner_l, inner_w, inner_h_top + 0.1, max(0.5, corner_r - wall_t));

        // 合わせ目リップ受け溝 (一段広い座繰り)
        translate([0, 0, -0.1])
            rounded_box(outer_l - wall_t + lip_clearance * 2, outer_w - wall_t + lip_clearance * 2, lip_h + 0.2, max(0.5, corner_r - wall_t/2));

        // USB 上部クリアランス逃げ (-X側)
        translate([-outer_l/2 - 1, 0, -0.1])
            cube([wall_t * 2 + 2, usb_cutout_w + 1.0, 3.5], center = true);

        // EN / BOOT ボタン穴 (USB付近 2箇所)
        if (button_holes_enable) {
            // EN (Reset) ボタン
            translate([-board_l/2 + 8.0, -board_w/2 + 6.0, -1])
                cylinder(d = button_hole_dia, h = outer_h_top + 2);

            // BOOT ボタン
            translate([-board_l/2 + 8.0, board_w/2 - 6.0, -1])
                cylinder(d = button_hole_dia, h = outer_h_top + 2);
        }

        // 天面通気・放熱スリット (ESP32モジュール上部)
        if (top_vents_enable) {
            for (x = [-6 : 7 : 18]) {
                translate([x, 0, -1])
                    rounded_box(2.0, inner_w - 9, outer_h_top + 2, 0.8);
            }
        }

        // M2 / M2.5 ネジ通し穴 & 皿ザグリ (4箇所)
        hx = hole_dist_x / 2;
        hy = hole_dist_y / 2;
        for (pos = [[-hx, -hy], [-hx, hy], [hx, -hy], [hx, hy]]) {
            translate([pos[0], pos[1], -1]) {
                // ネジシャフト通し穴
                cylinder(d = 2.4, h = outer_h_top + 2);
                // 皿頭/なべ頭ザグリ
                translate([0, 0, outer_h_top - 1.4])
                    cylinder(d = 4.8, h = 3);
            }
        }
    }
}

// --- 基板モックアップ（確認用） ---
module wrover_mockup() {
    color([0.1, 0.5, 0.2]) {
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

    // USB コネクタ (-X端)
    color([0.8, 0.8, 0.8])
        translate([-board_l/2 + 3.5, 0, board_h + 1.5])
            cube([7.5, 9.0, 3.2], center = true);

    // ESP32-WROVER モジュール (中央〜右寄り)
    color([0.3, 0.3, 0.3])
        translate([6, 0, board_h + 1.6])
            cube([25, 18, 3.3], center = true);

    // PCB アンテナ (+X端)
    color([0.15, 0.15, 0.15])
        translate([board_l/2 - 4.5, 0, board_h + 0.5])
            cube([7.0, 16.0, 1.0], center = true);

    // EN / BOOT ボタンモック
    if (button_holes_enable) {
        color([0.9, 0.9, 0.9]) {
            translate([-board_l/2 + 8.0, -board_w/2 + 6.0, board_h + 1.0])
                cylinder(d = 2.5, h = 2.0);
            translate([-board_l/2 + 8.0, board_w/2 - 6.0, board_h + 1.0])
                cylinder(d = 2.5, h = 2.0);
        }
    }
}
