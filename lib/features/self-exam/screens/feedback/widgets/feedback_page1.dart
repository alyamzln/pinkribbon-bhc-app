import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';
import 'package:pinkribbonbhc/utils/helpers/helper_functions.dart';

class FeedbackPage1 extends StatelessWidget {
  const FeedbackPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(children: [
          Image(
              width: THelperFunctions.screenWidth() * 0.8,
              height: THelperFunctions.screenHeight() * 0.5,
              image: const AssetImage(TImages.relaxGirl)),
          Text(
            "Don't Panic!",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TSizes.spaceBtwItems),
          Text(
            "Many changes are normal, but it's always smart to check them out. Continue to the next page to take some notes on what you found.",
            style: TextStyle(fontSize: 15.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: TSizes.spaceBtwItems),
        ]));
  }
}
