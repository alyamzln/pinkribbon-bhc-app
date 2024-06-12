import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pinkribbonbhc/utils/exceptions/firebase_exceptions.dart';
import 'package:pinkribbonbhc/utils/exceptions/platform_exceptions.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchRiskQuestions() async {
    try {
      List<String> parts = ['part1', 'part2', 'part3', 'part4', 'part5'];
      Map<String, dynamic> riskQuestions = {};

      for (String part in parts) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _db.collection('RiskQuestions').doc(part).get();
        riskQuestions[part] = snapshot.data()!;
      }

      return riskQuestions;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> saveRiskAssessment({
    required String? userID,
    required double totalScore,
    required List<Map<String, dynamic>> responses,
    required Timestamp assessmentDate,
    required String riskCategory, // Add this parameter
  }) async {
    try {
      final assessmentsRef = _db.collection('RiskAssessments');
      final snapshot =
          await assessmentsRef.where('userID', isEqualTo: userID).get();

      if (snapshot.docs.isEmpty) {
        await assessmentsRef.add({
          'userID': userID,
          'totalScore': totalScore,
          'assessmentDate': assessmentDate,
          'responses': responses,
          'riskCategory': riskCategory, // Save risk category
        });
      } else {
        await assessmentsRef.doc(snapshot.docs.first.id).update({
          'totalScore': totalScore,
          'assessmentDate': assessmentDate,
          'responses': responses,
          'riskCategory': riskCategory, // Update risk category
        });
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
