import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/features/risk-assessment/screens/risk_assess_ques.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';
import 'package:pinkribbonbhc/utils/constants/text_strings.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';
import 'package:quickalert/quickalert.dart';

class RiskAssessmentScreen extends StatelessWidget {
  const RiskAssessmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      TLoaders.errorSnackBar(title: 'Error!', message: 'No user logged in');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Risk Assessment',
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
                    height: 280,
                    child: Image.asset(TImages.startRisk, fit: BoxFit.contain),
                  ),
                  SizedBox(height: TSizes.spaceBtwItems),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                    child: Text(
                      "Risk Assessment",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                    child: Text(
                      "Answer several questions to assess your risk of breast cancer. We will generate a risk profile and give you a recommended screening plan.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.info,
                        title: "Important Note!",
                        text: TTexts.disclaimerRisk,
                        confirmBtnText: "I Understand",
                        confirmBtnColor: TColors.primary,
                        confirmBtnTextStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: TColors.white),
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop(); // Dismiss the alert
                          Get.to(() => RiskAssessmentQuestion());
                        });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Adjust the radius as needed
                      ),
                      backgroundColor: TColors.secondary,
                      side: BorderSide(color: TColors.secondary)),
                  child: Text(
                    'Start Your Risk Assessment',
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
