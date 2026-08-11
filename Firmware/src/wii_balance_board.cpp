#include "wii_balance_board.h"
#include <Arduino.h>

WiiBalanceBoard* g_wiiBalanceBoard = nullptr;

WiiBalanceBoard::WiiBalanceBoard()
    : state(WiiState::DISCONNECTED), connected(false) {
    rawData = {0, 0, 0, 0};
    g_wiiBalanceBoard = this;
}

bool WiiBalanceBoard::begin() {
    connected = false;
    state = WiiState::DISCONNECTED;

    Serial.println("[WiiBalanceBoard] ESP32Wiimote 初期化開始...");
    wiimote.init();
    wiimote.startDiscovery();
    Serial.println("[WiiBalanceBoard] スキャンを開始しました。Wii Balance BoardのSYNCボタンを押してください...");
    return true;
}

void WiiBalanceBoard::update() {
    wiimote.task();

    bool isConn = wiimote.isConnected();
    if (isConn != connected) {
        connected = isConn;
        if (connected) {
            state = WiiState::CONNECTED;
            Serial.println("[WiiBalanceBoard] ★ Wii Balance Board 接続完了! データ受信を開始します ★");
            wiimote.setReportingMode(ReportingMode::CoreButtonsAccelExt, true);
        } else {
            state = WiiState::DISCONNECTED;
            Serial.println("[WiiBalanceBoard] 切断されました。再スキャンします...");
            wiimote.startDiscovery();
        }
    }

    if (wiimote.available()) {
        TinyWiimoteData report = tinyWiimoteRead();
        if (report.len >= 8) {
            parseReport(report.data, report.len);
        }
    }
}

void WiiBalanceBoard::parseReport(const uint8_t* payload, size_t length) {
    if (length < 8 || payload == nullptr) return;

    // Wii Balance Board 4隅の圧力データ (16-bit Big Endian)
    rawData.top_right    = (payload[0] << 8) | payload[1];
    rawData.bottom_right = (payload[2] << 8) | payload[3];
    rawData.top_left     = (payload[4] << 8) | payload[5];
    rawData.bottom_left  = (payload[6] << 8) | payload[7];
}

bool WiiBalanceBoard::isConnected() const {
    return connected;
}

RawSensorData WiiBalanceBoard::getRawData() const {
    return rawData;
}
