import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:pinkribbonbhc/features/self-exam/controllers/schedule_exam_controller.dart';
import 'package:pinkribbonbhc/features/self-exam/models/schedule_exam_model.dart';
import 'package:pinkribbonbhc/local_notification/notification_helper.dart';
import 'package:pinkribbonbhc/local_notification/notification_service.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class ScheduleExamPage extends StatefulWidget {
  @override
  _ScheduleExamPageState createState() => _ScheduleExamPageState();
}

class _ScheduleExamPageState extends State<ScheduleExamPage> {
  final ScheduleExamController _controller = ScheduleExamController();
  late DateTime _lastPeriodDate;
  late int _averageCycleLength;
  late DateTime _suggestedScheduleDate;
  late DateTime _userModifiedDate;
  bool _sendReminder = false;
  bool _dataSaved = false;
  late String userId;
  int _selfExamCount = 0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _initializeVariables();
    _getUserID();
  }

  void _initializeVariables() {
    _lastPeriodDate = DateTime.now();
    _averageCycleLength = 28;
    _suggestedScheduleDate = DateTime.now();
    _userModifiedDate = DateTime.now();
  }

  Future<void> _getUserID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      await _initializeUserDoc();
      _loadData();
      _loadSelfExamCount();
    } else {
      TLoaders.errorSnackBar(title: 'Error', message: 'User not signed in');
      Get.back();
    }
  }

  Future<void> _initializeUserDoc() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'selfExamCount': 0,
      });
    } else {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      int selfExamCount = userData['selfExamCount'] ?? 0;
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({
        'selfExamCount': selfExamCount,
      });
    }
  }

  Future<void> _loadData() async {
    ScheduleExam? scheduleExam = await _controller.loadScheduleExam(userId);
    if (scheduleExam != null) {
      setState(() {
        _lastPeriodDate = scheduleExam.lastPeriodDate;
        _averageCycleLength = scheduleExam.averageCycleLength;
        _sendReminder = scheduleExam.sendReminder;
        _userModifiedDate = scheduleExam.userModifiedDate;
        _suggestedScheduleDate = scheduleExam.suggestedScheduleDate;
        _dataSaved = true;
      });
    } else {
      setState(() {
        _lastPeriodDate = DateTime.now();
        _averageCycleLength = 28;
        _suggestedScheduleDate = DateTime.now();
        _userModifiedDate = DateTime.now();
      });
    }
  }

  Future<void> _loadSelfExamCount() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (userDoc.exists) {
      setState(() {
        _selfExamCount = userDoc.get('selfExamCount') ?? 0;
      });
    }
  }

  Future<void> _updateSelfExamCount(bool increment) async {
    setState(() {
      if (increment) {
        _selfExamCount++;
      } else {
        _selfExamCount--;
      }
    });
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'selfExamCount': _selfExamCount,
    });
  }

  Future<void> _saveData() async {
    ScheduleExam scheduleExam = ScheduleExam(
      lastPeriodDate: _lastPeriodDate,
      averageCycleLength: _averageCycleLength,
      suggestedScheduleDate: _suggestedScheduleDate,
      userModifiedDate: _userModifiedDate,
      sendReminder: _sendReminder,
    );
    await _controller.saveToLocal(scheduleExam);
    await _controller.saveScheduleExam(userId, scheduleExam);
    setState(() {
      _dataSaved = true;
    });

    // Schedule the notification
    // await NotificationHelper.scheduleNotification(
    //   'Breast Self-Exam Reminder',
    //   'It\'s time for your scheduled breast self-exam.',
    //   _userModifiedDate,
    // );

    print('Scheduling notification...');
    // Schedule the notification
    await NotificationHelper.scheduleNotification(
      title: 'Breast Self-Exam Reminder',
      body: 'It\'s time for your scheduled breast self-exam!',
      scheduledDateTime: _userModifiedDate,
    );
    print('Notification scheduled');

    TLoaders.successSnackBar(
        title: "Data saved successfully!",
        message:
            'A notification will be sent to you every month as a reminder to perform your breast self-exam.');
  }

  void _calculateSuggestedDate() {
    _suggestedScheduleDate =
        _lastPeriodDate.add(Duration(days: _averageCycleLength));
    _userModifiedDate = _suggestedScheduleDate;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _userModifiedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_userModifiedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _userModifiedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Your Next Self-Exam',
            style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dataSaved)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              'Your next self-check is scheduled for ${DateFormat('MMMM d, y - h:mm a').format(_userModifiedDate)}',
                              style: TextStyle(fontFamily: 'Poppins')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: ListTile(
                title: Text('Last Day of Last Period',
                    style: TextStyle(fontFamily: 'Poppins')),
                trailing: TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _lastPeriodDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _lastPeriodDate) {
                      setState(() {
                        _lastPeriodDate = picked;
                        _calculateSuggestedDate();
                      });
                    }
                  },
                  child: Text(_lastPeriodDate.toString().substring(0, 10)),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: ListTile(
                title: Text('Average Cycle Length (Days)',
                    style: TextStyle(fontFamily: 'Poppins')),
                trailing: DropdownButton<int>(
                  value: _averageCycleLength,
                  onChanged: (value) {
                    setState(() {
                      _averageCycleLength = value!;
                      _calculateSuggestedDate();
                    });
                  },
                  items: List.generate(
                    30,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: ListTile(
                title: Text('Suggested Schedule Date & Time',
                    style: TextStyle(fontFamily: 'Poppins')),
                trailing: TextButton(
                  onPressed: () async {
                    await _selectDateTime(context);
                  },
                  child: Text(DateFormat('yyyy-MM-dd – hh:mm a')
                      .format(_userModifiedDate)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save', style: TextStyle(fontFamily: 'Poppins')),
                ),
              ),
            ),
            SizedBox(height: 80.0),
            SizedBox(
              height: 70,
              child: DefaultTextStyle(
                style: TextStyle(
                    color: TColors.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Poppins'),
                child: Center(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    pause: Duration(milliseconds: 50),
                    animatedTexts: [
                      FadeAnimatedText(_isLiked
                          ? 'Great job!'
                          : 'Tap here to make your \nself-exam count!'),
                    ],
                  ),
                ),
              ),
            ),
            LikeButton(
              size: 80.0,
              animationDuration: Duration(milliseconds: 1500),
              onTap: (bool isLiked) async {
                setState(() {
                  _isLiked = !isLiked;
                });
                await _updateSelfExamCount(
                    _isLiked); // Increment or decrement self-exam count based on like state
                return !isLiked;
              },
            ),
            SizedBox(height: 16.0),
            Center(
                child: _isLiked
                    ? Text(
                        'You have completed $_selfExamCount self-exams\n \so far!',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            color: TColors.primary),
                        textAlign: TextAlign.center,
                      )
                    : Text('')),
          ],
        ),
      ),
    );
  }
}
