import 'dart:convert';

/// ESP32 ファームウェアからの受信用センサー・重心データモデル
class SensorData {
  final bool isConnected;
  final int topRight;
  final int bottomRight;
  final int topLeft;
  final int bottomLeft;
  final double weightKg;
  final double centerX; // -1.0 〜 +1.0
  final double centerY; // -1.0 〜 +1.0

  const SensorData({
    this.isConnected = false,
    this.topRight = 0,
    this.bottomRight = 0,
    this.topLeft = 0,
    this.bottomLeft = 0,
    this.weightKg = 0.0,
    this.centerX = 0.0,
    this.centerY = 0.0,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      isConnected: json['conn'] as bool? ?? false,
      topRight: (json['tr'] as num?)?.toInt() ?? 0,
      bottomRight: (json['br'] as num?)?.toInt() ?? 0,
      topLeft: (json['tl'] as num?)?.toInt() ?? 0,
      bottomLeft: (json['bl'] as num?)?.toInt() ?? 0,
      weightKg: (json['weight'] as num?)?.toDouble() ?? 0.0,
      centerX: (json['x'] as num?)?.toDouble() ?? 0.0,
      centerY: (json['y'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory SensorData.fromRawString(String jsonString) {
    try {
      final Map<String, dynamic> mapData = jsonDecode(jsonString);
      return SensorData.fromJson(mapData);
    } catch (_) {
      return const SensorData();
    }
  }

  SensorData copyWith({
    bool? isConnected,
    int? topRight,
    int? bottomRight,
    int? topLeft,
    int? bottomLeft,
    double? weightKg,
    double? centerX,
    double? centerY,
  }) {
    return SensorData(
      isConnected: isConnected ?? this.isConnected,
      topRight: topRight ?? this.topRight,
      bottomRight: bottomRight ?? this.bottomRight,
      topLeft: topLeft ?? this.topLeft,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      weightKg: weightKg ?? this.weightKg,
      centerX: centerX ?? this.centerX,
      centerY: centerY ?? this.centerY,
    );
  }
}
