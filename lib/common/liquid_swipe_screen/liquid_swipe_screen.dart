import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:pinkribbonbhc/features/education/models/edu_content/content.dart';
import 'package:pinkribbonbhc/features/education/models/edu_content/item_model.dart';
import 'package:pinkribbonbhc/features/education/screens/quiz/quiz_screen.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';

class MyLiquidSwipePage extends StatelessWidget {
  final String contentType;
  final List<Color> backgroundColors = [
    TColors.primary,
    TColors.secondary,
    TColors.accent
  ];

  MyLiquidSwipePage({required this.contentType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> contentList = [];

    // Add logic to populate contentList based on the contentType parameter
    switch (contentType) {
      case 'breast_cancer_symptoms':
        SymptomContent symptomContent = SymptomContent();
        contentList.addAll(symptomContent.symptomContent);
        break;
      case 'tips_mammogram':
        MammogramTips mammogramTips = MammogramTips();
        contentList.addAll(mammogramTips.mammogramTips);
        break;
      case 'myths_facts':
        MythsFacts mythsFacts = MythsFacts();
        contentList.addAll(mythsFacts.mythsFacts);
        break;
      default:
        // Handle default case or error
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            slideIconWidget:
                const Icon(Icons.arrow_back_ios, color: Colors.white),
            positionSlideIcon: 0.5,
            enableLoop: false,
            fullTransitionValue: 400,
            pages: contentList
                .map((item) => Container(
                      color: backgroundColors[
                          contentList.indexOf(item) % backgroundColors.length],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 250, // Set the desired height
                            width: double
                                .infinity, // Take the full width available
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain, // Adjust the fit as needed
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    20), // Adjust the horizontal padding as needed
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    20), // Adjust the horizontal padding as needed
                            child: Text(
                              item.description,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
          Positioned(
            bottom: 18.0, // Adjust the distance from the bottom as needed
            right: 18.0, // Adjust the distance from the right as needed
            child: FloatingActionButton(
              onPressed: () =>
                  Get.to(() => QuizScreen(contentType: contentType)),
              child: Icon(Icons.quiz),
            ),
          ),
        ],
      ),
    );
  }
}
