import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/features/symptom-log/controllers/symptom_select_controller.dart';
import 'package:pinkribbonbhc/features/symptom-log/models/symptom.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/add_symptom_widget.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/edit_symptom_widget.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/severity_color_util.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
import 'package:quickalert/quickalert.dart';
import 'package:table_calendar/table_calendar.dart';

class SymptomTrackCalendar extends StatefulWidget {
  const SymptomTrackCalendar({Key? key}) : super(key: key);

  @override
  State<SymptomTrackCalendar> createState() => _SymptomTrackCalendarState();
}

class _SymptomTrackCalendarState extends State<SymptomTrackCalendar> {
  DateTime today = DateTime.now();
  final SymptomSelectController _symptomController =
      Get.put(SymptomSelectController());

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  void initState() {
    super.initState();
    _symptomController.fetchSymptomLogs();
  }

  void _editSymptom(Map<String, dynamic> symptom) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      context: context,
      builder: (context) => EditSymptom(
        selectedDate: today,
        selectedSymptomData: symptom,
      ),
    ).then((_) {
      // Refresh data after editing
      _symptomController.fetchSymptomLogs();
    });
  }

  void _deleteSymptom(Map<String, dynamic> symptom) {
    _symptomController.deleteSymptom(today, symptom).then((_) {
      // Refresh data after editing
      _symptomController.fetchSymptomLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                locale: 'en_US',
                headerStyle: HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TColors.primary,
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: TColors.primary.withOpacity(0.5),
                    )),
                eventLoader: (day) {
                  return _symptomController.getEventsForDate(day);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Obx(
                () {
                  final symptomsForDate =
                      _symptomController.getSymptomsForDate(today);
                  if (symptomsForDate.isEmpty) {
                    return const Text('No symptoms recorded for this day.');
                  }
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: symptomsForDate.length,
                      itemBuilder: (context, index) {
                        final symptom = symptomsForDate[index];
                        final severityColor =
                            SeverityColorUtil.getSeverityColor(
                                symptom['severity_level']);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side:
                                  BorderSide(color: severityColor, width: 1.3),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: severityColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: TColors.secondary),
                                  onPressed: () => _editSymptom(symptom),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete,
                                        color: TColors.secondary),
                                    onPressed: () {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.warning,
                                          title: 'Delete Symptom',
                                          text:
                                              'Are you sure you want to delete this symptom?',
                                          confirmBtnText: 'Delete',
                                          confirmBtnColor: TColors.primary,
                                          onConfirmBtnTap: () {
                                            _deleteSymptom(symptom);
                                            Navigator.pop(context);
                                          });
                                    }),
                              ],
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                '${symptom['symptom_selected']}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            subtitle: Text('${symptom['severity_level']}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'symptomButton',
        onPressed: () {
          _symptomController
              .resetSelection(); // Call the resetSelection method before showing the bottom sheet
          showModalBottomSheet(
            isScrollControlled: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            context: context,
            builder: (context) => AddNewSymptom(selectedDate: today),
          );
        },
        label: const Text(
          'Add Symptom',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: TColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30.0), // Adjust the radius as needed
        ),
      ),
    );
  }
}
