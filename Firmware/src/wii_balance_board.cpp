#include "wii_balance_board.h"

WiiBalanceBoard::WiiBalanceBoard()
    : connected(false) {
    rawData = {0, 0, 0, 0};
}

bool WiiBalanceBoard::begin() {
    // Bluetooth Classic L2CAP Host の初期化処理
    // 注: 実際のハードウェア動作時には ESP32 の BT Controller を L2CAP ソケットで確立
    connected = false;
    return true;
}

void WiiBalanceBoard::update() {
    // データ受信ルーチンおよび接続維持チェック
}

bool WiiBalanceBoard::isConnected() const {
    return connected;
}

RawSensorData WiiBalanceBoard::getRawData() const {
    return rawData;
}

void WiiBalanceBoard::parseReport(const uint8_t* payload, size_t length) {
    if (length < 8 || payload == nullptr) return;

    // Wii Balance Board 拡張レポートの解析 (4隅の圧力センサー)
    rawData.top_right    = (payload[0] << 8) | payload[1];
    rawData.bottom_right = (payload[2] << 8) | payload[3];
    rawData.top_left     = (payload[4] << 8) | payload[5];
    rawData.bottom_left  = (payload[6] << 8) | payload[7];
}
