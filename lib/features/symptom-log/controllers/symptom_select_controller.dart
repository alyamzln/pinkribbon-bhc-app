import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pinkribbonbhc/utils/popups/loaders.dart';

class SymptomSelectController extends GetxController {
  var symptomsSelected = <String, bool>{}.obs;
  var quickNote = ''.obs;
  var symptomLogs = <Map<String, dynamic>>[].obs;
  var selectedSymptoms = <String>[].obs;
  var selectedSeverity = ''.obs;
  RxBool isOnPeriod = false.obs;
  RxBool isBreastfeeding = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var eventMap = <DateTime, List<String>>{}.obs;

  final List<Map<String, dynamic>> severityLevels = [
    {'label': 'Mild', 'color': Colors.green},
    {'label': 'Moderate', 'color': Colors.orange},
    {'label': 'Severe', 'color': Colors.red},
  ];

  @override
  void onInit() {
    super.onInit();
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

  // Get all dates with symptoms recorded
  List<DateTime> getRecordedDates() {
    return symptomLogs.map((log) {
      return DateTime.parse(log['date_selected']);
    }).toList();
  }

  // Get events for a specific date
  List<String> getEventsForDate(DateTime date) {
    final formattedDate = _formatDate(date);
    final log = symptomLogs.firstWhere(
        (log) => log['date_selected'] == formattedDate,
        orElse: () => <String, dynamic>{});
    if (log.isNotEmpty) {
      return log['entries']
          .map<String>((entry) => entry['symptom_selected'] as String)
          .toList();
    }
    return [];
  }

  // Get detailed symptoms for a specific date
  List<Map<String, dynamic>> getSymptomsForDate(DateTime date) {
    final formattedDate = _formatDate(date);
    final log = symptomLogs.firstWhere(
        (log) => log['date_selected'] == formattedDate,
        orElse: () => <String, dynamic>{});
    if (log.isNotEmpty) {
      return log['entries'];
    }
    return [];
  }

  void resetSelection() {
    symptomsSelected.clear(); // Clear all selections
    quickNote.value = ''; // Reset quick note
    selectedSeverity.value = ''; // Reset selected severity
    isOnPeriod.value = false; // Reset period status
    isBreastfeeding.value = false; // Reset breastfeeding status
  }

  void toggleSymptom(String symptom) {
    // Check if symptomsSelected is null and initialize it if needed
    symptomsSelected.value ??= {};
    // Toggle symptom selection
    symptomsSelected[symptom] = !(symptomsSelected[symptom] ?? false);
    updateSelectedSymptoms();
  }

  void updateSelectedSymptoms() {
    // Ensure symptomsSelected is not null
    symptomsSelected.value ??= {};
    // Update selectedSymptoms list
    selectedSymptoms.value = symptomsSelected.keys
        .where((symptom) => symptomsSelected[symptom] == true)
        .toList();
  }

  void updateSeverity(String severity) {
    selectedSeverity.value = severity;
  }

  void updateOnPeriod(bool value) {
    isOnPeriod.value = value;
  }

  void updateBreastfeeding(bool value) {
    isBreastfeeding.value = value;
  }

  Future<void> saveSymptomsAndNote(DateTime selectedDate) async {
    final selectedSymptomsList = symptomsSelected.keys
        .where((symptom) => symptomsSelected[symptom] == true)
        .toList();

    // Check if symptoms are selected and severity level is chosen
    if (selectedSymptomsList.isEmpty || selectedSeverity.value.isEmpty) {
      // Display error snackbar for missing inputs
      TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Please select symptoms and severity level.');
      return;
    }

    // Generate a unique ID for the new entry
    final uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    final newEntry = {
      "id": uniqueId, // Add unique ID here
      "symptom_selected": selectedSymptomsList.join(', '),
      "note": quickNote.value,
      "severity_level": selectedSeverity.value,
      "on_period": isOnPeriod.value ? "yes" : "no",
      "breastfeeding": isBreastfeeding.value ? "yes" : "no",
    };

    final formattedDate = _formatDate(selectedDate);

    try {
      // Get user's document reference
      final userDocRef = _firestore.collection('SymptomLogs').doc(userId);

      // Get user's symptom log or create a new one
      final userLog = await userDocRef.get();
      final logData = userLog.exists ? userLog.data()! : {};

      // Get existing log entries or create a new list
      final entries = logData.containsKey(formattedDate)
          ? List<Map<String, dynamic>>.from(logData[formattedDate])
          : [];

      // Add the new entry
      entries.add(newEntry);

      // Update the log data
      logData[formattedDate] = entries;
      print("Log Data: $logData");

      // Save the updated log data
      await userDocRef.set(logData.cast<String, dynamic>());

      // Update local state (if needed)
      fetchSymptomLogs();
      print('Symptom logs: $symptomLogs');

      // Close the modal first, then show the success snackbar
      Get.back(); // Close the modal
      // Display success snackbar after successful save
      Future.delayed(Duration(milliseconds: 300), () {
        TLoaders.successSnackBar(title: 'Success', message: 'Symptoms saved!');
      });
    } catch (e) {
      print('Error saving symptom log: $e');
      // Display error snackbar for saving error
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Error saving symptom log.',
      );
    }

    // printSymptomLogs();
    resetSelection();
  }

