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

  void saveSymptomsAndNote(DateTime selectedDate) {
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

    final newEntry = {
      "symptom_selected": selectedSymptomsList.join(', '),
      "note": quickNote.value,
      "severity_level": selectedSeverity.value,
      "on_period": isOnPeriod.value ? "yes" : "no",
      "breastfeeding": isBreastfeeding.value ? "yes" : "no",
    };

    final formattedDate = _formatDate(selectedDate);
    final existingLogIndex =
        symptomLogs.indexWhere((log) => log['date_selected'] == formattedDate);

    if (existingLogIndex != -1) {
      symptomLogs[existingLogIndex]['entries'].add(newEntry);
    } else {
      symptomLogs.add({
        "date_selected": formattedDate,
        "entries": [newEntry],
      });
    }

    // Close the modal first, then show the success snackbar
    Get.back(); // Close the modal
    // Display success snackbar after successful save
    Future.delayed(Duration(milliseconds: 300), () {
      TLoaders.successSnackBar(title: 'Success', message: 'Symptoms saved!');
    });

    printSymptomLogs();
    resetSelection();
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
}
