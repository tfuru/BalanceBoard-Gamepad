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

static void hidhCallback(void *handler_args, esp_event_base_t base, int32_t id, void *event_data) {
    if (g_wiiBalanceBoard && event_data) {
        esp_hidh_event_data_t *param = (esp_hidh_event_data_t *)event_data;
        g_wiiBalanceBoard->handleHidhEvent((esp_hidh_event_t)id, param);
    }
}

WiiBalanceBoard::WiiBalanceBoard()
    : state(WiiState::DISCONNECTED), connected(false), hasTargetAddress(false), lastDiscoveryTime(0), hidhDev(nullptr) {
    rawData = {0, 0, 0, 0};
    g_wiiBalanceBoard = this;
}

bool WiiBalanceBoard::begin() {
    connected = false;
    state = WiiState::DISCONNECTED;

    Serial.println("[WiiBalanceBoard] Bluetooth 初期化処理を開始中...");

    // ESP32 Bluetooth Controller 初期化
    if (!btStarted()) {
        if (!btStart()) {
            Serial.println("[WiiBalanceBoard] エラー: btStart 失敗");
            return false;
        }
    }

    if (esp_bluedroid_get_status() == ESP_BLUEDROID_STATUS_UNINITIALIZED) {
        if (esp_bluedroid_init() != ESP_OK) {
            Serial.println("[WiiBalanceBoard] エラー: esp_bluedroid_init 失敗");
            return false;
        }
    }

    if (esp_bluedroid_get_status() != ESP_BLUEDROID_STATUS_ENABLED) {
        if (esp_bluedroid_enable() != ESP_OK) {
            Serial.println("[WiiBalanceBoard] エラー: esp_bluedroid_enable 失敗");
            return false;
        }
    }

    // HID Host 初期化
    esp_hidh_config_t config = {
        .callback = hidhCallback,
        .event_stack_size = 4096,
        .callback_arg = nullptr,
    };

    if (esp_hidh_init(&config) != ESP_OK) {
        Serial.println("[WiiBalanceBoard] エラー: esp_hidh_init 失敗");
        return false;
    }

    // GAP コールバック登録
    esp_bt_gap_register_callback(gapCallback);
    esp_bt_gap_set_scan_mode(ESP_BT_CONNECTABLE, ESP_BT_GENERAL_DISCOVERABLE);

    Serial.println("[WiiBalanceBoard] Bluetooth Classic / HID Host 初期化成功。Balance Board スキャンを開始します...");
    startDiscovery();
    return true;
}

void WiiBalanceBoard::startDiscovery() {
    state = WiiState::SCANNING;
    lastDiscoveryTime = millis();
    Serial.println("[WiiBalanceBoard] デバイススキャン実行中 (10秒間)...");
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
            for (int i = 0; i < param->disc_res.num_prop; i++) {
                if (param->disc_res.prop[i].type == ESP_BT_GAP_DEV_PROP_BDNAME) {
                    char devName[64] = {0};
                    int len = (param->disc_res.prop[i].len < 63) ? param->disc_res.prop[i].len : 63;
                    memcpy(devName, param->disc_res.prop[i].val, len);
                    devName[len] = '\0';

                    Serial.printf("[WiiBalanceBoard] 検出機器: %s\n", devName);

                    if (strstr(devName, "RVL-WBC-01") != nullptr || strstr(devName, "Nintendo") != nullptr || strstr(devName, "Wii") != nullptr) {
                        Serial.printf("[WiiBalanceBoard] ★ Wii Balance Board 発見: %s ★ L2CAPオープン要求中...\n", devName);
                        memcpy(targetAddress, param->disc_res.bda, sizeof(esp_bd_addr_t));
                        hasTargetAddress = true;
                        state = WiiState::CONNECTING;
                        esp_bt_gap_cancel_discovery();
                        
                        // 実接続: ESP-IDF HID Host L2CAP オープン処理
                        esp_hidh_dev_open(targetAddress, ESP_HID_TRANSPORT_BT, 0);
                        break;
                    }
                }
            }
            break;
        }

        case ESP_BT_GAP_DISC_STATE_CHANGED_EVT: {
            if (param->disc_st_chg.state == ESP_BT_GAP_DISCOVERY_STOPPED) {
                if (!connected && state == WiiState::SCANNING) {
                    Serial.println("[WiiBalanceBoard] スキャン終了。12秒後に再試行中...");
                }
            }
            break;
        }

        default:
            break;
    }
}

void WiiBalanceBoard::sendReportMode() {
    if (!hidhDev) return;
    
    // LED 1 点灯コマンド (0x11)
    uint8_t cmdLed[] = { 0x02 };
    esp_hidh_dev_set_report(hidhDev, 0, 0x11, ESP_HID_REPORT_TYPE_OUTPUT, cmdLed, sizeof(cmdLed));

    // 連続レポート送信モード設定 (0x12 -> Report 0x32)
    uint8_t cmdMode[] = { 0x00, 0x32 };
    esp_hidh_dev_set_report(hidhDev, 0, 0x12, ESP_HID_REPORT_TYPE_OUTPUT, cmdMode, sizeof(cmdMode));
}

void WiiBalanceBoard::handleHidhEvent(esp_hidh_event_t event, esp_hidh_event_data_t *param) {
    switch (event) {
        case ESP_HIDH_OPEN_EVENT: {
            if (param->open.status == ESP_OK) {
                Serial.println("[WiiBalanceBoard] ★ L2CAP HID 通信の接続確立に成功! ★");
                hidhDev = param->open.dev;
                state = WiiState::CONNECTED;
                sendReportMode();
            } else {
                Serial.println("[WiiBalanceBoard] エラー: L2CAP HID 接続失敗");
                state = WiiState::DISCONNECTED;
                connected = false;
            }
            break;
        }

        case ESP_HIDH_INPUT_EVENT: {
            if (param->input.data != nullptr && param->input.length >= 8) {
                parseReport(param->input.data, param->input.length);
            }
            break;
        }

        case ESP_HIDH_CLOSE_EVENT: {
            Serial.println("[WiiBalanceBoard] 切断されました。");
            state = WiiState::DISCONNECTED;
            connected = false;
            hidhDev = nullptr;
            break;
        }

        default:
            break;
    }
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
