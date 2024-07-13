import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Animated Circular Progress Indicator'),
//         ),
//         body: Center(
//           child: AnimatedCircleIndicator(
//             maxValue: 3566556522,
//             firstHalfColor: Colors.blue,
//             secondHalfColor: Colors.purple,
//             animationDuration: Duration(seconds: 1),
//           ),
//         ),
//       ),
//     );
//   }
// }

class AnimatedCircleIndicator extends StatefulWidget {
  final int maxValue;
  final Color firstHalfColor;
  final Color secondHalfColor;
  final Duration animationDuration;

  AnimatedCircleIndicator({
    required this.maxValue,
    required this.firstHalfColor,
    required this.secondHalfColor,
    required this.animationDuration,
  });

  @override
  _AnimatedCircleIndicatorState createState() =>
      _AnimatedCircleIndicatorState();
}

class _AnimatedCircleIndicatorState extends State<AnimatedCircleIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(120, 120),
          painter: CirclePainter(
            animation: _controller,
            firstHalfColor: widget.firstHalfColor,
            secondHalfColor: widget.secondHalfColor,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                int currentValue =
                    (_controller.value * widget.maxValue).toInt();
                String formattedValue = NumberFormat('#,###')
                    .format(currentValue); 
                return Text(
                  '$formattedValue',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  final Animation<double> animation;
  final Color firstHalfColor;
  final Color secondHalfColor;

  CirclePainter({
    required this.animation,
    required this.firstHalfColor,
    required this.secondHalfColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    paint.color = firstHalfColor;
    double firstHalfAngle = math.pi * animation.value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      firstHalfAngle,
      false,
      paint,
    );

    paint.color = secondHalfColor;
    double secondHalfAngle = math.pi * animation.value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      secondHalfAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
