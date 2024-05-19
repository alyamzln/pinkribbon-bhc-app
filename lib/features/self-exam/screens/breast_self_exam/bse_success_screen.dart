import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinkribbonbhc/common/styles/spacing_styles.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/self_exam_feedback.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/self_exam_feedback_bk.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/scheduling/schedule_exam.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';
import 'package:pinkribbonbhc/utils/constants/text_strings.dart';
import 'package:pinkribbonbhc/utils/helpers/helper_functions.dart';

class SelfExamSuccessScreen extends StatelessWidget {
  const SelfExamSuccessScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color:
                  Colors.white, // Optional background color for the image area
              child: Lottie.asset(
                image,
                fit: BoxFit.cover, // Ensure the image covers the whole area
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                ElevatedButton(
                  onPressed: () => Get.to(() => ScheduleExamPage()),
                  child: Text(
                    "All good!",
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () => Get.to(() => SelfExamFeedback()),
                  child: Text("I noticed a change.",
                      style: TextStyle(fontFamily: 'Poppins')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: TColors.primary,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
