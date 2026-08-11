import 'package:flutter_test/flutter_test.dart';
import 'package:balance_board_app/models/app_config.dart';
import 'package:balance_board_app/providers/gamepad_provider.dart';

void main() {
  group('GamepadProvider OutputMode and OSC Tests', () {
    test('Default OutputMode is virtualGamepad', () {
      final provider = GamepadProvider();
      expect(provider.config.outputMode, equals(OutputMode.virtualGamepad));
    });

    test('setOutputMode changes outputMode and notifies listeners', () {
      final provider = GamepadProvider();
      bool listenerNotified = false;
      provider.addListener(() {
        listenerNotified = true;
      });

      provider.setOutputMode(OutputMode.oscInputController);
      expect(provider.config.outputMode, equals(OutputMode.oscInputController));
      expect(listenerNotified, isTrue);
    });

    test('OSC config settings update properly', () {
      final provider = GamepadProvider();

      provider.setOscHost('192.168.1.100');
      expect(provider.config.oscHost, equals('192.168.1.100'));

      provider.setOscPort(9001);
      expect(provider.config.oscPort, equals(9001));

      provider.setInvertOscX(true);
      expect(provider.config.invertOscX, isTrue);

      provider.setInvertOscY(true);
      expect(provider.config.invertOscY, isTrue);
    });
  });
}
