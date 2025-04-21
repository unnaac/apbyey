import 'package:flutter/material.dart';

class AppTheme {
  static const String fontFamily = 'Poppins';

  static final ThemeData lightTheme = ThemeData(
    fontFamily: fontFamily,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(
      secondary: Colors.blueAccent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge:
          TextStyle(fontSize: 16.0, color: Colors.black), // For large body text
      bodyMedium:
          TextStyle(fontSize: 14.0, color: Colors.grey), // For medium body text
      titleLarge: TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold), // For large titles
    ),
  );
}
