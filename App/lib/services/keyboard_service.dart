import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

enum WasdKey { w, a, s, d }

/// Windows 64-bit (x64) INPUT 構造体 (SendInput API 用 - 40バイトアラインメント)
final class NativeInput extends Struct {
  @Uint32()
  external int type; // 4 bytes (offset 0) - INPUT_KEYBOARD = 1

  @Uint32()
  external int pad; // 4 bytes (offset 4) - 64bit アラインメントパディング

  @Uint16()
  external int wVk; // 2 bytes (offset 8)

  @Uint16()
  external int wScan; // 2 bytes (offset 10)

  @Uint32()
  external int dwFlags; // 4 bytes (offset 12)

  @Uint32()
  external int time; // 4 bytes (offset 16)

  @Uint32()
  external int pad2; // 4 bytes (offset 20) - 8バイトポインタパディング

  @Uint64()
  external int dwExtraInfo; // 8 bytes (offset 24) -> Total size = 40 bytes
}

/// WASD キーボード入力エミュレーションサービス
class KeyboardService {
  bool _isWPressed = false;
  bool _isAPressed = false;
  bool _isSPressed = false;
  bool _isDPressed = false;

  bool get isWPressed => _isWPressed;
  bool get isAPressed => _isAPressed;
  bool get isSPressed => _isSPressed;
  bool get isDPressed => _isDPressed;

  // macOS FFI Binding
  DynamicLibrary? _cgLib;
  Pointer<Void> Function(Pointer<Void>, int, bool)? _cgEventCreateKeyboardEvent;
  void Function(int, Pointer<Void>)? _cgEventPost;
  void Function(Pointer<Void>)? _cfRelease;

  // Windows FFI Binding (SendInput + MapVirtualKeyW + keybd_event)
  DynamicLibrary? _user32Lib;
  int Function(int, Pointer<NativeInput>, int)? _sendInput;
  int Function(int, int)? _mapVirtualKey;
  void Function(int, int, int, Pointer<Void>)? _keybdEvent;

  // macOS Accessibility Permission check
  bool Function()? _axIsProcessTrusted;

  KeyboardService() {
    _initFfi();
  }

