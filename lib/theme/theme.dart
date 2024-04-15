import 'package:flutter/material.dart';

// light theme
ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      inversePrimary: Colors.grey.shade800,
    ));

// dark theme
ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Color.fromARGB(255, 20, 20, 20),
      secondary: Colors.grey.shade700,
      inversePrimary: Colors.grey.shade300,
    ));
