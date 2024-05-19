import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinkribbonbhc/common/widgets/appbar/appbar.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/symptom_data_analytics.dart';
import 'package:pinkribbonbhc/features/symptom-log/screens/symptom_track_calendar.dart';
import 'package:pinkribbonbhc/utils/constants/colors.dart';

class SymptomLogScreen extends StatelessWidget {
  const SymptomLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Symptom Tracker', style: TextStyle(fontFamily: 'Poppins')),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Iconsax.calendar, color: TColors.primary),
                ),
                Tab(
                  icon: Icon(Iconsax.chart_square, color: TColors.primary),
                ),
                Tab(
                  icon: Icon(Iconsax.clock, color: TColors.primary),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Container(
                  child: SymptomTrackCalendar(),
                ),
                Container(
                  child: Center(
                    child: SymptomDataAnalytics(),
                  ),
                ),
                Container(
                  child: Center(
                    child: Text('3RD TAB'),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
