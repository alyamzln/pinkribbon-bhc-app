// schedule_exam_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinkribbonbhc/features/self-exam/models/schedule_exam_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleExamController {
  final CollectionReference _scheduleExamsCollection =
      FirebaseFirestore.instance.collection('ScheduleExams');

  Future<void> saveScheduleExam(
      String userId, ScheduleExam scheduleExam) async {
    await _scheduleExamsCollection.doc(userId).set(scheduleExam.toMap());
  }

  Future<ScheduleExam?> loadScheduleExam(String userId) async {
    DocumentSnapshot doc = await _scheduleExamsCollection.doc(userId).get();
    if (doc.exists) {
      return ScheduleExam.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> saveToLocal(ScheduleExam scheduleExam) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'lastPeriodDate', scheduleExam.lastPeriodDate.toIso8601String());
    await prefs.setInt('averageCycleLength', scheduleExam.averageCycleLength);
    await prefs.setString('suggestedScheduleDate',
        scheduleExam.suggestedScheduleDate.toIso8601String());
    await prefs.setString(
        'userModifiedDate', scheduleExam.userModifiedDate.toIso8601String());
    await prefs.setBool('sendReminder', scheduleExam.sendReminder);
  }

  Future<ScheduleExam?> loadFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastPeriodDateString = prefs.getString('lastPeriodDate');
    if (lastPeriodDateString == null) {
      return null;
    }
    return ScheduleExam(
      lastPeriodDate: DateTime.parse(lastPeriodDateString),
      averageCycleLength: prefs.getInt('averageCycleLength') ?? 28,
      suggestedScheduleDate:
          DateTime.parse(prefs.getString('suggestedScheduleDate')!),
      userModifiedDate: DateTime.parse(prefs.getString('userModifiedDate')!),
      sendReminder: prefs.getBool('sendReminder') ?? false,
    );
  }
}
