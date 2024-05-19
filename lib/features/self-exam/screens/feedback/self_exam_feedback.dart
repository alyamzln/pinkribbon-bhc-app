import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/features/self-exam/controllers/feedback_controller.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/widgets/feedback_dot_navigation.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/widgets/feedback_next_button.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/widgets/feedback_page1.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/widgets/feedback_page2.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/widgets/feedback_page3.dart';

class SelfExamFeedback extends StatelessWidget {
  const SelfExamFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Exam Feedback',
            style: TextStyle(fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              FeedbackPage1(),
              FeedbackPage2(),
              FeedbackPage3(),
            ],
          ),

          // Dot Navigation SmoothPageIndicator
          const FeedbackDotNavigation(),
        ],
      ),
    );
  }
}
