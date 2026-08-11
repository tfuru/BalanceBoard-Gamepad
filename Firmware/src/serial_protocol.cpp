#include "serial_protocol.h"
#include <ArduinoJson.h>

SerialProtocol::SerialProtocol(SensorProcessor& processor)
    : sensorProcessor(processor) {}

void SerialProtocol::begin() {
    Serial.begin(SERIAL_BAUD_RATE);
}

void SerialProtocol::sendTelemetry(const ProcessedSensorData& data) {
    StaticJsonDocument<256> doc;
    doc["conn"]   = data.is_connected;
    doc["tr"]     = data.raw_tr;
    doc["br"]     = data.raw_br;
    doc["tl"]     = data.raw_tl;
    doc["bl"]     = data.raw_bl;
    doc["weight"] = data.weight_kg;
    doc["x"]      = data.center_x;
    doc["y"]      = data.center_y;

    serializeJson(doc, Serial);
    Serial.println();
}

void SerialProtocol::update() {
    if (Serial.available()) {
        String input = Serial.readStringUntil('\n');
        input.trim();
        if (input.length() > 0) {
            handleCommand(input);
        }
    }
}

void SerialProtocol::handleCommand(const String& jsonString) {
    StaticJsonDocument<256> doc;
    DeserializationError error = deserializeJson(doc, jsonString);
    if (error) {
        return;
    }

    const char* cmd = doc["cmd"];
    if (cmd != nullptr) {
        if (strcmp(cmd, "tare") == 0) {
            sensorProcessor.setTare();
        } else if (strcmp(cmd, "reset_tare") == 0) {
            sensorProcessor.resetTare();
        }
    }
}
