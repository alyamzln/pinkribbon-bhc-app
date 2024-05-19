import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/features/education/models/edu_content/item_model.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';

class ContentTile extends StatelessWidget {
  final Item item;

  const ContentTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes the shadow position
          ),
        ],
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(25),
      width: 350,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // content image
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  child: Image.asset(item.imagePath)),
            ),

            // content title
            Center(
              child: Text(
                item.title,
                style: const TextStyle(
                    color: TColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),

            const SizedBox(height: 10),

            // content description
            Text(item.description, style: TextStyle(fontSize: 15)),
          ]),
    );
  }
}
