import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/features/education/controllers/quiz/quiz_controller.dart'; // Import the QuizController
import 'package:pinkribbonbhc/features/education/screens/home/home.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          )
        ],
      ),
      body: GetBuilder<QuizController>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Center(
                // Center horizontally
                child: Column(
                  // Center vertically
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 400,
                      height: 500,
                      decoration: BoxDecoration(
                        color: TColors.primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              TImages.successAnimation,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Congrats!",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Score: ${controller.score}%", // Display the score
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: TColors.secondary),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Quiz completed successfully.",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "You attempted ${controller.totalQuestionsAttempted} questions and\nfrom that ${controller.correctAttempts} is correct.", // Display total questions attempted and correct attempts
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
