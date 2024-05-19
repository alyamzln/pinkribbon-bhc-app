import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final String eventTitle;
  final String eventDescp;
  final String eventSeverity;
  final String isOnPeriod;
  final String isBreastfeeding;

  DetailScreen({
    required this.eventTitle,
    required this.eventDescp,
    required this.eventSeverity,
    required this.isOnPeriod,
    required this.isBreastfeeding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Symptom Details',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ));
  }
}
