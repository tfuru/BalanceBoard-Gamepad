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
            Serial.println("[WiiBalanceBoard] ★ Wii Balance Board 接続完了! LED1点灯 & モード0x32送信 ★");
            wiimote.setLeds(0x01);
            wiimote.setReportingMode((ReportingMode)0x32, true);
        } else {
            state = WiiState::DISCONNECTED;
            Serial.println("[WiiBalanceBoard] 切断されました。再スキャンします...");
            wiimote.startDiscovery();
        }
    }

    if (wiimote.available()) {
        TinyWiimoteData report = tinyWiimoteRead();
        parseReport(report.data, report.len);
    }
}

void WiiBalanceBoard::parseReport(const uint8_t* payload, size_t length) {
    if (length < 4 || payload == nullptr) return;

    uint8_t reportId = payload[1];

    // Report 0x32 または 0x34, 0x35 (拡張データを含むレポート)
    if (reportId == 0x32 || reportId == 0x34 || reportId == 0x35) {
        if (length >= 12) {
            // Extensionデータは offset 4 から始まります (8バイト)
            const uint8_t* ext = &payload[4];

            rawData.top_right    = (ext[0] << 8) | ext[1];
            rawData.bottom_right = (ext[2] << 8) | ext[3];
            rawData.top_left     = (ext[4] << 8) | ext[5];
            rawData.bottom_left  = (ext[6] << 8) | ext[7];
        }
    } else {
        Serial.printf("[WiiBalanceBoard] その他のレポート受信 (ID: 0x%02X, 長さ: %d)\n", reportId, (int)length);
    }
}

bool WiiBalanceBoard::isConnected() const {
    return connected;
}

RawSensorData WiiBalanceBoard::getRawData() const {
    return rawData;
}
