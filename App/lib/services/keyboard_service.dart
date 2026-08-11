import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

enum WasdKey { w, a, s, d }

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

  // Windows FFI Binding
  DynamicLibrary? _user32Lib;
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

        _keybdEvent = _user32Lib!
            .lookup<NativeFunction<Void Function(Uint8, Uint8, Uint32, Pointer<Void>)>>('keybd_event')
            .asFunction();
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
    if (_keybdEvent == null) return;

    int vkCode;
    switch (key) {
      case WasdKey.w:
        vkCode = 0x57;
        break;
      case WasdKey.a:
        vkCode = 0x41;
        break;
      case WasdKey.s:
        vkCode = 0x53;
        break;
      case WasdKey.d:
        vkCode = 0x44;
        break;
    }

    try {
      int flags = isDown ? 0 : 2; // 2 = KEYEVENTF_KEYUP
      _keybdEvent!(vkCode, 0, flags, nullptr);
    } catch (e) {
      debugPrint('[KeyboardService] Windows keybd_event エラー: $e');
    }
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
    if (_keybdEvent == null) return;
    try {
      int flags = isDown ? 0 : 2;
      _keybdEvent!(vkCode, 0, flags, nullptr);
    } catch (e) {
      debugPrint('[KeyboardService] Windows keybd_event エラー: $e');
    }
  }

  void dispose() {
    releaseAllKeys();
    sendSpaceKey(false);
  }

}
