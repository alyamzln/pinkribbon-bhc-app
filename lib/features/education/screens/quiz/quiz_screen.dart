import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/top_bar/top_bar.dart';
import 'package:pinkribbonbhc/common/widgets/texts/section_heading.dart';
import 'package:pinkribbonbhc/features/education/controllers/quiz/quiz_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class QuizScreen extends StatelessWidget {
  final String contentType;

  const QuizScreen({Key? key, required this.contentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizController = Get.put(QuizController());

    quizController.fetchQuizQuestions(contentType);

    return Scaffold(
      body: Obx(() {
        if (quizController.quizQuestions.isEmpty) {
          // Handle the case where quiz questions are not yet loaded or empty
          return Center(
            child:
                CircularProgressIndicator(), // Or any other loading indicator
          );
        } else {
          final currentQuestion =
              quizController.quizQuestions[quizController.currentQuestionIndex];
          final options = [
            currentQuestion.option1,
            currentQuestion.option2,
            currentQuestion.option3,
            currentQuestion.option4,
          ];

          return SingleChildScrollView(
            child: Column(
              children: [
                TPrimaryHeaderContainer(
                  child: Column(
                    children: [
                      TAppBar(
                        title: Center(
                          child: Text(
                            'Quiz',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(color: TColors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TSectionHeading(
                        title:
                            'Question ${quizController.currentQuestionIndex + 1} of ${quizController.quizQuestions.length}',
                        textColor: TColors.secondary,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      Text(
                        currentQuestion.question,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      ...options.asMap().entries.map((entry) {
                        final optionIndex = entry.key + 1;
                        final optionText = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: TSizes.spaceBtwItems),
                          child: ElevatedButton(
                            onPressed: () {
                              quizController.selectOption(optionIndex);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: Text(
                                optionText,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  if (optionIndex ==
                                      quizController.selectedOption) {
                                    return quizController.isCorrectAnswer
                                        ? Colors.green
                                        : Colors.red;
                                  }
                                }
                                return optionIndex ==
                                        quizController.selectedOption
                                    ? quizController.isCorrectAnswer
                                        ? Colors.green
                                        : Colors.red
                                    : Colors.white;
                              }),
                              side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none,
                              ),
                              shadowColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.3),
                              ),
                              elevation: MaterialStateProperty.all<double>(4),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
