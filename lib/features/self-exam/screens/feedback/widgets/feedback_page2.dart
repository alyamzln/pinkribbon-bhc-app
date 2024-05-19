import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:pinkribbonbhc/utils/constants/sizes.dart';

class FeedbackPage2 extends StatefulWidget {
  const FeedbackPage2({Key? key}) : super(key: key);

  @override
  _FeedbackPage2State createState() => _FeedbackPage2State();
}

class _FeedbackPage2State extends State<FeedbackPage2> {
  String selectedLocation = 'Left breast';
  String selectedChangeType = 'Lump';
  bool showOtherChangeTypeField = false;
  String selectedDuration = '1 day';
  bool isOnPeriod = false;
  DateTime? lastPeriodDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Answer a few questions below on what you found.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 24),
          Text(
            "Today is: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}",
            style: TextStyle(
              fontSize: 16,
              color: TColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          const Text(
            'Where did you find the change? (Specify left breast, right breast, or both)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const Gap(6),
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLocation,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocation = newValue!;
                    });
                  },
                  items: <String>['Left breast', 'Right breast', 'Both']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          const Text(
            'What type of change did you notice? (Lump, thickening, swelling, etc.)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const Gap(6),
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedChangeType,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedChangeType = newValue!;
                          showOtherChangeTypeField = newValue == 'Other';
                        });
                      },
                      items: <String>['Lump', 'Thickening', 'Swelling', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  if (showOtherChangeTypeField)
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          ),
                          maxLines: 1,
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          const Text(
            'How long have you noticed the change?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          const Gap(6),
          Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDuration,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDuration = newValue!;
                    });
                  },
                  items: <String>[
                    '1 day',
                    '1 week',
                    '1 month',
                    'More than 1 month'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: isOnPeriod,
                onChanged: (value) {
                  setState(() {
                    isOnPeriod = value!;
                  });
                },
              ),
              Text('Are you on your period?'),
            ],
          ),
          if (isOnPeriod)
            Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide.none),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Date of last period',
                    labelStyle: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    border: InputBorder.none, // Remove input border
                    hintText: 'Select date',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        lastPeriodDate = pickedDate;
                      });
                    }
                  },
                  readOnly: true,
                  controller: TextEditingController(
                    text: lastPeriodDate != null
                        ? DateFormat('yyyy-MM-dd').format(lastPeriodDate!)
                        : '',
                  ),
                ),
              ),
            ),
          const Gap(20),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                onPressed: () {},
                child: const Text(
                  'Save',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
