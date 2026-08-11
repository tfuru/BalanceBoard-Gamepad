#include "sensor_processor.h"
#include <cmath>

SensorProcessor::SensorProcessor()
    : deadzone(DEFAULT_DEADZONE), historyIndex(0) {
    tareOffset = {0, 0, 0, 0};
    for (int i = 0; i < MOVING_AVERAGE_WINDOW; i++) {
        historyX[i] = 0.0f;
        historyY[i] = 0.0f;
    }
}

void SensorProcessor::setTare() {
    // 現在の最新値を Tare (風袋引き) オフセットとして保存
}

void SensorProcessor::resetTare() {
    tareOffset = {0, 0, 0, 0};
}

float SensorProcessor::applyDeadzone(float value, float threshold) {
    if (std::abs(value) < threshold) {
        return 0.0f;
    }
    if (value > 0) {
        return (value - threshold) / (1.0f - threshold);
    } else {
        return (value + threshold) / (1.0f - threshold);
    }
}

void SensorProcessor::process(const RawSensorData& raw, bool isConnected, ProcessedSensorData& outData) {
    outData.is_connected = isConnected;
    outData.raw_tr = raw.top_right;
    outData.raw_br = raw.bottom_right;
    outData.raw_tl = raw.top_left;
    outData.raw_bl = raw.bottom_left;

    if (!isConnected) {
        outData.weight_kg = 0.0f;
        outData.center_x  = 0.0f;
        outData.center_y  = 0.0f;
        return;
    }

    // Tare (風袋引き) オフセット適用
    int32_t tr = (int32_t)raw.top_right    - tareOffset.top_right;
    int32_t br = (int32_t)raw.bottom_right - tareOffset.bottom_right;
    int32_t tl = (int32_t)raw.top_left     - tareOffset.top_left;
    int32_t bl = (int32_t)raw.bottom_left  - tareOffset.bottom_left;

    if (tr < 0) tr = 0;
    if (br < 0) br = 0;
    if (tl < 0) tl = 0;
    if (bl < 0) bl = 0;

    int32_t totalRaw = tr + br + tl + bl;
    
    // 重量換算 (概算スケールファクター)
    outData.weight_kg = totalRaw / 100.0f;

    if (totalRaw < 50) { // 極小荷重時は中心(0,0)とする
        outData.center_x = 0.0f;
        outData.center_y = 0.0f;
        return;
    }

    // 重心位置 (X: 右+ 左-, Y: 前+ 後-) の算出 (-1.0 ~ +1.0)
    float rawX = (float)((tr + br) - (tl + bl)) / (float)totalRaw;
    float rawY = (float)((tr + tl) - (br + bl)) / (float)totalRaw;

    // 移動平均フィルターの適用
    historyX[historyIndex] = rawX;
    historyY[historyIndex] = rawY;
    historyIndex = (historyIndex + 1) % MOVING_AVERAGE_WINDOW;

    float sumX = 0.0f, sumY = 0.0f;
    for (int i = 0; i < MOVING_AVERAGE_WINDOW; i++) {
        sumX += historyX[i];
        sumY += historyY[i];
    }
    float avgX = sumX / MOVING_AVERAGE_WINDOW;
    float avgY = sumY / MOVING_AVERAGE_WINDOW;

    // デッドゾーン適用
    outData.center_x = applyDeadzone(avgX, deadzone);
    outData.center_y = applyDeadzone(avgY, deadzone);
}
