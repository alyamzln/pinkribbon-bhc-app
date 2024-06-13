import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart'; // Ensure to add cloud_firestore package

class SymptomDataAnalytics extends StatefulWidget {
  const SymptomDataAnalytics({super.key});

  @override
  State<SymptomDataAnalytics> createState() => _SymptomDataAnalyticsState();
}

class _SymptomDataAnalyticsState extends State<SymptomDataAnalytics> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<DateTime, Map<String, int>> symptomFrequency = {};

  @override
  void initState() {
    super.initState();
    fetchSymptomLogs();
  }

  // Get the current user's ID
  String get userId {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        return user.uid;
      } else {
        throw Exception('User is not logged in.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Error getting user ID!');
      throw Exception('Error getting user ID: $e');
    }
  }

  Future<void> fetchSymptomLogs() async {
    try {
      final userDocRef = _firestore.collection('SymptomLogs').doc(userId);
      final userLog = await userDocRef.get();
      final logData =
          userLog.exists ? userLog.data() as Map<String, dynamic> : {};

      symptomFrequency.clear();

      logData.forEach((date, entries) {
        final formattedDate = DateTime.parse(date);
        final normalizedDate = DateTime(
            formattedDate.year, formattedDate.month, formattedDate.day);
        final formattedEntries =
            (entries as List<dynamic>).cast<Map<String, dynamic>>();

        formattedEntries.forEach((entry) {
          final symptom = entry['symptom_selected'] as String;

          if (!symptomFrequency.containsKey(normalizedDate)) {
            symptomFrequency[normalizedDate] = {};
          }

          if (!symptomFrequency[normalizedDate]!.containsKey(symptom)) {
            symptomFrequency[normalizedDate]![symptom] = 0;
          }

          symptomFrequency[normalizedDate]![symptom] =
              symptomFrequency[normalizedDate]![symptom]! + 1;
        });
      });

      setState(() {}); // Trigger a rebuild to update the UI with fetched data
      print('Symptom frequency fetched:');
      print(symptomFrequency);
    } catch (e) {
      print('Error fetching symptom logs: $e');
    }
  }

  Map<DateTime, Map<String, int>> groupByPeriod(
      Map<DateTime, Map<String, int>> data, String period) {
    Map<DateTime, Map<String, int>> groupedData = {};

    data.forEach((date, symptoms) {
      DateTime keyDate;
      switch (period) {
        case 'weekly':
          keyDate = DateTime(date.year, date.month,
              date.day - date.weekday + 1); // Start of the week
          break;
        case 'monthly':
          keyDate = DateTime(date.year, date.month, 1); // Start of the month
          break;
        default:
          keyDate = date; // Daily
      }

      if (!groupedData.containsKey(keyDate)) {
        groupedData[keyDate] = {};
      }

      symptoms.forEach((symptom, count) {
        if (!groupedData[keyDate]!.containsKey(symptom)) {
          groupedData[keyDate]![symptom] = 0;
        }
        groupedData[keyDate]![symptom] =
            groupedData[keyDate]![symptom]! + count;
      });
    });

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Symptom Data Analytics',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        elevation: 20,
        centerTitle: true,
      ),
      body: symptomFrequency.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.info_outline, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No symptom data recorded yet.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Symptom Overview',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 300, child: _buildBarChart('daily')),
                    const SizedBox(height: 24),
                    const Text(
                      'Weekly Symptom Overview',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 300, child: _buildBarChart('weekly')),
                    const SizedBox(height: 24),
                    const Text(
                      'Monthly Symptom Overview',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 300, child: _buildBarChart('monthly')),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBarChart(String period) {
    final groupedData = groupByPeriod(symptomFrequency, period);
    final List<DateTime> dates = groupedData.keys.toList()..sort();

    final List<String> symptoms = [
      'Breast pain',
      'Breast itching',
      'Lump in breast or underarm',
      'Flaky skin on breast',
      'Nipple discharge',
      'Dimpled skin'
          'BreastEnlarged',
      'Breast Sores',
      'Changes in breast size',
      'Thickening or swelling',
      'Nipple pulling in'
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceBetween,
        maxY: _findMaxY(groupedData, symptoms),
        barGroups: dates.asMap().entries.map((entry) {
          int index = entry.key;
          DateTime date = entry.value;
          return _buildBarGroup(index, date, groupedData[date]!, symptoms);
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= dates.length) {
                  return Container();
                }
                final date = dates[value.toInt()];
                String formattedDate;
                switch (period) {
                  case 'weekly':
                    formattedDate = DateFormat('MM/dd').format(date);
                    break;
                  case 'monthly':
                    formattedDate = DateFormat('MMM').format(date);
                    break;
                  default:
                    formattedDate = DateFormat('MM/dd').format(date);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12.0, color: Colors.black),
                  ),
                );
              },
            ),
            axisNameWidget: const Text(
              'Date',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            axisNameSize: 20,
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12.0, color: Colors.black),
                );
              },
            ),
            axisNameWidget: const Text(
              'Symptom Count',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            axisNameSize: 20,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.shade300),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (spot) => Colors.blueAccent,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final symptom = symptoms[rodIndex];
              final value = rod.toY.toInt();
              final date = dates[groupIndex];
              String formattedDate;
              switch (period) {
                case 'weekly':
                  formattedDate = DateFormat('MM/dd').format(date);
                  break;
                case 'monthly':
                  formattedDate = DateFormat('MMM').format(date);
                  break;
                default:
                  formattedDate = DateFormat('MM/dd').format(date);
              }
              return BarTooltipItem(
                '$symptom\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: '$formattedDate: $value',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int index, DateTime date,
      Map<String, int> symptomData, List<String> symptoms) {
    return BarChartGroupData(
      x: index,
      barRods: symptoms.map((symptom) {
        final color = [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.brown,
          Colors.pink,
          Colors.cyan,
          Colors.indigo,
          Colors.teal,
          Colors.yellow,
        ][symptoms.indexOf(symptom) % 10];

        return BarChartRodData(
          toY: symptomData[symptom]?.toDouble() ?? 0.0,
          color: color,
          width: 8.0,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        );
      }).toList(),
    );
  }

  double _findMaxY(
      Map<DateTime, Map<String, int>> groupedData, List<String> symptoms) {
    double maxY = 0;
    groupedData.forEach((date, symptomData) {
      symptomData.forEach((symptom, count) {
        if (count > maxY) {
          maxY = count.toDouble();
        }
      });
    });
    return maxY + 1;
  }
}
