import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/page_screen/page_screen.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/bottom_buttons/bottom_buttons.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/common/widgets/success_screen/success_screen.dart';
import 'package:pinkribbonbhc/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:pinkribbonbhc/features/self-exam/screens/breast_self_exam/step_progress.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';

class SelfExamScreen extends StatefulWidget {
  @override
  _SelfExamScreenState createState() => _SelfExamScreenState();
}

class _SelfExamScreenState extends State<SelfExamScreen> {
  PageController _controller = PageController(initialPage: 0);
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          "Breast Self-Examination",
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        showBackArrow: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: StepProgress(currentStep: _currentPage, steps: 8)),
          Expanded(
            child: PageView(
              controller: _controller,
              children: const [
                PageScreen(
                    image: TImages.bseStep1,
                    title: 'Stand in front of a mirror',
                    subtitle:
                        'Standing in front of a mirror with straight shoulders and hands on your hips, look at your breasts. Check for any signs or symptoms.'),
                PageScreen(
                    image: TImages.bseStep2,
                    title: 'Raise your arms',
                    subtitle:
                        'Raise your arms straight up into the air and check for any changes on your breasts.'),
                PageScreen(
                    image: TImages.bseStep3,
                    title: 'Gently squeeze your nipple',
                    subtitle:
                        'Lower your arms and gently squeeze your nipples to check for leakage. Fluid could be watery, milky, yellow or bloody and come from one or both nipples.'),
                PageScreen(
                    image: TImages.bseStep4,
                    title: 'Use your three finger pads to feel your breasts',
                    subtitle:
                        'With the pads of your three middle fingers, press on every part of one breast. Use light pressure, medium, then firm.'),
                PageScreen(
                    image: TImages.bseStep5,
                    title: 'Make circular motions',
                    subtitle:
                        'With a smooth yet firm touch, make quarter-sized circular motions.'),
                PageScreen(
                    image: TImages.bseStep6,
                    title: 'Follow a pattern',
                    subtitle:
                        'Follow a pattern to make sure you cover the entire breast, vertically (from your collarbone to your abdomen) and horizontally (from your armpit to your cleavage).'),
                PageScreen(
                    image: TImages.bseStep7,
                    title: 'Use lawn-mowing pattern',
                    subtitle:
                        'Use the "lawn-mowing pattern" by moving your fingers up and down in vertical rows across the breast. You can also start at the nipple and move outward with larger and larger circles.'),
                PageScreen(
                    image: TImages.bseStep8,
                    title: 'Repeat steps 4 - 7',
                    subtitle:
                        "Repeat steps 4 to 7 while standing or sitting. It's super important to spend extra time in your armpit area as well. This is where your lymphatic system is.\nAnd that's it, you're done!"),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BottomButtons(
                pageController: _controller,
                currentPage: _currentPage,
              )),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
