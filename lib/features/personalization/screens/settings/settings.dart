import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/common/widgets/list_titles/setttings_menu_tile.dart';
import 'package:pinkribbonbhc/common/widgets/list_titles/user_profile_tile.dart';
import 'package:pinkribbonbhc/common/widgets/texts/section_heading.dart';
import 'package:pinkribbonbhc/features/personalization/screens/profile/profile.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          TPrimaryHeaderContainer(
              child: Column(
            children: [
              TAppBar(
                title: Text(
                  'Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(color: TColors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TUserProfileTile(
                    onPressed: () => Get.to(() => const ProfileScreen())),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          )),
          // Body
          Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const TSectionHeading(
                    title: 'Account Settings', showActionButton: false),
                const SizedBox(
                  height: TSizes.spaceBtwItems,
                ),
                TSettingsMenuTile(
                  icon: Iconsax.password_check,
                  title: 'Change password',
                  subTitle: 'Change your password',
                  onTap: () {},
                ),
                TSettingsMenuTile(
                  icon: Iconsax.notification,
                  title: 'Notifications',
                  subTitle: 'Set notifications for timely reminder',
                  onTap: () {},
                ),
                TSettingsMenuTile(
                  icon: Iconsax.share,
                  title: 'Share',
                  subTitle: 'Share this app to others',
                  onTap: () {},
                ),
                TSettingsMenuTile(
                  icon: Iconsax.woman,
                  title: 'Next self-check',
                  subTitle: 'View or schedule your next self-check',
                  onTap: () {},
                ),
                TSettingsMenuTile(
                  icon: Iconsax.location,
                  title: 'Geolocation',
                  subTitle: 'Set recommendation based on location',
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),

                // Logout Button
                const SizedBox(height: TSizes.spaceBtwSections),
                SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Logout'),
                    )),
                const SizedBox(height: TSizes.spaceBtwSections * 2.5),
              ],
            ),
          )
        ],
      )),
    );
  }
}
