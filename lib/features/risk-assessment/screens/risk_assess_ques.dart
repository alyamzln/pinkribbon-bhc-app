import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/features/risk-assessment/models/firestore_service.dart';
import 'package:pinkribbonbhc/features/risk-assessment/screens/widgets/question_page.dart';
import 'package:pinkribbonbhc/features/risk-assessment/screens/widgets/result_page.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';
import 'package:quickalert/quickalert.dart';

class RiskAssessmentQuestion extends StatefulWidget {
  @override
  _RiskAssessmentQuestionState createState() => _RiskAssessmentQuestionState();
}

class _RiskAssessmentQuestionState extends State<RiskAssessmentQuestion> {
  final FirestoreService _firestoreService = FirestoreService();
  PageController _controller = PageController(initialPage: 0);
  List<Map<String, dynamic>> _questions = [];
  List<Map<String, dynamic>> _questionStack = [];
  List<Map<String, dynamic>> _responses = [];
  List<double> _scores = [];
  int _currentPage = 0;
  int _totalQuestionCount =
      0; // New variable to track the total number of questions
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _getUserID();
  }

  Future<void> _getUserID() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        setState(() {
          _userID = user.uid;
        });
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Error getting user ID!');
    }
  }

  Future<void> _fetchQuestions() async {
    final questionsData = await _firestoreService.fetchRiskQuestions();
    setState(() {
      _questions = _parseQuestions(questionsData);
      _totalQuestionCount =
          _questions.length; // Initialize the total question count
    });

    print(_questions.length);
  }

  List<Map<String, dynamic>> _parseQuestions(Map<String, dynamic> data) {
    List<Map<String, dynamic>> questions = [];
    data.forEach((key, value) {
      List<dynamic> questionList = value['questions'] as List<dynamic>;
      questions.addAll(questionList.map((q) => q as Map<String, dynamic>));
    });
    return questions;
  }

  void _onAnswerSelected(
    double score,
    dynamic nextQuestions,
    bool showAlert,
    String alertMessage,
    Map<String, dynamic> selectedAnswer,
  ) {
    selectedAnswer['score'] = score;

    // Ensure highRisk field is included if not present
    if (!selectedAnswer.containsKey('highRisk')) {
      selectedAnswer['highRisk'] = false;
    }

    _scores.add(score);
    _responses.add(selectedAnswer);

    if (showAlert) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Important Information!',
        text: alertMessage,
        confirmBtnColor: TColors.primary,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          _proceedToNextQuestion(score, nextQuestions);
        },
      );
    } else {
      _proceedToNextQuestion(score, nextQuestions);
    }
  }

  void _proceedToNextQuestion(double score, dynamic nextQuestions) {
    if (nextQuestions != null) {
      if (nextQuestions is Map<String, dynamic>) {
        nextQuestions = [nextQuestions];
      }

      if (nextQuestions is List<dynamic> && nextQuestions.isNotEmpty) {
        setState(() {
          _questionStack.addAll(_questions.sublist(_currentPage + 1));
          _questions = _questions.sublist(0, _currentPage + 1) +
              nextQuestions.cast<Map<String, dynamic>>();
          _totalQuestionCount += (nextQuestions as List<dynamic>)
              .length; // Update the total question count
        });
      }
    } else {
      if (_questionStack.isNotEmpty) {
        setState(() {
          _questions.addAll(_questionStack);
          _questionStack.clear();
        });
      }
    }

    if (_currentPage < _questions.length - 1) {
      setState(() {
        _currentPage++;
      });
      _controller.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }

    print(_questions.length);
    print(_currentPage);
    print(_totalQuestionCount); // Print the total question count for debugging
  }

  void _goToPreviousQuestion() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _scores
            .removeLast(); // Remove the score of the current question when going back
        _responses
            .removeLast(); // Remove the response of the current question when going back
      });
      _controller.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  double _calculateTotalScore() {
    return _scores.fold(0.0, (previous, current) => previous + current);
  }

  void _submitAssessment() async {
    if (_responses.length < _totalQuestionCount) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Incomplete Assessment',
        text: 'Please answer all questions before submitting.',
      );
      return;
    }

    final String? userID = _userID;
    final double totalScore = _calculateTotalScore();
    final Timestamp assessmentDate = Timestamp.now();

    // Check if any answer has highRisk = true
    bool hasHighRisk =
        _responses.any((response) => response['highRisk'] == true);

    // Determine risk category
    String riskCategory;
    if (hasHighRisk || totalScore >= 10) {
      riskCategory = 'highRisk';
    } else if (totalScore > 5) {
      riskCategory = 'moderateRisk';
    } else {
      riskCategory = 'generalPopulation';
    }

    // Save the risk assessment to Firestore
    await _firestoreService.saveRiskAssessment(
      userID: userID,
      totalScore: totalScore,
      responses: _responses,
      assessmentDate: assessmentDate,
      riskCategory: riskCategory, // Add risk category to the assessment data
    );

    // Show success alert
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Assessment Submitted',
      text: 'Your risk assessment has been successfully submitted.',
      onConfirmBtnTap: () {
        Navigator.of(context).pop();
        Get.to(() => ResultPage(
            userRiskCategory:
                riskCategory)); // Pass risk category to the result page
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 127, 166),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goToPreviousQuestion,
        ),
        title: const Text('Risk Assessment',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _questions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : PageView.builder(
                    controller: _controller,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return QuestionWidget(
                        questionData: _questions[index],
                        onAnswerSelected: _onAnswerSelected,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Total Score: ${_calculateTotalScore()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_currentPage ==
                    _totalQuestionCount - 1) // Use total question count
                  SizedBox(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: _submitAssessment,
                      child: Text(
                        'Submit',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          side: BorderSide(
                            color: TColors.primary,
                          )),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
