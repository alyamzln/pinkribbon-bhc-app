import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/features/authentication/controllers/login/login_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: TColors.grey),
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: const Image(
              image: AssetImage(TImages.google),
              width: TSizes.iconMd,
              height: TSizes.iconMd,
            ),
          ),
        ),
      ],
    );
  }
}
