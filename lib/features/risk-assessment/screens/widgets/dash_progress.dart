import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';

class DashStepProgress extends StatelessWidget {
  final double currentStep;
  final int? totalSteps;

  const DashStepProgress({
    Key? key,
    required this.currentStep,
    this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int steps = totalSteps ?? 1;
    final double dashWidth = 10.0;
    final double dashHeight = 4.0;
    final double dashSpacing = 4.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: dashSpacing / 2),
          width: dashWidth,
          height: dashHeight,
          color: index < currentStep ? TColors.secondary : Colors.white,
        );
      }),
    );
  }
}
