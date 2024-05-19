import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/features/symptom-log/controllers/symptom_select_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class AddNewSymptom extends StatelessWidget {
  final DateTime selectedDate;
  final symptomSelectController = Get.put((SymptomSelectController()));
  final TextEditingController noteController = TextEditingController();

  String selectedSeverity = '';

  final List<Map<String, dynamic>> severityLevels = [
    {'label': 'Mild', 'color': Colors.green},
    {'label': 'Moderate', 'color': Colors.orange},
    {'label': 'Severe', 'color': Colors.red},
  ];

  AddNewSymptom({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    final formatter = DateFormat('EEEE, MMMM d');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              ' ${_formatDate(selectedDate)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Add Symptom',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Select Symptom',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _buildSymptomContainer(context, 'Breast pain', TImages.breastPain,
                  Colors.lightBlue.shade100),
              _buildSymptomContainer(context, 'Lump in breast or underarm',
                  TImages.breastLump, Colors.purple.shade100),
              _buildSymptomContainer(context, 'Flaky skin on breast',
                  TImages.breastCrust, Colors.lightGreen.shade100),
              _buildSymptomContainer(context, 'Nipple discharge',
                  TImages.breastDischarge, Colors.pink.shade100),
              _buildSymptomContainer(context, 'Breast itching',
                  TImages.breastRash, Colors.teal.shade100),
              _buildSymptomContainer(context, 'Dimpled skin',
                  TImages.breastDimple, Colors.orange.shade100),
              _buildSymptomContainer(context, 'Breast enlarged',
                  TImages.breastEnlargement, Colors.red.shade100),
              _buildSymptomContainer(context, 'Breast sores',
                  TImages.breastPain, Colors.yellow.shade100),
              _buildSymptomContainer(context, 'Changes in breast size',
                  TImages.breastSize, Colors.green.shade100),
              _buildSymptomContainer(context, 'Thickening or swelling',
                  TImages.breastPain, Colors.blue.shade100),
              _buildSymptomContainer(context, 'Nipple pulling in',
                  TImages.breastPain, Colors.brown.shade100),
              _buildSymptomContainer(
                  context, 'Others', TImages.breastPain, Colors.grey.shade100),
            ]),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Note',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const Gap(6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Add quick note here',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
              maxLines: 2,
              onChanged: (value) {
                symptomSelectController.quickNote.value = value;
              },
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Severity Level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10.0),
          Obx(
            () => Wrap(
              spacing: 8.0,
              children: severityLevels.map((level) {
                bool isSelected =
                    symptomSelectController.selectedSeverity.value ==
                        level['label'];
                return ChoiceChip(
                  label: Text(
                    level['label'],
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500),
                  ),
                  selected: isSelected,
                  selectedColor: level['color'], // Use the specified color
                  onSelected: (selected) {
                    if (selected) {
                      // Update selected severity level using GetX
                      symptomSelectController.updateSeverity(level['label']);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12.0),
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: symptomSelectController.isOnPeriod.value,
                  onChanged: (value) {
                    symptomSelectController.updateOnPeriod(value ?? false);
                  },
                ),
                const Text('On Period'),
                const SizedBox(width: 12),
                Checkbox(
                  value: symptomSelectController.isBreastfeeding.value,
                  onChanged: (value) {
                    symptomSelectController.updateBreastfeeding(value ?? false);
                  },
                ),
                const Text('Breastfeeding'),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: TColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  side: BorderSide(color: TColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                onPressed: () {
                  symptomSelectController.resetSelection();
                  Get.back();
                },
                child: const Text('Cancel'),
              ),
            ),
            const Gap(20),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                onPressed: () {
                  symptomSelectController.saveSymptomsAndNote(selectedDate);
                },
                child: const Text('Save'),
              ),
            ),
          ])
        ],
      ),
    );
  }

  Widget _buildSymptomContainer(
    BuildContext context,
    String symptom,
    String imagePath,
    Color color,
  ) {
    return Obx(() {
      final isSelected =
          symptomSelectController.symptomsSelected[symptom] ?? false;
      return GestureDetector(
        onTap: () {
          symptomSelectController.toggleSymptom(symptom);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            width: 160, // Set a specific width here
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isSelected ? TColors.primary : TColors.lightPrimary,
                width: 2.0,
              ),
            ),
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        )
                      : Image.asset(
                          imagePath,
                          width: 24,
                          height: 24,
                        ),
                ),
                SizedBox(width: 10.0),
                Flexible(
                  child: Text(
                    symptom,
                    style: TextStyle(color: Colors.black),
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
