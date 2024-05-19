import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinkribbonbhc/features/self-exam/controllers/feedback_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';
import 'package:pinkribbonbhc/utils/device/device_utility.dart';

class FeedbackNextButton extends StatelessWidget {
  const FeedbackNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight() - 10,
      child: ElevatedButton(
        onPressed: () => FeedbackController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), backgroundColor: TColors.primary),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
