import 'package:flutter/material.dart';

class SeverityColorUtil {
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
        return Colors.green.withOpacity(0.5);
      case 'moderate':
        return Colors.orange.withOpacity(0.5);
      case 'severe':
        return Colors.red.withOpacity(0.5);
      default:
        return Colors.grey
            .withOpacity(0.5); // default color if severity is not matched
    }
  }
}
