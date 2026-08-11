#include "wii_balance_board.h"
#include <esp_log.h>
#include <cstring>

static const char* TAG = "WiiBalanceBoard";
WiiBalanceBoard* g_wiiBalanceBoard = nullptr;

static void gapCallback(esp_bt_gap_cb_event_t event, esp_bt_gap_cb_param_t *param) {
    if (g_wiiBalanceBoard) {
        g_wiiBalanceBoard->handleGapCallback(event, param);
    }
}

WiiBalanceBoard::WiiBalanceBoard()
    : state(WiiState::DISCONNECTED), connected(false), hasTargetAddress(false), lastDiscoveryTime(0) {
    rawData = {0, 0, 0, 0};
    g_wiiBalanceBoard = this;
}

bool WiiBalanceBoard::begin() {
    connected = false;
    state = WiiState::DISCONNECTED;

    // ESP32 Bluetooth Controller 初期化 (Arduino HAL btStart() 使用)
    if (!btStarted()) {
        if (!btStart()) {
            ESP_LOGE(TAG, "btStart 失敗");
            return false;
        }
    }

    if (esp_bluedroid_get_status() == ESP_BLUEDROID_STATUS_UNINITIALIZED) {
        if (esp_bluedroid_init() != ESP_OK) {
            ESP_LOGE(TAG, "esp_bluedroid_init 失敗");
            return false;
        }
    }

    if (esp_bluedroid_get_status() != ESP_BLUEDROID_STATUS_ENABLED) {
        if (esp_bluedroid_enable() != ESP_OK) {
            ESP_LOGE(TAG, "esp_bluedroid_enable 失敗");
            return false;
        }
    }

    // GAP コールバック登録
    esp_bt_gap_register_callback(gapCallback);
    esp_bt_gap_set_scan_mode(ESP_BT_CONNECTABLE, ESP_BT_GENERAL_DISCOVERABLE);

    ESP_LOGI(TAG, "Bluetooth Classic 初期化成功。Balance Board スキャンを開始します...");
    startDiscovery();
    return true;
}

void WiiBalanceBoard::startDiscovery() {
    state = WiiState::SCANNING;
    lastDiscoveryTime = millis();
    esp_bt_gap_start_discovery(ESP_BT_INQ_MODE_GENERAL_INQUIRY, 10, 0);
}

void WiiBalanceBoard::update() {
    // スキャン定期再試行
    if (state == WiiState::SCANNING && !connected) {
        if (millis() - lastDiscoveryTime > 12000) { // 12秒ごとに再スキャン
            startDiscovery();
        }
    }
}

void WiiBalanceBoard::handleGapCallback(esp_bt_gap_cb_event_t event, esp_bt_gap_cb_param_t *param) {
    switch (event) {
        case ESP_BT_GAP_DISC_RES_EVT: {
            // スキャン結果の検証 (デバイス名の判定)
            for (int i = 0; i < param->disc_res.num_prop; i++) {
                if (param->disc_res.prop[i].type == ESP_BT_GAP_DEV_PROP_BDNAME) {
                    char devName[64] = {0};
                    int len = (param->disc_res.prop[i].len < 63) ? param->disc_res.prop[i].len : 63;
                    memcpy(devName, param->disc_res.prop[i].val, len);
                    devName[len] = '\0';

                    if (strstr(devName, "RVL-WBC-01") != nullptr || strstr(devName, "Nintendo") != nullptr) {
                        ESP_LOGI(TAG, "Wii Balance Board 発見: %s", devName);
                        memcpy(targetAddress, param->disc_res.bda, sizeof(esp_bd_addr_t));
                        hasTargetAddress = true;
                        state = WiiState::CONNECTING;
                        esp_bt_gap_cancel_discovery();
                        
                        // 仮接続確立ステート
                        connected = true;
                        break;
                    }
                }
            }
            break;
        }

        case ESP_BT_GAP_DISC_STATE_CHANGED_EVT: {
            if (param->disc_st_chg.state == ESP_BT_GAP_DISCOVERY_STOPPED) {
                if (!connected && state == WiiState::SCANNING) {
                    ESP_LOGI(TAG, "スキャン終了。再試行中...");
                }
            }
            break;
        }

        default:
            break;
    }
}

void WiiBalanceBoard::processDataReport(const uint8_t *payload, size_t length) {
    parseReport(payload, length);
}

void WiiBalanceBoard::parseReport(const uint8_t* payload, size_t length) {
    if (length < 8 || payload == nullptr) return;

    // Wii Balance Board 拡張レポートの解析 (4隅の圧力センサー: 16bit Big Endian)
    rawData.top_right    = (payload[0] << 8) | payload[1];
    rawData.bottom_right = (payload[2] << 8) | payload[3];
    rawData.top_left     = (payload[4] << 8) | payload[5];
    rawData.bottom_left  = (payload[6] << 8) | payload[7];
    connected = true;
}

bool WiiBalanceBoard::isConnected() const {
    return connected;
}

RawSensorData WiiBalanceBoard::getRawData() const {
    return rawData;
}
