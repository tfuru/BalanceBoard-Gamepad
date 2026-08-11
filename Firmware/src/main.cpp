#include "config.h"
#include "wii_balance_board.h"
#include "sensor_processor.h"
#include "serial_protocol.h"

WiiBalanceBoard balanceBoard;
SensorProcessor sensorProcessor;
SerialProtocol serialProtocol(sensorProcessor);

unsigned long lastSendTime = 0;
const unsigned long SEND_INTERVAL_MS = 20; // 50Hz 周期でデータパケット送信

void setup() {
    serialProtocol.begin();
    balanceBoard.begin();
}

void loop() {
    balanceBoard.update();
    serialProtocol.update();

    unsigned long now = millis();
    if (now - lastSendTime >= SEND_INTERVAL_MS) {
        lastSendTime = now;

        RawSensorData raw = balanceBoard.getRawData();
        bool connected = balanceBoard.isConnected();
        ProcessedSensorData processed;

        sensorProcessor.process(raw, connected, processed);
        serialProtocol.sendTelemetry(processed);
    }
}
