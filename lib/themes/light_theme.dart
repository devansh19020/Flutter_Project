import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData lightTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.buttonBGColor,                // Primary color for buttons or interactive elements
      onPrimary: AppColor.textColorDark,              // Text color on primary elements
      secondary: Colors.blue,                         // Accent or secondary color
      onSecondary: Colors.grey,                      // Text color on secondary elements// Background color for the app       // Text color on background
      surface: AppColor.bodyColor,                    // Surface color for cards, sheets, etc.
      onSurface: AppColor.textColor,                  // Text color on surface
      error: Colors.red,                              // Error color
      onError: Colors.white,                          // Text color on error color
      primaryContainer: AppColor.buttonBGColor,       // Button background color
      onPrimaryContainer: AppColor.textColorDark,     // Text on button background
      surfaceContainerHighest: Colors.grey[300]!,     // Surface variant for lighter elements
      outline: Colors.grey,                           // Outline or border color
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        color: Colors.blueAccent,
      ),
      headlineLarge: TextStyle(
          color: Colors.black,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      )
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      buttonColor: Colors.black,
    ),
    useMaterial3: true,
  );
}