import 'package:flutter/material.dart';

class Constants {
  // TODO: Replace with your actual OpenWeatherMap API Key
  static const String apiKey = 'YOUR_API_KEY_HERE';

  // App Colors
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color backgroundLight = Color(0xFFF3F4F6);
  static const Color textDark = Color(0xFF2C3E50);

  // Text Styles
  static const TextStyle tempStyle = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle cityStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textDark,
  );
}