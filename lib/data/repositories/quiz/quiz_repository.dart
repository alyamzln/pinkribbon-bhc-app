import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/features/education/models/quiz/quiz_model.dart';
import 'package:pinkribbonbhc/utils/exceptions/firebase_exceptions.dart';
import 'package:pinkribbonbhc/utils/exceptions/platform_exceptions.dart';

class QuizRepository extends GetxController {
  static QuizRepository get instance => Get.find();

  // Variables
  final _db = FirebaseFirestore.instance;

  // Get all quiz questions
  Future<List<QuizModel>> getQuizQuestions(String contentType) async {
    try {
      final snapshot = await _db
          .collection('EduContentQuiz')
          .doc(contentType)
          .collection('quiz')
          .get();
      final list = snapshot.docs
          .map((document) => QuizModel.fromSnapshot(document))
          .toList();

      print('list: $list');

      return list;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
