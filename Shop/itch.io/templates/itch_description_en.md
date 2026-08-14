# BalanceBoard-Gamepad: Turn Your Wii Balance Board into a PC Analog Controller 🎮

> **Breathe new life into your old Nintendo Wii Balance Board!**  
> Turn full-body weight shifts, leaning, and Center of Gravity into ultra-responsive analog gamepad inputs for PC games, simulators, and VR.

---

## ✨ Overview

**BalanceBoard-Gamepad** connects a standard **Wii Balance Board** to an **ESP32 microcontroller** over Bluetooth Classic, reads the 4 corner load cells at high frequency, and streams data over USB to a dedicated **Flutter PC bridge app** (Windows & macOS).

The desktop app converts your body's Center of Gravity (CoG) and total applied force into standard virtual gamepad axis inputs (DirectInput / XInput), complete with real-time visual monitoring, calibration, tare, and deadzone tuning!

---

## 🕹️ Perfect for These Game Genres:

- ✈️ **Flight & Space Simulators**: Lean left/right for rudder roll, lean forward/back for pitch/elevator control.
- 🏎️ **Racing & Driving Games**: Tilt your body for natural cornering, or shift weight between toes and heels for gas and brake.
- 🏂 **Snowboarding & Skiing Games**: Carve through snow and pull off tricks using real physical edge work!
- 🥽 **VR & Metaverse (VRChat)**: Stand and move your avatar naturally with subtle leaning without needing joystick locomotion.
- 🏃 **Fitness & Posture**: Active, engaging gaming that works your core and leg balance.

---

## 📦 What's Included in This Package:

1. ⚙️ **ESP32 Firmware**: Complete source code (PlatformIO) + ready-to-flash binary (`.bin`) for 1-click web flashing.
2. 💻 **PC Bridge Application**: Pre-compiled desktop apps for **Windows** (x64) and **macOS** (Universal Apple Silicon & Intel).
3. 📖 **Step-by-Step Setup Guide**: Detailed instructions with photos for flashing, connecting, and configuring.
4. 🖨️ **3D Printable Case (STL)**: Optional snap-fit enclosure models for popular ESP32 development boards.

---

## 🔌 Hardware Requirements (Inexpensive & Readily Available!)

You only need a few readily available parts:
- **Wii Balance Board** (Easily thrifted on eBay, Goodwill, or secondhand shops for ~$10–$25)
- **ESP32 Development Board** with Bluetooth Classic support (e.g. NodeMCU ESP32-WROOM-32, Adafruit HUZZAH32, Freenove ESP32-WROVER) (~$4–$8)
- **USB Cable** (ESP32 to PC)
- **4x AA Batteries** (for the Balance Board)
- **Windows 10/11 or macOS PC**

> 💡 **Note**: You **do NOT need Bluetooth on your PC**. The ESP32 handles all Bluetooth pairing directly with the board and sends clean serial data to your PC via USB.

---

## 🚀 Quick 3-Step Setup

1. **Flash the ESP32**: Flash the provided `.bin` file in seconds using Chrome Web Serial Flasher or PlatformIO.
2. **Launch the PC App**: Plug in your ESP32 via USB. The app automatically connects.
3. **Press SYNC on the Board**: Press the red SYNC button in the battery compartment once. You're connected! Watch your live Center of Gravity tracking on screen and jump into your favorite game.

---

## 🛠️ Key Features of the PC Bridge App

- **Live CoG Radar**: Visualizes your exact weight balance and 4-corner pressure in real time.
- **Deadzone & Gain Controls**: Fine-tune responsiveness to prevent jitter when resting.
- **Auto Tare / Center Calibration**: Zero out your baseline with one click.
- **System Tray Minimization**: Runs silently in the background while you play.

---

## 📄 License & Disclaimer

- Open source under the **MIT License**.
- This is a fan/maker open-source project and is **not affiliated with, endorsed by, or sponsored by Nintendo Co., Ltd.**
- "Wii" and "Wii Balance Board" are registered trademarks of Nintendo.
- Always use a non-slip surface and exercise caution while using balance boards.
