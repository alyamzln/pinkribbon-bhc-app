import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/widgets/success_screen/success_screen.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/breast_self_exam/bse_success_screen.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';

class BottomButtons extends StatelessWidget {
  final PageController pageController;
  final double currentPage;

  const BottomButtons(
      {super.key, required this.pageController, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        ElevatedButton(
          onPressed: () {
            pageController.previousPage(
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          child: Container(
            height: 50,
            width: 50,
            child: Icon(
              Icons.arrow_back,
              color: TColors.primary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: CircleBorder(
              side: BorderSide(
                color: TColors.primary,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (currentPage == 7) {
              // Assuming the last page index is 7
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SelfExamSuccessScreen(
                  image: TImages.successConfetti,
                  title: "Great Job! You have completed your breast self-exam!",
                  subTitle: "How did it go? Did you find anything unusual?",
                ),
              ));
            } else {
              pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
          child: Container(
            height: 50,
            width: 50,
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            elevation: 0,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: CircleBorder(
              side: BorderSide(
                color: TColors.primary,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
