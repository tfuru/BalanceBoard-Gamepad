import 'package:flutter_test/flutter_test.dart';
import 'package:balance_board_app/models/app_config.dart';
import 'package:balance_board_app/providers/gamepad_provider.dart';

void main() {
  group('WASD Mode and Keyboard Logic Tests', () {
    test('GamepadProvider WASD configuration properties work correctly', () {
      final provider = GamepadProvider();

      provider.setWasdThreshold(0.20);
      expect(provider.config.wasdThreshold, equals(0.20));

      provider.setInvertWasdX(true);
      expect(provider.config.invertWasdX, isTrue);

      provider.setInvertWasdY(true);
      expect(provider.config.invertWasdY, isTrue);
    });

    test('KeyboardService key status management and releaseAllKeys', () {
      final provider = GamepadProvider();
      final keyboardService = provider.keyboardService;

      // Manually set key states
      keyboardService.updateKeyStates(w: true, a: true, s: false, d: false);
      expect(keyboardService.isWPressed, isTrue);
      expect(keyboardService.isAPressed, isTrue);
      expect(keyboardService.isSPressed, isFalse);
      expect(keyboardService.isDPressed, isFalse);

      // Switching mode releases all keys
      provider.setOutputMode(OutputMode.keyboardWasd);
      provider.setOutputMode(OutputMode.virtualGamepad);

      expect(keyboardService.isWPressed, isFalse);
      expect(keyboardService.isAPressed, isFalse);
      expect(keyboardService.isSPressed, isFalse);
      expect(keyboardService.isDPressed, isFalse);
    });
  });
}
