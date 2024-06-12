import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  String text;
  int score;
  bool showAlert;
  String alertMessage;
  List<Question>? nextQuestions;

  Answer({
    required this.text,
    required this.score,
    required this.showAlert,
    required this.alertMessage,
    this.nextQuestions,
  });

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      text: map['text'],
      score: map['score'],
      showAlert: map['showAlert'],
      alertMessage: map['alertMessage'],
      nextQuestions: map['nextQuestions'] != null
          ? List<Question>.from(map['nextQuestions']
              .map((nextQuestion) => Question.fromMap(nextQuestion)))
          : null,
    );
  }
}

class Question {
  String question;
  List<Answer> answers;

  Question({
    required this.question,
    required this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      answers: List<Answer>.from(
          map['answers'].map((answer) => Answer.fromMap(answer))),
    );
  }
}

class Part {
  String part;
  List<Question> questions;

  Part({
    required this.part,
    required this.questions,
  });

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      part: map['part'],
      questions: List<Question>.from(
          map['questions'].map((question) => Question.fromMap(question))),
    );
  }
}

class RiskAssessment {
  String id;
  String userID;
  double totalScore;
  DateTime assessmentDate;

  RiskAssessment(
      {required this.id,
      required this.userID,
      required this.totalScore,
      required this.assessmentDate});

  factory RiskAssessment.fromMap(Map<String, dynamic> data, String documentId) {
    return RiskAssessment(
      id: documentId,
      userID: data['userID'],
      totalScore: data['totalScore'],
      assessmentDate: (data['assessmentDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'totalScore': totalScore,
      'assessmentDate': assessmentDate,
    };
  }
}

class AssessmentResponse {
  String id;
  String assessmentID;
  String questionID;
  String response;
  double score;

  AssessmentResponse(
      {required this.id,
      required this.assessmentID,
      required this.questionID,
      required this.response,
      required this.score});

  factory AssessmentResponse.fromMap(
      Map<String, dynamic> data, String documentId) {
    return AssessmentResponse(
      id: documentId,
      assessmentID: data['assessmentID'],
      questionID: data['questionID'],
      response: data['response'],
      score: data['score'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assessmentID': assessmentID,
      'questionID': questionID,
      'response': response,
      'score': score,
    };
  }
}
