import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinkribbonbhc/features/risk-assessment/models/risk_assess_model.dart';

class RiskAssessmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<RiskAssessment?> fetchRiskAssessment(String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('RiskAssessment')
        .where('userID', isEqualTo: userID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      return RiskAssessment.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<String> createOrUpdateRiskAssessment(
      String userID, double totalScore) async {
    RiskAssessment? existingAssessment = await fetchRiskAssessment(userID);

    if (existingAssessment != null) {
      await _firestore
          .collection('RiskAssessment')
          .doc(existingAssessment.id)
          .update({
        'totalScore': totalScore,
        'assessmentDate': FieldValue.serverTimestamp(),
      });
      return existingAssessment.id;
    } else {
      DocumentReference docRef =
          await _firestore.collection('RiskAssessment').add({
        'userID': userID,
        'totalScore': totalScore,
        'assessmentDate': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    }
  }

  Future<void> saveAssessmentResponse(String assessmentID, String questionID,
      String response, double score) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('AssessmentResponse')
        .where('assessmentID', isEqualTo: assessmentID)
        .where('questionID', isEqualTo: questionID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot existingDoc = querySnapshot.docs.first;
      await existingDoc.reference.update({
        'response': response,
        'score': score,
      });
    } else {
      await _firestore.collection('AssessmentResponse').add({
        'assessmentID': assessmentID,
        'questionID': questionID,
        'response': response,
        'score': score,
      });
    }
  }
}
