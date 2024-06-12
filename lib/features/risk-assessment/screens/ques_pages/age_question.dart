import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/widgets/custom_button/custom_button.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:quickalert/quickalert.dart';

class AgeQuestionPage extends StatefulWidget {
  final Function(int, int) onNext;
  final PageController controller;

  const AgeQuestionPage({
    Key? key,
    required this.onNext,
    required this.controller,
  }) : super(key: key);

  @override
  State<AgeQuestionPage> createState() => _AgeQuestionPageState();
}

class _AgeQuestionPageState extends State<AgeQuestionPage> {
  int _selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 370,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: Text(
                  'How old are you?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      onPressed: () => _selectOption(0, 20, 1),
                      text: '20 – 39 years old',
                      alphabet: 'A',
                      isSelected: _selectedOption == 0,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      onPressed: () => _selectOption(1, 40, 2),
                      text: '40 - 44 years old',
                      alphabet: 'B',
                      isSelected: _selectedOption == 1,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      onPressed: () => _selectOption(2, 45, 3),
                      text: '45 - 54 years old',
                      alphabet: 'C',
                      isSelected: _selectedOption == 2,
                    ),
                    SizedBox(height: 10),
                    CustomButton(
                      onPressed: () => _selectOption(3, 55, 4),
                      text: '55 years old and above',
                      alphabet: 'D',
                      isSelected: _selectedOption == 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectOption(int index, int age, int score) {
    setState(() {
      _selectedOption = index;
    });
    _showAlertAndNext(context, age, score);
  }

  void _showAlertAndNext(BuildContext context, int age, int score) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Important Note!",
      text:
          "The risk of developing breast cancer increases with age, with most cancers developing after age 50. \n\nMake sure to be aware of any changes you find, and follow the screening plan that will be created for you at the end of this quiz.",
      confirmBtnText: "I Understand",
      confirmBtnColor: TColors.primary,
      confirmBtnTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: TColors.white,
      ),
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Dismiss the alert
        widget.onNext(age, score);
        widget.controller.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      },
    );
  }
}
