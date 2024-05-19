import 'package:flutter/material.dart';

class TColors {
  TColors._(); //To avoid creating instances

  // App theme colors
  static const Color primary = Color(0xFFAD1457);
  static const Color secondary = Color.fromARGB(255, 255, 116, 78);
  static const Color accent = Colors.pinkAccent;

  static const Color mediumPrimary = Color.fromARGB(255, 201, 96, 142);
  static const Color lightPrimary = Color.fromARGB(255, 252, 244, 247);
  static const Color lightSecondary = Color.fromARGB(255, 254, 244, 228);

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Gradient colors
  static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
        Color.fromARGB(255, 183, 52, 109),
        Color.fromARGB(255, 201, 96, 142),
        Color.fromARGB(255, 213, 149, 177),
      ]);

  // Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

  // Button colors
  static const Color buttonPrimary = Color(0xFFAD1457);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);
  static const Color buttonLightSecondary = Color.fromARGB(255, 233, 242, 251);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
