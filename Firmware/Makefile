# Firmware Makefile for BalanceBoard-Gamepad (PlatformIO)

.PHONY: all build upload monitor clean help

# Default target
all: build

## ビルド (PlatformIO compile)
build:
	pio run

## マイコンへの書き込み (Upload firmware to ESP32)
upload:
	pio run --target upload

## シリアルモニタ表示 (Open serial monitor)
monitor:
	pio device monitor

## ビルドキャッシュの削除 (Clean build artifacts)
clean:
	pio run --target clean

## ヘルプ表示 (Display available targets)
help:
	@echo "利用可能なターゲット:"
	@echo "  make build    - PlatformIOプロジェクトのビルド"
	@echo "  make upload   - ESP32へのファームウェア書き込み"
	@echo "  make monitor  - シリアルモニタの起動"
	@echo "  make clean    - ビルド生成物のクリーン"
