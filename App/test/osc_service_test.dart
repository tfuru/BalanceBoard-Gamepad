import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:balance_board_app/services/osc_service.dart';

void main() {
  group('OscService Encoding Tests', () {
    test('encodeOscFloat generates correct OSC byte packet for /input/Vertical 1.0', () {
      final bytes = OscService.encodeOscFloat('/input/Vertical', 1.0);
      expect(bytes.isNotEmpty, isTrue);
      expect(bytes.length % 4, equals(0));

      // Address: /input/Vertical + \0 = 16 bytes (15 chars + \0)
      // Type tag: ,f + \0\0 = 4 bytes
      // Float: 1.0 in IEEE 754 Big Endian = [0x3F, 0x80, 0x00, 0x00] (4 bytes)
      // Total: 24 bytes
      expect(bytes.length, equals(24));

      // Check float value bytes (last 4 bytes)
      final floatBytes = bytes.sublist(bytes.length - 4);
      final byteData = ByteData.sublistView(Uint8List.fromList(floatBytes));
      final decodedFloat = byteData.getFloat32(0, Endian.big);
      expect(decodedFloat, closeTo(1.0, 0.0001));
    });

    test('encodeOscFloat generates correct OSC byte packet for /input/Horizontal -0.5', () {
      final bytes = OscService.encodeOscFloat('/input/Horizontal', -0.5);
      expect(bytes.isNotEmpty, isTrue);
      expect(bytes.length % 4, equals(0));

      final floatBytes = bytes.sublist(bytes.length - 4);
      final byteData = ByteData.sublistView(Uint8List.fromList(floatBytes));
      final decodedFloat = byteData.getFloat32(0, Endian.big);
      expect(decodedFloat, closeTo(-0.5, 0.0001));
    });
  });
}
