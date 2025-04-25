import 'package:butterfly/theme/colors.dart';
import 'package:butterfly/theme/typography.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: lightColorScheme,
      useMaterial3: true,
      fontFamily: 'Poppins',
      textTheme: customTextTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      fontFamily: 'Poppins',
      textTheme: customTextTheme,
    );
  }
}
