#ifndef SERIAL_PROTOCOL_H
#define SERIAL_PROTOCOL_H

#include "config.h"
#include "sensor_processor.h"

class SerialProtocol {
public:
    SerialProtocol(SensorProcessor& processor);
    void begin();
    void sendTelemetry(const ProcessedSensorData& data);
    void update();

private:
    SensorProcessor& sensorProcessor;
    void handleCommand(const String& jsonString);
};

#endif // SERIAL_PROTOCOL_H
