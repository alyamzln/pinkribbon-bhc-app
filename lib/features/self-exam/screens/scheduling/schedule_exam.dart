import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/features/self-exam/controllers/schedule_exam_controller.dart';
import 'package:pinkribbonbhc/features/self-exam/models/schedule_exam_model.dart';
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
      _loadData();
    } else {
      // Handle user not signed in scenario
      // You may want to redirect to a login page or show a message
      TLoaders.errorSnackBar(title: 'Error', message: 'User not signed in');
      Get.back();
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
    // Show success snackbar
    Get.snackbar(
      "Data saved successfully!",
      'A notification will be sent to you every month as a reminder to perform your breast self-exam.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _calculateSuggestedDate() {
    _suggestedScheduleDate =
        _lastPeriodDate.add(Duration(days: _averageCycleLength));
    _userModifiedDate = _suggestedScheduleDate;
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
                              'Your next self-check is scheduled for ${DateFormat('MMMM d, y').format(_userModifiedDate)}',
                              style: TextStyle(fontFamily: 'Poppins')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16.0),

            // Last Period Date Input Field (Date Picker)
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

            // Average Cycle Length Input Field (Dropdown)
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

            // Suggested Schedule Date (Date Picker)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: ListTile(
                title: Text('Suggested Schedule Date',
                    style: TextStyle(fontFamily: 'Poppins')),
                trailing: TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _userModifiedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null && picked != _userModifiedDate) {
                      setState(() {
                        _userModifiedDate = picked;
                      });
                    }
                  },
                  child: Text(_userModifiedDate.toString().substring(0, 10)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Save Button
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
          ],
        ),
      ),
    );
  }
}
