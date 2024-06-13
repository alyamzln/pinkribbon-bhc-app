import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/bindings/general_bindings.dart';
import 'package:pinkribbonbhc/bottom_menu.dart';
import 'package:pinkribbonbhc/features/authentication/screens/onboarding/onboarding.dart';
import 'package:pinkribbonbhc/features/education/screens/health_facilities/health_facilities.dart';
import 'package:pinkribbonbhc/features/education/screens/health_facilities/health_facilities_map.dart';
import 'package:pinkribbonbhc/features/education/screens/health_facilities/nearby_place_map.dart';
import 'package:pinkribbonbhc/features/education/screens/home/home.dart';
import 'package:pinkribbonbhc/features/risk-assessment/screens/widgets/result_page.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/breast_self_exam/self_exam_start.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/feedback/self_exam_feedback_list.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/history_records/self_exam_history.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/symptom_data_analytics.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/symptom_track_chart.dart';
import 'package:pinkribbonbhc/local_notification/notification_helper.dart';
import 'package:pinkribbonbhc/local_notification/notification_service.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/theme/widget_themes/theme.dart';

/// -- Use this Class to setup themes, initial Bindings, any animations and much more.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Initialise  localnotification
    NotificationHelper.init();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      initialRoute: '/bottomMenu',
      getPages: [
        GetPage(name: '/bottomMenu', page: () => BottomMenu()),
        GetPage(name: '/locator', page: () => HealthFacilities()),
        GetPage(name: '/records', page: () => SelfExamFeedbackList()),
        GetPage(name: '/trends', page: () => SymptomDataAnalytics()),
        GetPage(name: '/bseguide', page: () => SelfExamStart()),
      ],
      // Show loader or circular progress indicator meanwhile authentication repository is deciding to show relevent screen
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
