#ifndef CONFIG_H
#define CONFIG_H

#include <Arduino.h>

// シリアル通信設定
#define SERIAL_BAUD_RATE 115200

// Wii Balance Board 4隅のセンサー構造体
struct RawSensorData {
    uint16_t top_right;
    uint16_t bottom_right;
    uint16_t top_left;
    uint16_t bottom_left;
};

// 処理後のセンサー・重心データ構造体
struct ProcessedSensorData {
    uint16_t raw_tr;
    uint16_t raw_br;
    uint16_t raw_tl;
    uint16_t raw_bl;
    float weight_kg;    // 推定合計重量(kg)
    float center_x;     // 重心 X 軸 (-1.0 ~ +1.0)
    float center_y;     // 重心 Y 軸 (-1.0 ~ +1.0)
    bool is_connected;  // Balance Board 接続状態
};

// フィルター・パラメーター初期値
#define MOVING_AVERAGE_WINDOW 5
#define DEFAULT_DEADZONE 0.05f

#endif // CONFIG_H