  void _initFfi() {
    try {
      if (Platform.isMacOS) {
        _cgLib = DynamicLibrary.open('/System/Library/Frameworks/ApplicationServices.framework/ApplicationServices');

        _cgEventCreateKeyboardEvent = _cgLib!
            .lookup<NativeFunction<Pointer<Void> Function(Pointer<Void>, Uint16, Bool)>>('CGEventCreateKeyboardEvent')
            .asFunction();

        _cgEventPost = _cgLib!
            .lookup<NativeFunction<Void Function(Uint32, Pointer<Void>)>>('CGEventPost')
            .asFunction();

        _cfRelease = _cgLib!
            .lookup<NativeFunction<Void Function(Pointer<Void>)>>('CFRelease')
            .asFunction();

        try {
          _axIsProcessTrusted = _cgLib!
              .lookup<NativeFunction<Bool Function()>>('AXIsProcessTrusted')
              .asFunction();
        } catch (_) {}

        checkAccessibilityPermission();
      } else if (Platform.isWindows) {
        _user32Lib = DynamicLibrary.open('user32.dll');

        try {
          _sendInput = _user32Lib!
              .lookup<NativeFunction<Uint32 Function(Uint32, Pointer<NativeInput>, Int32)>>('SendInput')
              .asFunction();
        } catch (_) {}

        try {
          _mapVirtualKey = _user32Lib!
              .lookup<NativeFunction<Uint32 Function(Uint32, Uint32)>>('MapVirtualKeyW')
              .asFunction();
        } catch (_) {}

        try {
          _keybdEvent = _user32Lib!
              .lookup<NativeFunction<Void Function(Uint8, Uint8, Uint32, Pointer<Void>)>>('keybd_event')
              .asFunction();
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('[KeyboardService] FFI 初期化エラー: $e');
    }
  }

  /// macOS アクセシビリティ権限のチェック
  bool checkAccessibilityPermission() {
    if (Platform.isMacOS && _axIsProcessTrusted != null) {
      bool isTrusted = _axIsProcessTrusted!();
      if (!isTrusted) {
        debugPrint('[KeyboardService] ⚠️ WARNING: macOS アクセシビリティ権限が許可されていません！「システム設定 > プライバシーとセキュリティ > アクセシビリティ」でアプリ（または実行元ターミナル/IDE）を許可してください。');
      } else {
        debugPrint('[KeyboardService] ✅ macOS アクセシビリティ権限の確認完了 (Trusted)');
      }
      return isTrusted;
    }
    return true;
  }

  /// WASD キーの押し下げ / 離脱を状態管理して送信
  void updateKeyStates({
    required bool w,
    required bool a,
    required bool s,
    required bool d,
  }) {
    if (w != _isWPressed) {
      _isWPressed = w;
      _sendKeyEvent(WasdKey.w, w);
    }
    if (a != _isAPressed) {
      _isAPressed = a;
      _sendKeyEvent(WasdKey.a, a);
    }
    if (s != _isSPressed) {
      _isSPressed = s;
      _sendKeyEvent(WasdKey.s, s);
    }
    if (d != _isDPressed) {
      _isDPressed = d;
      _sendKeyEvent(WasdKey.d, d);
    }
  }

  /// すべてのキーを離す (KeyUp)
  void releaseAllKeys() {
    updateKeyStates(w: false, a: false, s: false, d: false);
  }

  void _sendKeyEvent(WasdKey key, bool isDown) {
    debugPrint('[KeyboardService] Key: ${key.name.toUpperCase()} -> ${isDown ? "DOWN" : "UP"}');

    if (Platform.isMacOS) {
      _sendMacOsKey(key, isDown);
    } else if (Platform.isWindows) {
      _sendWindowsKey(key, isDown);
    }
  }

  void _sendMacOsKey(WasdKey key, bool isDown) {
    if (_cgEventCreateKeyboardEvent == null || _cgEventPost == null || _cfRelease == null) return;

    int virtualKey;
    switch (key) {
      case WasdKey.w:
        virtualKey = 13; // 0x0D
        break;
      case WasdKey.a:
        virtualKey = 0; // 0x00
        break;
      case WasdKey.s:
        virtualKey = 1; // 0x01
        break;
      case WasdKey.d:
        virtualKey = 2; // 0x02
        break;
    }

    try {
      final event = _cgEventCreateKeyboardEvent!(nullptr, virtualKey, isDown);
      if (event != nullptr) {
        _cgEventPost!(0, event); // 0 = kCGHIDEventTap
        _cfRelease!(event);
      }
    } catch (e) {
      debugPrint('[KeyboardService] macOS CGEvent エラー: $e');
    }
  }

  void _sendWindowsKey(WasdKey key, bool isDown) {
    int vkCode;
    int fallbackScanCode;
    switch (key) {
      case WasdKey.w:
        vkCode = 0x57;
        fallbackScanCode = 0x11;
        break;
      case WasdKey.a:
        vkCode = 0x41;
        fallbackScanCode = 0x1E;
        break;
      case WasdKey.s:
        vkCode = 0x53;
        fallbackScanCode = 0x1F;
        break;
      case WasdKey.d:
        vkCode = 0x44;
        fallbackScanCode = 0x20;
        break;
    }

    _sendWindowsKeyWithScanCode(vkCode, fallbackScanCode, isDown);
  }

  /// スペースキー (Space) の KeyDown / KeyUp 送信
  void sendSpaceKey(bool isDown) {
    debugPrint('[KeyboardService] Key: SPACE -> ${isDown ? "DOWN" : "UP"}');
    if (Platform.isMacOS) {
      _sendRawMacOsKey(49, isDown); // 49 = Space
    } else if (Platform.isWindows) {
      _sendRawWindowsKey(0x20, isDown); // 0x20 = VK_SPACE
    }
  }

  void _sendRawMacOsKey(int virtualKey, bool isDown) {
    if (_cgEventCreateKeyboardEvent == null || _cgEventPost == null || _cfRelease == null) return;
    try {
      final event = _cgEventCreateKeyboardEvent!(nullptr, virtualKey, isDown);
      if (event != nullptr) {
        _cgEventPost!(0, event);
        _cfRelease!(event);
      }
    } catch (e) {
      debugPrint('[KeyboardService] macOS CGEvent エラー: $e');
    }
  }

  void _sendRawWindowsKey(int vkCode, bool isDown) {
    int fallbackScanCode = (vkCode == 0x20) ? 0x39 : 0;
    _sendWindowsKeyWithScanCode(vkCode, fallbackScanCode, isDown);
  }

  void _sendWindowsKeyWithScanCode(int vkCode, int fallbackScanCode, bool isDown) {
    int scanCode = 0;
    if (_mapVirtualKey != null) {
      scanCode = _mapVirtualKey!(vkCode, 0); // MAPVK_VK_TO_VSC = 0
    }
    if (scanCode == 0) {
      scanCode = fallbackScanCode;
    }

    try {
      // 1. SendInput API (現代の DirectX / DirectInput / 3Dゲーム対応)
      if (_sendInput != null) {
        final input = calloc<NativeInput>();
        input.ref.type = 1; // INPUT_KEYBOARD = 1
        input.ref.wVk = 0; // KEYEVENTF_SCANCODE 指定時は wVk = 0
        input.ref.wScan = scanCode;
        // KEYEVENTF_KEYUP (0x0002) | KEYEVENTF_SCANCODE (0x0008)
        input.ref.dwFlags = (isDown ? 0 : 0x0002) | 0x0008;
        input.ref.time = 0;
        input.ref.dwExtraInfo = 0;

        _sendInput!(1, input, 40); // 64bit Windows の cbSize = 40
        calloc.free(input);
        return;
      }

      // 2. keybd_event フォールバック (bVk = 0, bScan = scanCode, KEYEVENTF_SCANCODE 指定)
      if (_keybdEvent != null) {
        int flags = (isDown ? 0 : 2) | 0x0008; // 2 = KEYEVENTF_KEYUP, 8 = KEYEVENTF_SCANCODE
        _keybdEvent!(0, scanCode, flags, nullptr);
      }
    } catch (e) {
      debugPrint('[KeyboardService] Windows キー送信エラー: $e');
    }
  }

  void dispose() {
    releaseAllKeys();
    sendSpaceKey(false);
  }
}
