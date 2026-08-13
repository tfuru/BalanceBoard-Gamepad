# Firmware Makefile for BalanceBoard-Gamepad (PlatformIO)

BOARD ?= featheresp32

.PHONY: all build build-all upload upload-feather upload-freenove monitor clean help

# Default target
all: build

## ビルド (PlatformIO compile for specified board)
build:
	pio run -e $(BOARD)

## 全ボードのビルド (PlatformIO compile all environments)
build-all:
	pio run

## マイコンへの書き込み (Upload firmware for specified board)
upload:
	pio run -e $(BOARD) --target upload

## Feather ESP32 への書き込み
upload-feather:
	pio run -e featheresp32 --target upload

## Freenove ESP32-WROVER への書き込み
upload-freenove:
	pio run -e freenove_esp32_wrover --target upload

## シリアルモニタ表示 (Open serial monitor)
monitor:
	pio device monitor

## ビルドキャッシュの削除 (Clean build artifacts)
clean:
	pio run --target clean

## ヘルプ表示 (Display available targets)
help:
	@echo "利用可能なターゲット:"
	@echo "  make build           - PlatformIOプロジェクトのビルド (デフォルト: BOARD=featheresp32)"
	@echo "                         例: BOARD=freenove_esp32_wrover make build"
	@echo "  make build-all       - すべての環境のビルド"
	@echo "  make upload          - ESP32へのファームウェア書き込み (デフォルト: BOARD=featheresp32)"
	@echo "                         例: BOARD=freenove_esp32_wrover make upload"
	@echo "  make upload-feather  - Feather ESP32 への書き込み"
	@echo "  make upload-freenove - Freenove ESP32-WROVER への書き込み"
	@echo "  make monitor         - シリアルモニタの起動"
	@echo "  make clean           - ビルド生成物のクリーン"

