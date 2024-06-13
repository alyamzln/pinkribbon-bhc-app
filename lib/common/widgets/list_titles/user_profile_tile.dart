import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinkribbonbhc/features/education/controllers/user/username_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';

class TUserProfileTile extends StatelessWidget {
  const TUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final UserNameController userController = Get.put(UserNameController());

    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(TImages.user),
      ),
      title: Obx(() {
        return Text(
            userController.firstName.value +
                " " +
                userController.lastName.value,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: TColors.white));
      }),
      subtitle: Obx(() {
        return Text(userController.email.value,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(color: TColors.white));
      }),
      trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(Iconsax.edit, color: TColors.white)),
    );
  }
}
