import 'package:flutter/material.dart';
import 'dart:math';

class CustomProgressIndicator extends StatefulWidget {
  final double progress;

  CustomProgressIndicator({required this.progress});

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(220, 200), // Specify the size of the custom paint
      painter: _ProgressPainter(widget.progress),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;

  _ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi+0.00; // Start from the left side
    double sweepAngle = pi / 5; // Each segment covers 20% of the progress

    Paint trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    // Define the colors for different stages
    List<Color> colors = [Colors.red, Colors.orange, Colors.yellow, Colors.purple, Colors.green];
    List<double> thresholds = [20, 40, 60, 80, 100];

    // Draw the track
    canvas.drawArc(
      Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
      startAngle,
      pi,
      false,
      trackPaint,
    );

    // Draw the progress
    double cumulativeProgress = 0;
    for (int i = 0; i < thresholds.length; i++) {
      if (progress > cumulativeProgress) {
        progressPaint.color = colors[i];
        double endAngle = (progress > thresholds[i] ? thresholds[i] : progress) * pi / 100;
        double angleToDraw = endAngle - cumulativeProgress * pi / 100;
        canvas.drawArc(
          Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: size.width, height: size.height),
          startAngle,
          angleToDraw,
          false,
          progressPaint,
        );
        cumulativeProgress = thresholds[i];
        startAngle += angleToDraw;
      }
    }

    double textRadius = size.width / 1.65 + 22;
    for (int i = 0; i < thresholds.length; i++) {
      double angle = (i * sweepAngle) - pi / 1.11;
      double x = size.width / 2 + textRadius * cos(angle);
      double y = size.height / 1.6 + textRadius * sin(angle);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${thresholds[i]}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: colors[i],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );

      // Adjust text position to be above the arc
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height));
    }

    // Draw the central percentage text
    TextPainter centralTextPainter = TextPainter(
      text: TextSpan(
        text: '${progress.toInt()}.0%',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    centralTextPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    double textX = (size.width - centralTextPainter.width) / 2;
    double textY = (size.height - centralTextPainter.height) / 2;
    centralTextPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
