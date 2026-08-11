import 'package:flutter_test/flutter_test.dart';
import 'package:balance_board_app/services/jump_detector.dart';
import 'package:balance_board_app/services/osc_service.dart';

void main() {
  group('JumpDetector Logic Tests', () {
    late JumpDetector detector;

    setUp(() {
      detector = JumpDetector();
    });

    tearDown(() {
      detector.dispose();
    });

    test('detects jump when weight drops from riding weight to below threshold', () {
      // Step 1: User stands on balance board (60kg)
      bool triggered1 = detector.processWeight(
        60.0,
        thresholdKg: 5.0,
        enabled: true,
        holdMs: 150,
      );
      expect(triggered1, isFalse);
      expect(detector.isJumping, isFalse);

      // Step 2: User jumps up into the air (weight drops to 1.0kg)
      bool triggered2 = detector.processWeight(
        1.0,
        thresholdKg: 5.0,
        enabled: true,
        holdMs: 150,
      );
      expect(triggered2, isTrue);
      expect(detector.isJumping, isTrue);
    });

    test('does not trigger jump when jump detection is disabled', () {
      detector.processWeight(60.0, thresholdKg: 5.0, enabled: false, holdMs: 150);
      bool triggered = detector.processWeight(1.0, thresholdKg: 5.0, enabled: false, holdMs: 150);
      expect(triggered, isFalse);
      expect(detector.isJumping, isFalse);
    });
  });

  group('OscService Int Encoding Tests', () {
    test('encodeOscInt encodes /input/Jump 1 correctly', () {
      final packet = OscService.encodeOscInt('/input/Jump', 1);

      // Address: "/input/Jump\0" padded to 4 bytes boundary -> 12 bytes
      expect(String.fromCharCodes(packet.sublist(0, 11)), equals('/input/Jump'));
      
      // Type tag: ",i\0\0" -> 4 bytes
      expect(String.fromCharCodes(packet.sublist(12, 14)), equals(',i'));

      // Value: 1 in Big-Endian Int32
      expect(packet.sublist(16, 20), equals([0, 0, 0, 1]));
    });
  });
}
