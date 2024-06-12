import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/widgets/custom_button/custom_button.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:quickalert/quickalert.dart';

class LifestyleQuestionPage extends StatefulWidget {
  final PageController controller;

  const LifestyleQuestionPage({Key? key, required this.controller})
      : super(key: key);

  @override
  _LifestyleQuestionPageState createState() => _LifestyleQuestionPageState();
}

class _LifestyleQuestionPageState extends State<LifestyleQuestionPage> {
  int _currentPage = 0;
  int _selectedOption = -1; // Track selected option for the current question

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Do you smoke, or drink alcohol regularly?',
      'answers': ['Yes', 'No'],
      'showAlert': false,
    },
    {
      'question': 'Are you overweight?',
      'answers': ['Yes', 'No'],
      'showAlert': false,
    },
    {
      'question': 'How much do you exercise a day?',
      'answers': [
        '20+ minutes',
        '8+ minutes',
        '5 minutes or less',
        'I am a statue'
      ],
      'showAlert': false,
    },
  ];

  void _nextPage(int score) {
    // Show the alert if needed
    if (_questions[_currentPage]['showAlert']) {
      _showAlert(context, score);
    }

    // Add a delay before moving to the next page to allow users to see the color change
    Future.delayed(Duration(seconds: 1), () {
      if (_currentPage < _questions.length - 1) {
        setState(() {
          _currentPage++;
          _selectedOption = -1; // Reset selected option for the new question
        });
      } else {
        widget.controller.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _selectedOption = -1; // Reset selected option for the new question
      });
    } else {
      widget.controller.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _showAlert(BuildContext context, int score) {
    String alertText = score == 0
        ? "This can increase your risk for breast cancer and other diseases."
        : "Good work! Reducing your smoking or alcohol intake can help lower your risk.";

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Important Note!",
      text: alertText,
      confirmBtnText: "I Understand",
      confirmBtnColor: TColors.primary,
      confirmBtnTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: TColors.white,
      ),
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Dismiss the alert
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: GestureDetector(
              onTap: _previousPage,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 280,
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
                height: 100,
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
                    _questions[_currentPage]['question'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
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
                    children: List.generate(
                      _questions[_currentPage]['answers'].length,
                      (i) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: CustomButton(
                          onPressed: () {
                            setState(() {
                              _selectedOption = i;
                            });
                            _nextPage(i);
                          },
                          text: _questions[_currentPage]['answers'][i],
                          alphabet: String.fromCharCode(65 + i),
                          isSelected: _selectedOption == i,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
