import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/features/symptom-log/controllers/symptom_select_controller.dart';
import 'package:pinkribbonbhc/features/symptom-log/models/symptom.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/add_symptom_widget.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/detail_screen.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/severity_color_util.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/widget/symptom_select.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';
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

  // Store the events/symptoms created
  Map<DateTime, List<Symptom>> symptoms = {};

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: symptomsForDate.length,
                    itemBuilder: (context, index) {
                      final symptom = symptomsForDate[index];
                      final severityColor = SeverityColorUtil.getSeverityColor(
                          symptom['severity_level']);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                eventTitle: symptom['symptom_selected'],
                                eventDescp: symptom['note'],
                                eventSeverity: symptom['severity_level'],
                                isOnPeriod: symptom['on_period'],
                                isBreastfeeding: symptom['breastfeeding'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
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
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: TColors.secondary,
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'symptomButton',
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          context: context,
          builder: (context) => AddNewSymptom(selectedDate: today),
        ),
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
