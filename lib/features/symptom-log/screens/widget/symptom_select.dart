import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/features/symptom-log/controllers/symptom_select_controller.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class SymptomSelectPage extends StatelessWidget {
  final DateTime selectedDate;
  final symptomSelectController = Get.put((SymptomSelectController()));
  final TextEditingController noteController = TextEditingController();

  SymptomSelectPage({Key? key, required this.selectedDate}) : super(key: key);

  String _formatDate(DateTime date) {
    final formatter = DateFormat('EEEE, MMMM d');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' ${_formatDate(selectedDate)}',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Select Your Symptoms',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3.2, // Adjust as needed
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildSymptomContainer(
                      context, 'Breast pain', TImages.breastPain),
                  _buildSymptomContainer(context, 'Lump in breast or underarm',
                      TImages.breastLump),
                  _buildSymptomContainer(
                      context, 'Flaky skin on breast', TImages.breastCrust),
                  _buildSymptomContainer(
                      context, 'Nipple discharge', TImages.breastDischarge),
                  _buildSymptomContainer(
                      context, 'Breast itching', TImages.breastRash),
                  _buildSymptomContainer(
                      context, 'Dimpled skin', TImages.breastDimple),
                  _buildSymptomContainer(
                      context, 'Breast enlarged', TImages.breastEnlargement),
                  _buildSymptomContainer(
                      context, 'Breast sores', TImages.breastPain),
                  _buildSymptomContainer(
                      context, 'Changes in breast size', TImages.breastSize),
                  _buildSymptomContainer(
                      context, 'Thickening or swelling', TImages.breastPain),
                  _buildSymptomContainer(
                      context, 'Nipple pulling in', TImages.breastPain),
                  _buildSymptomContainer(context, 'Others', TImages.breastPain),
                ],
              ),
              SizedBox(
                  height:
                      18.0), // Add spacing between symptoms and note container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Add a quick note...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: ElevatedButton(
          onPressed: () {
            if (symptomSelectController.symptomsSelected.values
                .every((selected) => !selected)) {
              // Check if no symptom is selected
              TLoaders.errorSnackBar(
                  title: 'Error',
                  message: 'Please select at least one symptom');
            } else {
              symptomSelectController.quickNote.value = noteController.text;
              symptomSelectController.printSymptomLogs();
            }
          },
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomContainer(
      BuildContext context, String symptom, String imagePath) {
    return Obx(() {
      final isSelected =
          symptomSelectController.symptomsSelected[symptom] ?? false;
      return GestureDetector(
        onTap: () {
          symptomSelectController.symptomsSelected[symptom] = !isSelected;
        },
        child: Container(
          decoration: BoxDecoration(
            color: TColors.lightPrimary,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? TColors.primary : TColors.lightPrimary,
              width: 2.0,
            ),
          ),
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 10.0),
              Flexible(
                child: Text(
                  symptom,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
