# itch.io Visual Assets & Media Guide

This guide details the specifications, layout suggestions, and visual guidelines for preparing images and video/GIF media for your [itch.io](https://itch.io) store page.

---

## 📐 itch.io Image Specifications

| Asset Type | Dimensions | Aspect Ratio | Format | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Cover Image** | `1260 x 1000 px` (min `630 x 500 px`) | **1.26 : 1** (630:500) | PNG / JPG | Main thumbnail shown in browse pages & search results |
| **Screenshots / GIFs** | `1920 x 1080 px` or `1280 x 720 px` | **16 : 9** | PNG / JPG / GIF / WebP | Carousel gallery on product page |
| **Banner / Header** | `960 x 400 px` (or up to `1920 x 400 px`) | Wide | PNG / JPG | Top banner for the custom page layout |

---

## 🖼 Asset Breakdown & Suggestions

### 1. Cover Image (`1260 x 1000 px`)
- **Key Focus**: Instant visual impact. Shows what the tool does in under a second.
- **Composition**:
  - **Left / Foreground**: Modern graphic/photo of a Wii Balance Board with dynamic glowing posture/force indicator arrows.
  - **Right / Background**: Futuristic HUD / Gamepad overlay + Flutter PC app interface with live Center of Gravity tracking dot.
  - **Text Badge**: 
    - Title: **BalanceBoard-Gamepad**
    - Subtitle: *Turn your Wii Balance Board into a PC Analog Controller*
    - Badges: `Windows & Mac` `Open Source` `No PC Bluetooth Needed`

---

### 2. Gallery Screenshots & Animated GIFs (3 to 5 items)

#### Slide 1 (GIF / WebP Animation): **Live Center of Gravity Visualizer**
- **Content**: Screen recording of the Flutter desktop app showing the live real-time dot moving inside the calibration circle as a player shifts weight forward/back/left/right.
- **Caption**: *Real-time Center of Gravity (CoG) & pressure visualizer with sensitivity controls.*

#### Slide 2 (Graphic): **Hardware & Connection Architecture**
- **Content**: Clean graphic diagram: `Wii Balance Board` ==[BT Classic]==> `ESP32 Board` ==[USB Cable]==> `PC (Bridge App)` ===> `Virtual Gamepad (XInput/DInput)`.
- **Caption**: *Plug & Play architecture. The ESP32 handles wireless connection directly.*

#### Slide 3 (Gameplay Collage): **Recommended Game Genres**
- **Content**: Split screen showing gameplay genres:
  - ✈️ Flight Simulator (Rudder / Pitch control)
  - 🏎️ Sim Racing (Body lean steering & pedal throttle)
  - 🏂 Snowboarding / Skiing games
  - 🥽 VRChat / VR Locomotion
- **Caption**: *Immersive analog control for flight, racing, VR, and winter sports games.*

#### Slide 4 (Screenshot): **Calibration & Deadzone Settings**
- **Content**: Close-up of app settings (Deadzone slider, Gain, Invert X/Y, Tare/Center zeroing button).
- **Caption**: *Fine-tune deadzones, sensitivity, and calibration for your playstyle.*

#### Slide 5 (Photo / Graphic): **What You Need (Inexpensive Hardware)**
- **Content**: Clean photo layout of a secondhand Wii Balance Board, ESP32 board, USB cable, and AA batteries with price estimations ($10–$20 total).
- **Caption**: *Breathe new life into thrifted Wii Balance Boards!*

---

## 🎬 Video & GIF Best Practices for itch.io

- itch.io supports animated `.gif` and `.png` in both screenshots and the main description.
- Keep GIF file sizes under **5 MB** for fast page loading.
- If creating a YouTube/Vimeo demo video, embed it directly at the top of the itch.io description.
