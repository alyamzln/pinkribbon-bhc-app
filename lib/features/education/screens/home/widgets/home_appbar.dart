import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/features/personalization/screens/settings/settings.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.homeAppbarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: TColors.grey)),
          Text(TTexts.homeAppbarSubTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: TColors.white))
        ],
      ),
      actions: [
        IconButton(
            onPressed: () => Get.to(() => const SettingsScreen()),
            icon: const Icon(
              Icons.settings,
              color: TColors.white,
            )),
      ],
    );
  }
}
