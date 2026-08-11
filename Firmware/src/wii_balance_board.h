#ifndef WII_BALANCE_BOARD_H
#define WII_BALANCE_BOARD_H

#include "config.h"
#include <ESP32Wiimote.h>

enum class WiiState {
    DISCONNECTED,
    SCANNING,
    CONNECTING,
    CONNECTED
};

class WiiBalanceBoard {
public:
    WiiBalanceBoard();
    bool begin();
    void update();
    bool isConnected() const;
    RawSensorData getRawData() const;

private:
    WiiState state;
    bool connected;
    RawSensorData rawData;
    ESP32Wiimote wiimote;

    void parseReport(const uint8_t* payload, size_t length);
};

extern WiiBalanceBoard* g_wiiBalanceBoard;

#endif // WII_BALANCE_BOARD_H
