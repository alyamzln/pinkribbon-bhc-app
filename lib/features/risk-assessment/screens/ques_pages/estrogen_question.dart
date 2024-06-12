import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/widgets/custom_button/custom_button.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:quickalert/quickalert.dart';

class EstrogenQuestionPage extends StatefulWidget {
  final PageController controller;

  const EstrogenQuestionPage({Key? key, required this.controller})
      : super(key: key);

  @override
  _EstrogenQuestionPageState createState() => _EstrogenQuestionPageState();
}

class _EstrogenQuestionPageState extends State<EstrogenQuestionPage> {
  int _currentPage = 0;
  int _selectedOption = -1; // Track selected option for the current question

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Did you start your period before age 11?',
      'answers': ['Yes', 'No'],
      'showAlert': false,
    },
    {
      'question':
          'Have you entered menopause yet? (no period for at least 12 months)',
      'answers': ['Yes', 'No'],
      'showAlert': false,
    },
    {
      'question': 'Have you ever given birth?',
      'answers': ['Yes', 'No'],
      'showAlert': false,
    },
    {
      'question': 'How old were you when your first child was born?',
      'answers': ['Age 34 and younger', 'Age 35 and older'],
      'showAlert': false,
      'conditional': true,
    },
    {
      'question': 'Have you breastfed?',
      'answers': ['Yes', 'No'],
      'showAlert': false,
      'conditional': true,
    },
    {
      'question': 'Have you ever taken Hormone Replacement Therapy (HRT)?',
      'answers': ['Yes', 'No'],
      'showAlert': true,
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

        // Skip optional questions if the user has not given birth
        if (_currentPage == 3 && _questions[2]['answers'][score] == 'No') {
          _currentPage += 2; // Skip the next two questions
        }
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
    String alertText = score == 1
        ? "Talk to your doctor about the risks and benefits of taking pills or medicines that contain estrogen."
        : "In the future, talk to your doctor about the risks and benefits of taking pills or medicines that contain estrogen.";

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
