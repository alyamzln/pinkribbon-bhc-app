import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/bindings/general_bindings.dart';
import 'package:pinkribbonbhc/features/authentication/screens/onboarding/onboarding.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/theme/widget_themes/theme.dart';

/// -- Use this Class to setup themes, initial Bindings, any animations and much more.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      // Show loader or circular progress indicator meanwhile authentication repository is deciding to show relevent screen
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
