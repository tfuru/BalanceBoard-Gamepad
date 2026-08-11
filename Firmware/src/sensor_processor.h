#ifndef SENSOR_PROCESSOR_H
#define SENSOR_PROCESSOR_H

#include "config.h"

class SensorProcessor {
public:
    SensorProcessor();

    void process(const RawSensorData& raw, bool isConnected, ProcessedSensorData& outData);
    void setTare(const RawSensorData& raw);
    void setTare();
    void resetTare();

private:
    RawSensorData tareOffset;
    float deadzone;

    // 移動平均用バッファ
    float historyX[MOVING_AVERAGE_WINDOW];
    float historyY[MOVING_AVERAGE_WINDOW];
    int historyIndex;

    float applyDeadzone(float value, float threshold);
};

#endif // SENSOR_PROCESSOR_H
