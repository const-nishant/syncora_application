import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
  dialogTheme: DialogTheme(
    titleTextStyle: TextStyle(
      color: Colors.grey.shade500,
    ),
    contentTextStyle: TextStyle(
      color: Colors.grey.shade500,
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(Colors.white),
    ),
  ),
);
