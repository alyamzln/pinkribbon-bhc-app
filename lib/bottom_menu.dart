import "package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:iconsax/iconsax.dart";
import "package:pinkribbonbhc/features/education/screens/home/home.dart";
import "package:pinkribbonbhc/features/personalization/screens/settings/settings.dart";
import "package:pinkribbonbhc/features/risk-assessment/screens/risk_assess_screen.dart";
import "package:pinkribbonbhc/features/self-exam/screens/breast_self_exam/self_exam_start.dart";
import "package:pinkribbonbhc/features/symptom-log/screens/symptom_log_screen.dart";
import "package:pinkribbonbhc/utils/constants/colors.dart";
import "package:pinkribbonbhc/utils/constants/image_strings.dart";
import "package:pinkribbonbhc/utils/helpers/helper_functions.dart";

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int pageIndex = 0;

  List<Widget> pages = [
    HomeScreen(),
    RiskAssessmentScreen(),
    SymptomLogScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: getFooter(),
      body: getBody(),
      floatingActionButton: SafeArea(
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            heroTag: 'bse',
            backgroundColor: TColors.primary,
            onPressed: () => Get.to(() => SelfExamStart()),
            shape: CircleBorder(),
            elevation: 5,
            child: Padding(
                padding: EdgeInsets.all(7),
                child: Image.asset(TImages.bseIcon)),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    final darkMode = THelperFunctions.isDarkMode(context);

    List<IconData> iconItems = [
      Iconsax.home,
      Iconsax.clipboard_text,
      Iconsax.book,
      Iconsax.user,
    ];
    return AnimatedBottomNavigationBar(
      backgroundColor: darkMode ? TColors.black : Colors.white,
      icons: iconItems,
      gapLocation: GapLocation.center,
      onTap: (index) {
        setTabs(index);
      },
      splashColor: TColors.primary,
      inactiveColor: darkMode ? TColors.light : TColors.dark,
      activeIndex: pageIndex,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      elevation: 2,
    );
  }

  void setTabs(index) {
    setState(() {
      pageIndex = index;
    });
  }

  void navigateToScreen(String route) {
    Navigator.pushNamed(context, route);
  }
}
