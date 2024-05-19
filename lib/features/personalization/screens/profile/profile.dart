import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/image/circular_image.dart';
import 'package:pinkribbonbhc/common/widgets/texts/section_heading.dart';
import 'package:pinkribbonbhc/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const TCircularImage(
                      image: TImages.user, width: 80, height: 80),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Change Profile Picture'))
                ],
              ),
            ),

            // Details
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),
            const TSectionHeading(
                title: 'Profile Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
                title: 'Name', value: 'Nur Alya Mazlan', onPressed: () {}),
            TProfileMenu(
                title: 'Username', value: 'alyamzln', onPressed: () {}),

            const SizedBox(height: TSizes.spaceBtwItems),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            const TSectionHeading(
                title: 'Personal Information', showActionButton: false),
            const SizedBox(height: TSizes.spaceBtwItems),

            TProfileMenu(
                title: 'E-mail',
                value: 'nur27alya@gmail.com',
                onPressed: () {}),
            TProfileMenu(
                title: 'Phone Number',
                value: '+60-175282598',
                onPressed: () {}),
            const Divider(),
            const SizedBox(height: TSizes.spaceBtwItems),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Close Account',
                    style: TextStyle(color: Colors.red)),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
