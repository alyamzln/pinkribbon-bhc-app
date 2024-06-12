import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/popups/full_screen_loader.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    Key? key,
  }) : super(key: key);

  void navigateToCategory(int index) {
    switch (index) {
      case 0:
        Get.toNamed('/locator'); // Navigate to Locator screen
        break;
      case 1:
        Get.toNamed('/records'); // Navigate to Records screen
        break;
      case 2:
        Get.toNamed('/risk'); // Navigate to Risk screen
        break;
      case 3:
        Get.toNamed('/trends'); // Navigate to Trends screen
        break;
      default:
        // Handle default case
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          String image;
          String title;

          // Assign different images and titles based on index
          switch (index) {
            case 0:
              image = TImages.locationIcon;
              title = 'Locator';
              break;
            case 1:
              image = TImages.notesIcon;
              title = 'Records';
              break;
            case 2:
              image = TImages.riskIcon;
              title = 'Risk';
              break;
            case 3:
              image = TImages.trendIcon;
              title = 'Trends';
              break;
            default:
              image = TImages.locationIcon;
              title = 'Location';
          }

          return TVerticalImageText(
            image: image,
            title: title,
            onTap: () => navigateToCategory(index),
          );
        },
      ),
    );
  }
}
