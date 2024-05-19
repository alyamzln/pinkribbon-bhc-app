import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class PageScreen extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const PageScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250, // Set the desired width for the image
          height: 300, // Set the desired height for the image
          child: Image.asset(
            image,
            fit:
                BoxFit.cover, // Adjust the fit as needed (cover, contain, etc.)
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
