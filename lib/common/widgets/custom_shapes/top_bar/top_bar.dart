import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/curve_painter/curve_painter.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 300,
      ),
      painter: CurvePainter(),
    );
  }
}
