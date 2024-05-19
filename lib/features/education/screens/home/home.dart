import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/liquid_swipe_screen/liquid_swipe_screen.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/common/widgets/images/rounded_image.dart';
import 'package:pinkribbonbhc/common/widgets/texts/section_heading.dart';
import 'package:pinkribbonbhc/features/education/screens/home/widgets/home_appbar.dart';
import 'package:pinkribbonbhc/features/education/screens/home/widgets/home_categories.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // List of content types corresponding to each card
  final List<String> contentTypes = [
    'breast_cancer_symptoms',
    'tips_mammogram',
    'myths_facts'
  ];

  // List of image URLs for each card
  final List<String> cardImages = [
    TImages.symptomBanner,
    TImages.mammogramBanner,
    TImages.mythsFactsBanner,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TPrimaryHeaderContainer(
            child: Column(
              children: [
                /// -- Appbar --
                THomeAppBar(),
                SizedBox(height: TSizes.spaceBtwItems),
                THomeCategories(),
              ],
            ),
          ),

          const Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: TSectionHeading(title: 'Breast Cancer Insights')),

          // Body
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: ListView.builder(
                itemCount: cardImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TRoundedImage(
                      imageURL: cardImages[index],
                      onPressed: () => Get.to(() =>
                          MyLiquidSwipePage(contentType: contentTypes[index])),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
