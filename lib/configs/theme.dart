import 'package:flutter/material.dart';

final themeData = ThemeData(
  useMaterial3: false,
  colorSchemeSeed: Colors.blue,
  appBarTheme: const AppBarTheme(color: Colors.blue),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: Colors.blue),
);
