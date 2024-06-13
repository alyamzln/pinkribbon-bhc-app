import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:pinkribbonbhc/data/repositories/risk_assessment/risk_assess_repositories.dart';
import 'package:pinkribbonbhc/data/services/risk_assess_services.dart';
import 'package:pinkribbonbhc/features/risk-assessment/models/risk_assess_model.dart';
import 'package:pinkribbonbhc/features/risk-assessment/screens/risk_assess_ques.dart';
import 'package:pinkribbonbhc/features/risk-assessment/screens/widgets/result_page.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/popups/full_screen_loader.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class THomeCategories extends StatelessWidget {
  final RiskAssessmentService riskAssessmentService = RiskAssessmentService();

  THomeCategories({
    Key? key,
  }) : super(key: key);

  Future<void> checkRiskAssessment(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      RiskAssessment? riskAssessment =
          await riskAssessmentService.getRiskAssessment(userId);
      if (riskAssessment != null && riskAssessment.riskCategory.isNotEmpty) {
        // Navigate to ResultPage
        Get.to(() => ResultPage(userRiskCategory: riskAssessment.riskCategory));
      } else {
        _showAlert(context,
            'You have not attempted any risk assessment yet. Click the button below to start.');
      }
    }
  }

  void _showAlert(BuildContext context, String message) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Risk Assessment',
        text: message,
        confirmBtnText: 'Start Assessment',
        confirmBtnColor: TColors.primary,
        confirmBtnTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          Get.to(() => RiskAssessmentQuestion());
        });
  }

  void navigateToCategory(int index, BuildContext context) {
    switch (index) {
      case 0:
        Get.toNamed('/locator'); // Navigate to Locator screen
        break;
      case 1:
        Get.toNamed('/records'); // Navigate to Records screen
        break;
      case 2:
        checkRiskAssessment(
            context); // Navigate to Risk screen after checking risk assessment
        break;
      case 3:
        Get.toNamed('/trends'); // Navigate to Trends screen
        break;
      default:
        // Handle default case
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          String image;
          String title;

          // Assign different images and titles based on index
          switch (index) {
            case 0:
              image = TImages.locationIcon;
              title = 'Locator';
              break;
            case 1:
              image = TImages.notesIcon;
              title = 'Records';
              break;
            case 2:
              image = TImages.riskIcon;
              title = 'Risk';
              break;
            case 3:
              image = TImages.trendIcon;
              title = 'Trends';
              break;
            default:
              image = TImages.locationIcon;
              title = 'Location';
          }

          return TVerticalImageText(
            image: image,
            title: title,
            onTap: () => navigateToCategory(index, context),
          );
        },
      ),
    );
  }
}
