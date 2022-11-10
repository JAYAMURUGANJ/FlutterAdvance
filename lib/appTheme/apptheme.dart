// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
export 'bloc/theme_bloc.dart';
export 'view/theme_page.dart';
export 'package:hydrated_bloc/hydrated_bloc.dart';

enum AppTheme {
  GreenLight,
  GreenDark,
  BlueLight,
  BlueDark,
}

final appThemeData = {
  AppTheme.GreenLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    primarySwatch: Colors.green,
    appBarTheme: const AppBarTheme(
      color: Colors.green,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
      ),
    ),
  ),
  AppTheme.GreenDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.green[700],
    primarySwatch: Colors.green,
    appBarTheme: AppBarTheme(
      color: Colors.green[700],
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll<Color>(Color.fromARGB(255, 56, 142, 60)),
      ),
    ),
  ),
  AppTheme.BlueLight: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
      ),
    ),
  ),
  AppTheme.BlueDark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[700],
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      color: Colors.blue[700],
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll<Color>(Color.fromARGB(255, 12, 100, 187)),
      ),
    ),
  ),
};
