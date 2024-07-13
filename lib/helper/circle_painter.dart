import 'package:flutter/material.dart';
import 'dart:math' as math;


class CircleChartPainter extends CustomPainter {
  final double progress;
  final List<String> texts;
  final List<Color> textColors;
  final List<double> fontSizes;
  final Color topHalfColor;
  final Color bottomHalfColor;

  CircleChartPainter(this.progress, this.texts, this.textColors, this.fontSizes,
      this.topHalfColor, this.bottomHalfColor);
  @override
  void paint(Canvas canvas, Size size) {
    Paint topHalfPaint = Paint()..color = topHalfColor;
    Paint bottomHalfPaint = Paint()..color = bottomHalfColor;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 1.6;

    // Draw top half circle
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      math.pi,
      math.pi,
      false,
      topHalfPaint,
    );

    // Draw bottom half circle
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      0,
      math.pi,
      false,
      bottomHalfPaint,
    );

    Paint progressPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 55;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius - 42),
      math.pi * 1,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );

    for (int i = 0; i < texts.length; i++) {
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: texts[i],
          style: TextStyle(
            color: textColors[i],
            fontSize: fontSizes[i],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          centerY -
              textPainter.height / 2 +
              (i * 20), // Adjust vertical position
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}