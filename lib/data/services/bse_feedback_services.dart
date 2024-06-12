import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveFeedback({
    required String userId,
    required String location,
    required String changeType,
    required String duration,
    required bool isOnPeriod,
    required DateTime? lastPeriodDate,
  }) async {
    await _db.collection('BSEFeedbacks').add({
      'userId': userId,
      'location': location,
      'changeType': changeType,
      'duration': duration,
      'isOnPeriod': isOnPeriod,
      'lastPeriodDate': lastPeriodDate,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
