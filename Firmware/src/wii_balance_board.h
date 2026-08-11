#ifndef WII_BALANCE_BOARD_H
#define WII_BALANCE_BOARD_H

#include "config.h"

class WiiBalanceBoard {
public:
    WiiBalanceBoard();
    bool begin();
    void update();
    bool isConnected() const;
    RawSensorData getRawData() const;

private:
    bool connected;
    RawSensorData rawData;
    void parseReport(const uint8_t* payload, size_t length);
};

#endif // WII_BALANCE_BOARD_H
