import 'package:flutter/material.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/top_bar/top_bar.dart';
import 'package:pinkribbonbhc/features/education/models/edu_content/content.dart';
import 'package:pinkribbonbhc/features/education/models/edu_content/item_model.dart';
import 'package:pinkribbonbhc/features/education/screens/content/widgets/content_tile.dart';
import 'package:pinkribbonbhc/navigation_menu.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';

class ContentPage extends StatelessWidget {
  final String contentType;

  const ContentPage({Key? key, required this.contentType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Item> contentList = [];

    // Add logic to populate contentList based on the contentType parameter
    switch (contentType) {
      case 'symptom':
        SymptomContent symptomContent = SymptomContent();
        contentList.addAll(symptomContent.symptomContent);
        break;
      case 'mammogram':
        MammogramTips mammogramTips = MammogramTips();
        contentList.addAll(mammogramTips.mammogramTips);
        break;
      case 'myths_facts':
        MythsFacts mythsFacts = MythsFacts();
        contentList.addAll(mythsFacts.mythsFacts);
        break;
      default:
        // Handle default case or error
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(height: 200, child: TopBar()),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: ListView.builder(
              itemCount: contentList.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = contentList[index];
                return ContentTile(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}
