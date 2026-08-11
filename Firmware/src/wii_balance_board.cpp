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

    wiimoteSetLogLevel(0); // ライブラリ側のデバッグログ出力を無効化
    wiimote.init();
    wiimote.startDiscovery();
    return true;
}

void WiiBalanceBoard::update() {
    wiimote.task();

    bool isConn = wiimote.isConnected();
    if (isConn != connected) {
        connected = isConn;
        if (connected) {
            state = WiiState::CONNECTED;
            wiimote.setLeds(0x01);
            
            // Extension 暗号化解除レジスタ初期化 (0x55 -> 0xA400F0, 0x00 -> 0xA400FB)
            uint8_t unencrypt1 = 0x55;
            wiimote.writeMemory(0x04, 0xA400F0, &unencrypt1, 1);
            delay(50);
            uint8_t unencrypt2 = 0x00;
            wiimote.writeMemory(0x04, 0xA400FB, &unencrypt2, 1);
            delay(50);
            
            // モード 0x32 (CoreButtonsExT8) 要求
            wiimote.setReportingMode((ReportingMode)0x32, true);
        } else {
            state = WiiState::DISCONNECTED;
            wiimote.startDiscovery();
        }
    }

    while (tinyWiimoteAvailable() > 0) {
        TinyWiimoteData report = tinyWiimoteRead();
        parseReport(report.data, report.len);
    }
}

void WiiBalanceBoard::parseReport(const uint8_t* payload, size_t length) {
    if (length < 4 || payload == nullptr) return;

    uint8_t reportId = payload[1];

    // 拡張データを含むレポート ID: 0x32, 0x34, 0x35
    if (reportId == 0x32 || reportId == 0x34 || reportId == 0x35) {
        if (length >= 12) {
            // Extension データは payload[4] 以降 8 バイト
            const uint8_t* ext = &payload[4];

            rawData.top_right    = (ext[0] << 8) | ext[1];
            rawData.bottom_right = (ext[2] << 8) | ext[3];
            rawData.top_left     = (ext[4] << 8) | ext[5];
            rawData.bottom_left  = (ext[6] << 8) | ext[7];
        }
    }
}

bool WiiBalanceBoard::isConnected() const {
    return connected;
}

RawSensorData WiiBalanceBoard::getRawData() const {
    return rawData;
}
