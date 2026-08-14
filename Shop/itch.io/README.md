# BalanceBoard-Gamepad - itch.io Store Listing Master

This document contains master listing data, configuration, tags, pricing, and FAQs for publishing **BalanceBoard-Gamepad** on [itch.io](https://itch.io).

---

## 🎯 Store Metadata & Settings

| Field | Configuration / Value |
| :--- | :--- |
| **Title** | `BalanceBoard-Gamepad: Turn Your Wii Balance Board into a PC Analog Controller` |
| **Short description / Tagline** | `Use weight shifting (lean & Center of Gravity) to control PC games, VR, flight/racing sims, and snowboarding games with a Wii Balance Board & ESP32!` |
| **Classification** | **Tools** (or Physical game / Input Utility) |
| **Kind of project** | **Downloadable** |
| **Release status** | **Released** |
| **Pricing Model** | **$0+ (Name your own price / Donation)**<br>• Suggested donation: **$3.00** or **$5.00** |
| **Tags** | `Controller`, `VR`, `Simulator`, `Hardware`, `Tools`, `Open Source`, `Accessibility`, `ESP32`, `Flutter`, `Wii Balance Board`, `Gamepad`, `Flight Sim`, `Racing`, `Snowboarding` |
| **Community** | Comments enabled |

---

## 📦 Downloadable Files on itch.io

When uploading the download files on itch.io, configure the following:

| File / Package | Platform Tags | Display Title / Description |
| :--- | :--- | :--- |
| `BalanceBoard-App-Windows.zip` | 🪟 Windows | **PC Bridge App for Windows (x64)** - Tray utility with real-time CoG visualizer & virtual gamepad output |
| `BalanceBoard-App-macOS.zip` | 🍎 macOS | **PC Bridge App for macOS (Universal/Apple Silicon & Intel)** |
| `ESP32-Firmware-Binaries.zip` | ⚙️ Executable | **ESP32 Pre-built Firmware (.bin)** - Ready to flash with Web Flasher or esptool |
| `SetupGuide-EN.pdf` / `.md` | 📄 Documentation | **Quick Setup & Hardware Assembly Guide** (Step-by-step with photos) |
| `3D-Case-STL-Files.zip` | 📦 3D Asset | **ESP32 Protective Case 3D Models (STL)** (Optional) |

---

## 🔌 Hardware Requirements (What users need)

List clearly for international buyers:
1. **Wii Balance Board** (Nintendo original; available secondhand on eBay, Yahoo Auctions, Goodwill, etc. for ~$10–$25)
2. **ESP32 Development Board** with Bluetooth Classic support (e.g., NodeMCU ESP32-WROOM-32, Adafruit HUZZAH32, Freenove ESP32-WROVER)
3. **USB Cable** (Micro-USB or USB-C depending on ESP32 board)
4. **4x AA Batteries** (for the Wii Balance Board)
5. **PC** (Windows 10/11 or macOS)

> [!NOTE]
> **No PC Bluetooth required**: The ESP32 handles all Bluetooth Classic communication with the Wii Balance Board and sends data to the PC over a wired USB serial connection.

---

## 🚀 Quick Setup (3 Steps)

1. **Flash the ESP32**: Use our 1-click web flasher or PlatformIO to upload the firmware to your ESP32.
2. **Launch PC App & Plug in ESP32**: The bridge app automatically detects the USB serial port.
3. **Press SYNC on the Balance Board**: Press the red SYNC button inside the battery compartment once. It connects instantly and streams real-time weight & Center of Gravity data to your PC game!

---

## ❓ Frequently Asked Questions (FAQ)

**Q. What is the maximum weight limit?**  
A. It adheres to the official Nintendo Wii Balance Board limit of up to **136 kg (300 lbs)**.

**Q. Does my PC need Bluetooth?**  
A. No! The ESP32 communicates with the Balance Board wirelessly and connects to your PC via USB cable.

**Q. Which games are compatible?**  
A. Any PC game supporting standard gamepads (DirectInput / XInput virtual controller). It is especially fun with flight simulators, racing games, snowboarding/skiing games, and VR movement (such as VRChat locomoting).

**Q. Is this an official Nintendo product?**  
A. No, this is an independent, open-source project. "Wii" and "Wii Balance Board" are trademarks of Nintendo.
