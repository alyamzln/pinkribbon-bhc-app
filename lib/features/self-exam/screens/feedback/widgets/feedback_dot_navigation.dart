import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/features/self-exam/controllers/feedback_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';
import 'package:pinkribbonbhc/utils/device/device_utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FeedbackDotNavigation extends StatelessWidget {
  const FeedbackDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FeedbackController.instance;

    return Positioned(
        bottom: TDeviceUtils.getBottomNavigationBarHeight(),
        left: TSizes.defaultSpace,
        child: SmoothPageIndicator(
          count: 3,
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          effect: ExpandingDotsEffect(
              activeDotColor: TColors.primary, dotHeight: 6),
        ));
  }
}
