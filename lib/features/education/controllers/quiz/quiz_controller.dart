import 'package:get/get.dart';
import 'package:pinkribbonbhc/data/repositories/quiz/quiz_repository.dart';
import 'package:pinkribbonbhc/features/education/models/quiz/quiz_model.dart';
import 'package:pinkribbonbhc/features/education/screens/quiz/quiz_result.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class QuizController extends GetxController {
  static QuizController get instance => Get.find();

  final isLoading = false.obs;
  final _quizRepository = Get.put(QuizRepository());
  RxList<QuizModel> _quizQuestions = <QuizModel>[].obs;
  RxInt _currentQuestionIndex = 0.obs;
  RxInt _selectedOption = RxInt(0);
  RxBool _isCorrectAnswer = RxBool(false);
  RxBool _showCorrectAnswer = RxBool(false);

  int _score = 0;
  int _totalQuestionsAttempted = 0;
  int _correctAttempts = 0;

  List<QuizModel> get quizQuestions => _quizQuestions;
  int get currentQuestionIndex => _currentQuestionIndex.value;
  int get selectedOption => _selectedOption.value;
  int get score => _score;
  int get totalQuestionsAttempted => _totalQuestionsAttempted;
  int get correctAttempts => _correctAttempts;
  bool get isCorrectAnswer => _isCorrectAnswer.value;

  // Load Quiz Data
  Future<void> fetchQuizQuestions(String contentType) async {
    try {
      // Show loader while loading quiz questions
      isLoading.value = true;

      print('Content type: $contentType');

      // Fetch quiz questions from data source
      final quizQuestions = await _quizRepository.getQuizQuestions(contentType);

      // Update the quiz questions list
      _quizQuestions.assignAll(quizQuestions);

      print('Quiz questions fetched successfully: $_quizQuestions');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  void selectOption(int optionIndex) {
    if (!_showCorrectAnswer.value) {
      _selectedOption.value = optionIndex;
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    final currentQuestion = _quizQuestions[_currentQuestionIndex.value];
    final correctOptionIndex = _getCorrectOptionIndex(currentQuestion);

    if (_selectedOption.value == correctOptionIndex) {
      _isCorrectAnswer.value = true;
      _correctAttempts++;
    } else {
      _isCorrectAnswer.value = false;
    }

    _totalQuestionsAttempted++;
    _score = (_correctAttempts / _totalQuestionsAttempted * 100).toInt();

    _showCorrectAnswer.value = true;

    // Automatically change to the next question after a delay
    Future.delayed(Duration(seconds: 1), nextQuestion);
  }

  int _getCorrectOptionIndex(QuizModel question) {
    // Return the index of the correct answer based on the answer string
    if (question.answer == "1") {
      return 1;
    } else if (question.answer == "2") {
      return 2;
    } else if (question.answer == "3") {
      return 3;
    } else if (question.answer == "4") {
      return 4;
    } else {
      return 0;
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex.value < _quizQuestions.length - 1) {
      // Move to the next question if available
      _currentQuestionIndex.value++;
      _selectedOption.value = 0; // Reset selected option for the next question
      _isCorrectAnswer.value = false; // Reset correctness indicator
      _showCorrectAnswer.value = false; // Hide correct answer indicator
    } else {
      // Quiz completed, navigate to the result screen or any other screen
      Get.offAll(QuizResultScreen());
    }
  }
}
