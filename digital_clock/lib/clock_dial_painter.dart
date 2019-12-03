import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClockDialPainter extends CustomPainter {
  final hourTickMarkLength = 10.0;
  final minuteTickMarkLength = 5.0;
  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;
  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  ClockDialPainter(Color color)
      : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
        ),
        textStyle = const TextStyle(
          fontFamily: 'Rock Salt',
        ) {
    tickPaint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * pi / 60;
    final radius = size.width / 2;
    canvas.save();
    canvas.translate(radius, radius);
    for (var i = 0; i < 60; i++) {
      tickMarkLength = i % 1 == 0 ? hourTickMarkLength : minuteTickMarkLength;
      tickPaint.strokeWidth =
          i % 1 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      canvas.drawCircle(Offset(0.0, -radius - 5 + tickMarkLength), 5, tickPaint);
      canvas.rotate(angle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
