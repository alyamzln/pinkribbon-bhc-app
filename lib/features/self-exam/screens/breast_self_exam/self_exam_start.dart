import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/breast_self_exam/self_exam_screen.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class SelfExamStart extends StatefulWidget {
  const SelfExamStart({Key? key}) : super(key: key);

  @override
  State<SelfExamStart> createState() => _SelfExamStartState();
}

class _SelfExamStartState extends State<SelfExamStart> {
  DateTime? _userModifiedDate;

  @override
  void initState() {
    super.initState();
    _loadUserModifiedDate();
  }

  Future<void> _loadUserModifiedDate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('ScheduleExams')
          .doc(userId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> scheduleExamData =
            doc.data() as Map<String, dynamic>;
        if (scheduleExamData.containsKey('userModifiedDate')) {
          var userModifiedDate = scheduleExamData['userModifiedDate'];
          DateTime? parsedDate;
          if (userModifiedDate is Timestamp) {
            parsedDate = userModifiedDate.toDate();
          } else if (userModifiedDate is String) {
            parsedDate = DateTime.tryParse(userModifiedDate);
          }

          if (parsedDate != null) {
            setState(() {
              _userModifiedDate = parsedDate;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Breast Self-Examination',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: TColors.white),
                    ),
                    showBackArrow: true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            if (_userModifiedDate != null)
              Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                                'Your next self-check is scheduled for ${DateFormat('MMMM d, y - h:mm a').format(_userModifiedDate!)}',
                                style: TextStyle(fontFamily: 'Poppins')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 320,
                    child: Image.asset(TImages.startBSE, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                    child: Text(
                      "When to Self-Exam?",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                    child: Text(
                      "The best time to breast self-exam is a few days after the end of your period when you are least tender or swollen. No period? Do it the first day of the month.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => SelfExamScreen()),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Adjust the radius as needed
                      ),
                      backgroundColor: TColors.secondary,
                      side: BorderSide(color: TColors.secondary)),
                  child: Text(
                    'Start Your Self-Examination',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
