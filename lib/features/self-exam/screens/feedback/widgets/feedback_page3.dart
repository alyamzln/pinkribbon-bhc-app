import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/local_notification/notification_helper.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class FeedbackPage3 extends StatelessWidget {
  const FeedbackPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "What would you like to do next?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    onPressed: () {
                      Get.toNamed('/locator');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Locate screening centers and support groups',
                        style: TextStyle(fontFamily: 'Poppins'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Review symptoms',
                          style: TextStyle(fontFamily: 'Poppins')),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    onPressed: () {
                      // Calculate the reminder date one month later
                      DateTime reminderDate =
                          DateTime.now().add(Duration(days: 30));

                      // Show the reminder notification
                      NotificationHelper.scheduleNotification(
                        title: 'Checking in!',
                        body: 'Does your symptom still persist?',
                        scheduledDateTime: reminderDate,
                      );

                      // Show a success message to the user
                      TLoaders.successSnackBar(
                        title: 'Reminder set!',
                        message:
                            'You will be reminded to check your breast condition in a month.',
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Remind me to check a month later',
                          style: TextStyle(fontFamily: 'Poppins')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
