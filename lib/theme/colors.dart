import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006E1C),
  onPrimary: Colors.white,
  secondary: Color(0xFF526600),
  onSecondary: Colors.white,
  surface: Colors.white,
  onSurface: Colors.black,
  error: Colors.red,
  onError: Colors.white,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF80E377),
  onPrimary: Colors.black,
  secondary: Color(0xFFCCF000),
  onSecondary: Colors.black,
  surface: Color(0xFF2D2D2D),
  onSurface: Colors.white,
  error: Colors.redAccent,
  onError: Colors.black,
);