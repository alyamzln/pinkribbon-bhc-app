// schedule_exam_model.dart
class ScheduleExam {
  final DateTime lastPeriodDate;
  final int averageCycleLength;
  final DateTime suggestedScheduleDate;
  final DateTime userModifiedDate;
  final bool sendReminder;

  ScheduleExam({
    required this.lastPeriodDate,
    required this.averageCycleLength,
    required this.suggestedScheduleDate,
    required this.userModifiedDate,
    required this.sendReminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'lastPeriodDate': lastPeriodDate.toIso8601String(),
      'averageCycleLength': averageCycleLength,
      'suggestedScheduleDate': suggestedScheduleDate.toIso8601String(),
      'userModifiedDate': userModifiedDate.toIso8601String(),
      'sendReminder': sendReminder,
    };
  }

  factory ScheduleExam.fromMap(Map<String, dynamic> map) {
    return ScheduleExam(
      lastPeriodDate: DateTime.parse(map['lastPeriodDate']),
      averageCycleLength: map['averageCycleLength'],
      suggestedScheduleDate: DateTime.parse(map['suggestedScheduleDate']),
      userModifiedDate: DateTime.parse(map['userModifiedDate']),
      sendReminder: map['sendReminder'],
    );
  }
}
