import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart'; // Import package for date formatting

class SelfExamFeedbackBk extends StatefulWidget {
  @override
  _SelfExamFeedbackState createState() => _SelfExamFeedbackState();
}

class _SelfExamFeedbackState extends State<SelfExamFeedbackBk> {
  int _currentStep = 0;
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController seenBeforeController = TextEditingController();
  final TextEditingController lastSeenController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  DateTime? lastPeriodDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Self-Exam Feedback'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep < 2) {
              _currentStep += 1;
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            }
          });
        },
        steps: [
          Step(
            title: Text(''),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(TImages.calmDown),
                SizedBox(height: 20),
                Text(
                  "Don't Panic!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Many changes are normal, but it's always smart to check them out. Continue to the next page to take some notes on what you found.",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            isActive: _currentStep == 0,
          ),
          Step(
            title: Text(''),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Answer a few questions below on what you found.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today is: ${DateFormat('MMMM d, yyyy').format(DateTime.now())}",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: symptomsController,
                          decoration: InputDecoration(
                            labelText:
                                'What did you feel/see and what does it feel/look like?',
                          ),
                        ),
                        TextFormField(
                          controller: locationController,
                          decoration: InputDecoration(
                            labelText: 'Where did you feel/see it?',
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Is it both breasts or just one?",
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          value: null,
                          onChanged: (value) {},
                          items: ['Both breasts', 'Just one breast']
                              .map((option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Have you seen it before?",
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          value: null,
                          onChanged: (value) {
                            setState(() {
                              if (value == 'Yes') {
                                // Show additional input field
                                lastSeenController.clear();
                              } else {
                                lastSeenController.text = 'Not Applicable';
                              }
                            });
                          },
                          items: ['Yes', 'No']
                              .map((option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                        ),
                        if (lastSeenController.text == 'Yes')
                          TextFormField(
                            controller: lastSeenController,
                            decoration: InputDecoration(
                              labelText:
                                  'When did you see it last and for how long?',
                            ),
                          ),
                        SizedBox(height: 20),
                        Text(
                          "Is it constant or does it come and go?",
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          value: null,
                          onChanged: (value) {},
                          items: ['Constant', 'Comes and goes', 'Unsure']
                              .map((option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you on your period?",
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButtonFormField<String>(
                          value: null,
                          onChanged: (value) {
                            setState(() {
                              if (value == 'No') {
                                // Show additional input field
                                lastPeriodDate = DateTime.now();
                                periodController.text = lastPeriodDate != null
                                    ? DateFormat('MMMM d, yyyy')
                                        .format(lastPeriodDate!)
                                    : '';
                              } else {
                                periodController.text = 'Not Applicable';
                              }
                            });
                          },
                          items: ['Yes', 'No']
                              .map((option) => DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                        ),
                        if (periodController.text == 'No')
                          TextFormField(
                            controller: periodController,
                            readOnly: true,
                            onTap: () {
                              // Show date picker
                              showDatePicker(
                                context: context,
                                initialDate: lastPeriodDate ?? DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  setState(() {
                                    lastPeriodDate = selectedDate;
                                    periodController.text =
                                        DateFormat('MMMM d, yyyy')
                                            .format(selectedDate);
                                  });
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText:
                                  'What was the last day of your last period?',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add save button functionality here
                    },
                    child: Text('Save'),
                  ),
                ),
              ],
            ),
            isActive: _currentStep == 1,
          ),
          Step(
            title: Text(''),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "What would you like to do next?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Locate nearby hospitals button
                      },
                      child: Text('Locate nearby hospitals'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Review symptoms button
                      },
                      child: Text('Review symptoms'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Remind me to check a month later button
                      },
                      child: Text('Remind me to check a month later'),
                    ),
                  ],
                ),
              ],
            ),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }
}
