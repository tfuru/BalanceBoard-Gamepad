import 'package:flutter/material.dart';

/// Wii Balance Board の 2D 重心点および 4 隅圧力描画クラス
class CoGPainter extends CustomPainter {
  final double centerX; // -1.0 〜 +1.0
  final double centerY; // -1.0 〜 +1.0
  final int rawTR;
  final int rawBR;
  final int rawTL;
  final int rawBL;
  final double deadzone;

  CoGPainter({
    required this.centerX,
    required this.centerY,
    required this.rawTR,
    required this.rawBR,
    required this.rawTL,
    required this.rawBL,
    this.deadzone = 0.05,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);

    // 外枠 (Balance Board 形状)
    final RRect boardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 10, width - 20, height - 20),
      const Radius.circular(24),
    );

    final Paint borderPaint = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint bgPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(boardRect, bgPaint);
    canvas.drawRRect(boardRect, borderPaint);

    // グリッド軸 (十字線)
    final Paint gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(10, center.dy), Offset(width - 10, center.dy), gridPaint);
    canvas.drawLine(Offset(center.dx, 10), Offset(center.dx, height - 10), gridPaint);

    // デッドゾーン円
    final double deadzoneRadius = (width / 2 - 20) * deadzone;
    final Paint deadzonePaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, deadzoneRadius, deadzonePaint);

    // 4 隅のセンサーインジケーター描画
    _drawSensorCorner(canvas, Offset(width - 40, 40), rawTR, "TR");
    _drawSensorCorner(canvas, Offset(width - 40, height - 40), rawBR, "BR");
    _drawSensorCorner(canvas, Offset(40, 40), rawTL, "TL");
    _drawSensorCorner(canvas, Offset(40, height - 40), rawBL, "BL");

    // 重心点 (CoG Indicator Dot)
    final double maxRadius = (width / 2) - 30;
    // Y 軸は上がプラス、下がマイナスとするため Canvas の Y 座標と反転
    final double targetX = center.dx + (centerX * maxRadius);
    final double targetY = center.dy - (centerY * maxRadius);
    final Offset cogPosition = Offset(targetX, targetY);

    // 重心点のグロー（外光）
    final Paint glowPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(cogPosition, 16, glowPaint);

    // 重心点の中心ドット
    final Paint cogPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(cogPosition, 8, cogPaint);
  }

  void _drawSensorCorner(Canvas canvas, Offset pos, int value, String label) {
    double radius = 12.0 + (value / 500.0).clamp(0.0, 16.0);
    final Paint sensorPaint = Paint()
      ..color = value > 50 ? const Color(0xFF10B981) : Colors.grey.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pos, radius, sensorPaint);
  }

  @override
  bool shouldRepaint(covariant CoGPainter oldDelegate) {
    return oldDelegate.centerX != centerX ||
        oldDelegate.centerY != centerY ||
        oldDelegate.rawTR != rawTR ||
        oldDelegate.rawBR != rawBR ||
        oldDelegate.rawTL != rawTL ||
        oldDelegate.rawBL != rawBL ||
        oldDelegate.deadzone != deadzone;
  }
}
