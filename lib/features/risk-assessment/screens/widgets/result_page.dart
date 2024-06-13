import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:pinkribbonbhc/features/education/screens/home/home.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class ResultPage extends StatefulWidget {
  ResultPage({
    super.key,
    required this.userRiskCategory,
  });

  final String userRiskCategory;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String riskCategory = '';
  List<String> criteria = [];
  Map<String, dynamic> recommendations = {};

  @override
  void initState() {
    super.initState();
    fetchResult();
  }

  Future<void> fetchResult() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('BreastCancerRiskLevels')
        .doc(widget.userRiskCategory)
        .get();
    setState(() {
      riskCategory = snapshot['level'];
      criteria = List<String>.from(snapshot['criteria']);
      recommendations = Map<String, dynamic>.from(snapshot['recommendations']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Result and Recommendations',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .apply(color: TColors.white),
                    ),
                    showBackArrow: true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Your risk assessment results indicate that you are in the',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Center(
                    child: Text(
                      riskCategory.toUpperCase() + ' CATEGORY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: getCategoryColor(riskCategory),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const TopContainer(
                    title: 'Risk Criteria',
                    backgroundColor: TColors.primary,
                  ),
                  BottomContainer(
                    content: buildCriteriaContent(),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Use this as a guide to discuss with your doctor the following:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const TopContainer(
                    title: 'Recommendations',
                    backgroundColor: TColors.secondary,
                  ),
                  BottomContainer(
                    content: buildRecommendationsContent(),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/bottomMenu');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white,
                          foregroundColor: TColors.primary,
                          side: BorderSide(color: TColors.primary)),
                      child: Text(
                        'Back to Homepage',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/locator');
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: TColors.primary,
                          foregroundColor: Colors.white,
                          side: BorderSide(color: TColors.primary)),
                      child: Text(
                        'Search Nearby Health Facilities',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'general population':
        return Colors.green;
      case 'moderate risk':
        return Colors.orange;
      case 'high risk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildCriteriaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: criteria
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '● $item',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget buildRecommendationsContent() {
    List<Widget> recommendationsList = [];
    recommendations.forEach((key, value) {
      String iconPath;
      switch (key) {
        case 'CBE':
          iconPath = TImages.cbeIcon;
          break;
        case 'mammography':
          iconPath = TImages.mammogramIcon;
          break;
        case 'MRI':
          iconPath = TImages.mriIcon;
          break;
        default:
          iconPath = '';
      }
      recommendationsList.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        iconPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  value['description'],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: TColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...value.entries
                .where((entry) => entry.key != 'description')
                .map((entry) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '● ${entry.key.replaceAll('_', ' ')} years old',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: ': ${entry.value['frequency']} \n',
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      TextSpan(
                        text: 'Source: ${entry.value['source']}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: Color.fromARGB(255, 25, 124, 206),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recommendationsList,
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({
    super.key,
    required this.content,
  });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: content,
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({
    super.key,
    required this.title,
    required this.backgroundColor,
  });

  final String title;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
