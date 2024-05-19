import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/breast_self_exam/self_exam_screen.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class SelfExamStart extends StatelessWidget {
  const SelfExamStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Breast Self-Examination',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: TColors.white),
                    ),
                    showBackArrow: true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 320,
                    child: Image.asset(TImages.startBSE, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                    child: Text(
                      "When to Self-Exam?",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                    child: Text(
                      "The best time to breast self-exam is a few days after the end of your period when you are least tender or swollen. No period? Do it the first day of the month.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => SelfExamScreen()),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Adjust the radius as needed
                      ),
                      backgroundColor: TColors.secondary,
                      side: BorderSide(color: TColors.secondary)),
                  child: Text(
                    'Start Your Self-Examination',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
