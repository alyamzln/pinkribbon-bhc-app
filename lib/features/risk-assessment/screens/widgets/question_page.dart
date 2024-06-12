import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:pinkribbonbhc/common/widgets/custom_button/custom_button.dart';

class QuestionWidget extends StatefulWidget {
  final Map<String, dynamic> questionData;
  final void Function(
      double score,
      dynamic nextQuestions,
      bool showAlert,
      String alertMessage,
      Map<String, dynamic> selectedAnswer) onAnswerSelected;

  const QuestionWidget(
      {required this.questionData, required this.onAnswerSelected, Key? key})
      : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    final answers =
        widget.questionData['answers'] ?? widget.questionData['answer'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 160,
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
              widget.questionData['question'] ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height:
                answers.length == 4 ? 300 : (answers.length == 3 ? 250 : 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  answers.length,
                  (index) {
                    final answer = answers[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: CustomButton(
                        onPressed: () {
                          setState(() {
                            _selectedOption = index;
                          });
                          var score = answer['score'];
                          var nextQuestions =
                              answer.containsKey('nextQuestions')
                                  ? answer['nextQuestions']
                                  : null;
                          var showAlert = answer['showAlert'] ?? false;
                          var alertMessage = answer['alertMessage'] ?? '';
                          var selectedAnswer = {
                            'question': widget.questionData['question'],
                            'answer': answer['text'],
                            'score': score,
                            'highRisk': answer['highRisk'] ?? false,
                          };
                          if (score is int) {
                            widget.onAnswerSelected(
                                score.toDouble(),
                                nextQuestions,
                                showAlert,
                                alertMessage,
                                selectedAnswer);
                          } else if (score is double) {
                            widget.onAnswerSelected(score, nextQuestions,
                                showAlert, alertMessage, selectedAnswer);
                          }
                        },
                        text: answer['text'],
                        alphabet: String.fromCharCode(65 + index),
                        isSelected: _selectedOption == index,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
