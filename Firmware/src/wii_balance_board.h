#ifndef WII_BALANCE_BOARD_H
#define WII_BALANCE_BOARD_H

#include "config.h"
#include <esp_bt.h>
#include <esp_bt_main.h>
#include <esp_bt_device.h>
#include <esp_gap_bt_api.h>
#include <esp_hidh.h>

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
    
    // GAP & HIDH イベントハンドラ
    void handleGapCallback(esp_bt_gap_cb_event_t event, esp_bt_gap_cb_param_t *param);
    void handleHidhEvent(esp_hidh_event_t event, esp_hidh_event_data_t *param);

private:
    WiiState state;
    bool connected;
    RawSensorData rawData;
    esp_bd_addr_t targetAddress;
    bool hasTargetAddress;
    unsigned long lastDiscoveryTime;
    esp_hidh_dev_t *hidhDev;

    void startDiscovery();
    void sendReportMode();
    void parseReport(const uint8_t* payload, size_t length);
};

extern WiiBalanceBoard* g_wiiBalanceBoard;

#endif // WII_BALANCE_BOARD_H
