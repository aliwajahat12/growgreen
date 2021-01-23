import 'package:flutter/material.dart';
import 'dart:math' as math;

class SemiCircle extends StatelessWidget {
  final double diameter;

  const SemiCircle({Key key, this.diameter = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(context),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  final context;
  MyPainter(this.context);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Theme.of(context).primaryColor;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 1.4, 0),
        height: size.height * 1.6,
        width: size.width,
      ),
      // math.pi,
      // math.pi,
      0,
      math.pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