  void editSymptom(DateTime selectedDate, String id,
      Map<String, dynamic> updatedSymptom) async {
    final formattedDate = _formatDate(selectedDate);

    try {
      final userDocRef = _firestore.collection('SymptomLogs').doc(userId);

      final userLog = await userDocRef.get();
      final logData = userLog.exists ? userLog.data()! : {};

      // Get the entries for the selected date
      final entries = logData.containsKey(formattedDate)
          ? List<Map<String, dynamic>>.from(logData[formattedDate])
          : [];

      // Find the entry with the matching ID and update it
      for (var entry in entries) {
        if (entry['id'] == id) {
          entry['symptom_selected'] = updatedSymptom['symptom_selected'];
          entry['note'] = updatedSymptom['note'];
          entry['severity_level'] = updatedSymptom['severity_level'];
          // Update other fields as needed...
          break;
        }
      }

      // Update the log data
      logData[formattedDate] = entries;

      // Save the updated log data
      await userDocRef.set(logData.cast<String, dynamic>());

      fetchSymptomLogs();
    } catch (e) {
      print('Error editing symptom log: $e');
      // Display error snackbar for saving error
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Error editing symptom log.',
      );
    }
  }

  // Delete a symptom
  Future<void> deleteSymptom(
      DateTime date, Map<String, dynamic> symptom) async {
    try {
      final formattedDate = _formatDate(date);
      final logIndex = symptomLogs
          .indexWhere((log) => log['date_selected'] == formattedDate);
      if (logIndex != -1) {
        final entries =
            List<Map<String, dynamic>>.from(symptomLogs[logIndex]['entries']);
        entries.removeWhere((entry) =>
            entry['symptom_selected'] == symptom['symptom_selected']);
        symptomLogs[logIndex]['entries'] = entries;

        // Update Firestore document
        await _firestore
            .collection('SymptomLogs')
            .doc(userId)
            .update({formattedDate: entries});
      }
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error!', message: 'Error deleting symptom!');
      throw Exception('Error deleting symptom: $e');
    }
  }

  Future<void> fetchSymptomLogs() async {
    try {
      final userDocRef = _firestore.collection('SymptomLogs').doc(userId);
      final userLog = await userDocRef.get();
      final logData =
          userLog.exists ? userLog.data() as Map<String, dynamic> : {};

      // Clear symptomLogs and eventMap before updating
      symptomLogs.clear();
      eventMap.clear();

      logData.forEach((date, entries) {
        final formattedDate = DateTime.parse(date);
        final normalizedDate = DateTime(
            formattedDate.year, formattedDate.month, formattedDate.day);
        final formattedEntries =
            (entries as List<dynamic>).cast<Map<String, dynamic>>();

        final logsForDate = {
          'date_selected': _formatDate(formattedDate),
          'entries': formattedEntries,
        };
        symptomLogs.add(logsForDate);

        // Update eventMap
        eventMap[normalizedDate] = formattedEntries
            .map((entry) => entry['symptom_selected'] as String)
            .toList();
      });

      print('Symptom logs fetched:');
      print(symptomLogs);
      print('Event Map:');
      print(eventMap);
    } catch (e) {
      print('Error fetching symptom logs: $e');
    }
  }

  void printSymptomLogs() {
    symptomLogs.forEach((log) {
      print('Date: ${log['date_selected']}');
      log['entries'].forEach((entry) {
        print(
            'Symptom: ${entry['symptom_selected']}, Note: ${entry['note']}, Severity: ${entry['severity_level']}, On Period: ${entry['on_period']}, Breastfeeding: ${entry['breastfeeding']}');
      });
    });
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  // Set selected symptoms
  void setSelectedSymptoms(List<String> symptoms) {
    symptomsSelected.clear();
    for (var symptom in symptoms) {
      symptomsSelected[symptom] = true;
    }
  }

  // Update symptoms and note
  void updateSymptomsAndNote(DateTime selectedDate) async {
    final formattedDate = _formatDate(selectedDate);

    final updatedData = {
      'symptom_selected': symptomsSelected.keys.toList(),
      'severity_level': selectedSeverity.value,
      'note': quickNote.value,
      'on_period': isOnPeriod.value ? 'yes' : 'no',
      'breastfeeding': isBreastfeeding.value ? 'yes' : 'no',
    };

    print('Updated data: $updatedData');

    try {
      // Get user's document reference
      final userDocRef = _firestore.collection('SymptomLogs').doc(userId);

      // Get user's symptom log or create a new one
      final userLog = await userDocRef.get();
      final logData =
          userLog.exists ? userLog.data() as Map<String, dynamic> : {};

      // Get existing log entries or create a new list
      final entries = logData.containsKey(formattedDate)
          ? List.from(logData[formattedDate] as List<dynamic>)
          : [];

      // Find and update existing entry or add a new one
      final updatedEntries = entries.map((entry) {
        if (entry['symptom_selected'] == updatedData['symptom_selected']) {
          return updatedData;
        } else {
          return entry;
        }
      }).toList();

      // Update the log data
      logData[formattedDate] = updatedEntries;

      print('Updated log data: $logData');

      // Save the updated log data
      await userDocRef.set(logData.cast<String, dynamic>());
    } catch (e) {
      print('Error updating symptom log: $e');
    }
  }
}
