// lib/road_painter.dart

import 'package:flutter/material.dart';

class RoadPainter extends CustomPainter {
  final List<Offset> points;
  final double tension;

  RoadPainter({required this.points, this.tension = 0.2});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    // 1. Paint for the black road surface
    final roadPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 75.0
      ..strokeCap = StrokeCap.round;

    // 2. NEW: Paint for the white dashed center line
    final dashedLinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 // A nice thin line
      ..strokeCap = StrokeCap.round;

    // 3. Define the road's path (this logic is the same as before)
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i == 0 ? i : i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 1 == points.length - 1 ? i + 1 : i + 2];

      final controlPoint1 = p1 + (p2 - p0) * tension;
      final controlPoint2 = p2 - (p3 - p1) * tension;

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    // 4. Draw the two layers
    // First, draw the solid black road
    canvas.drawPath(path, roadPaint);
    
    // Then, draw the dashed line on top using a helper function
    _drawDashedPath(canvas, path, dashedLinePaint, 15.0, 10.0);
  }

  // This helper function takes a path and draws it with dashes
  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    // PathMetrics is a tool that lets us measure and walk along a path
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        // Extract a small segment of the path for the dash
        final dashPath = metric.extractPath(distance, distance + dashWidth);
        // Draw that small segment
        canvas.drawPath(dashPath, paint);
        // Move our "pen" to the start of the next dash
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.tension != tension;
  }
}