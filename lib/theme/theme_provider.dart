import 'package:flutter/material.dart';
import 'package:langwiz/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  // Initially Theme will be light
  ThemeData _themeData = lightMode;

  // getter method to access theme from other parts of code
  ThemeData get themeData => _themeData;

  // getter method to see if we are in dark mode or not
  bool get isDarkMode => _themeData == darkMode;

  // setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // function to toggle theme, will be used to switch theme later on
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    notifyListeners();
  }
}
