import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';

class StepProgress extends StatefulWidget {
  final double currentStep;
  final double steps;

  const StepProgress({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  _StepProgressState createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  double widthProgress = 0;

  @override
  void initState() {
    _onSizeWidget();
    super.initState();
  }

  void _onSizeWidget() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (context.size is Size) {
        Size size = context.size!;
        widthProgress = size.width / (widget.steps - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
                '${(widget.currentStep + 1).toInt()} / ${widget.steps.toInt()}'),
          ],
        ),
        Container(
          height: 4,
          width: Get.width,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              AnimatedContainer(
                width: widthProgress * widget.currentStep,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: TColors.primary.withOpacity(0.4),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ],
    );
  }
}
