import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geo_notif_offline/core/models/nearby_poi.dart';
import 'package:geo_notif_offline/core/theme/app_theme.dart';

const kRadarRadiusMeters = 1500.0;
const kPoiColors = [
  AppColors.accent,
  AppColors.pink,
  AppColors.violet,
  AppColors.warning,
];

class RadarPainter extends CustomPainter {
  final List<NearbyPoi> pois;

  RadarPainter({required this.pois});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2 * 0.9;

    final ringPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, maxRadius * i / 3, ringPaint);
    }

    final axisPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy), Offset(center.dx + maxRadius, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius), Offset(center.dx, center.dy + maxRadius), axisPaint);

    canvas.drawCircle(center, 6, Paint()..color = AppColors.accent);
    canvas.drawCircle(center, 6, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2);

    for (var i = 0; i < pois.length; i++) {
      final poi = pois[i];
      final normalizedDistance = (poi.distanceMeters / kRadarRadiusMeters).clamp(0.05, 1.0);
      final angle = (poi.bearingDegrees - 90) * math.pi / 180;
      final point = Offset(
        center.dx + math.cos(angle) * normalizedDistance * maxRadius,
        center.dy + math.sin(angle) * normalizedDistance * maxRadius,
      );
      canvas.drawCircle(point, 5, Paint()..color = kPoiColors[i % kPoiColors.length]);
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => oldDelegate.pois != pois;
}
