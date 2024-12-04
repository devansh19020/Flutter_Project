import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData darkTheme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColor.buttonBGColorDark,            // Primary color for dark mode buttons or interactive elements
      onPrimary: AppColor.textColorDark,              // Text color on primary elements in dark mode
      secondary: Colors.blue.shade200,                // Accent or secondary color in dark mode
      onSecondary: Colors.black,                      // Text color on secondary elements
      surface: AppColor.bodyColorDark,                // Surface color for dark mode cards, sheets, etc.
      onSurface: AppColor.textColorDark,              // Text color on surface in dark mode
      error: Colors.red.shade400,                     // Error color in dark mode
      onError: Colors.white,                          // Text color on error color in dark mode
      primaryContainer: AppColor.buttonBGColorDark,   // Button background color in dark mode
      onPrimaryContainer: AppColor.textColor,         // Text color on button background in dark mode
      surfaceContainerHighest: Colors.grey[700]!,     // Surface variant for darker elements
      outline: Colors.grey.shade500,                  // Outline or border color in dark mode
    ),
    textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        )
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      buttonColor: Colors.white,
    ),
    useMaterial3: true,
  );
}