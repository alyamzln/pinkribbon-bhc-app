import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String id;
  String question;
  String answer;
  String option1;
  String option2;
  String option3;
  String option4;

  QuizModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  });

  // Empty Helper Function
  static QuizModel empty() => QuizModel(
      id: '',
      question: '',
      answer: '',
      option1: '',
      option2: '',
      option3: '',
      option4: '');

  // Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
    };
  }

  factory QuizModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      // Map JSON record to the model
      return QuizModel(
        id: document.id,
        question: data['question'] ?? '',
        answer: data['answer'] ?? '',
        option1: data['option1'] ?? '',
        option2: data['option2'] ?? '',
        option3: data['option3'] ?? '',
        option4: data['option4'] ?? '',
      );
    } else {
      return QuizModel.empty();
    }
  }
}
