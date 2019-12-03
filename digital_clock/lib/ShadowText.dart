import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ShadowText extends StatelessWidget {
  ShadowText(this.data, this.color, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;
  final Color color;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 3.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}