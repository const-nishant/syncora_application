import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Color(0xFFFFFFFF), // Background color
    onInverseSurface: Color(0xFFFFFFFF), // Foreground color
    primary: Colors.grey.shade900,
    onPrimary: Color(0xFF00AA00), // Primary Button Color
    secondary: Color(0xFF6A3200), // Secondary Button Color
    tertiary: Color(0xFFAAAAAA), // Tertiary Color
    inversePrimary: Colors.white,
  ),
);
