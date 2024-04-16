import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color.fromARGB(255, 72, 133, 136);
const COLOR_SECONDARY = Color.fromARGB(255, 177, 98, 134);
const COLOR_ERROR = Color.fromARGB(255, 204, 36, 29);
const COLOR_SUCCESS = Color.fromARGB(255, 152, 151, 26);
const COLOR_ORANGE = Color.fromARGB(255, 214, 93, 14);
const COLOR_FORGROUND = Color.fromARGB(255, 235, 219, 178);
const COLOR_FORGROUND_ALT = Color.fromARGB(255, 168, 153, 132);
const COLOR_BACKGROUND = Color.fromARGB(255, 40, 40, 40);
const COLOR_BACKGROUND_DARKER = Color.fromARGB(255, 29, 32, 33);

ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: COLOR_PRIMARY,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    background: COLOR_BACKGROUND,
    onBackground: COLOR_FORGROUND,
    primary: COLOR_PRIMARY,
    onPrimary: COLOR_FORGROUND,
    secondary: COLOR_SECONDARY,
    onSecondary: COLOR_FORGROUND,
    error: COLOR_ERROR,
    onError: COLOR_FORGROUND,
    surface: COLOR_BACKGROUND_DARKER,
    onSurface: COLOR_FORGROUND,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: COLOR_PRIMARY,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(COLOR_FORGROUND),
      backgroundColor: WidgetStateProperty.all(COLOR_PRIMARY),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
        ),
      ),
    ),
  ),
  tabBarTheme: const TabBarTheme(labelColor: COLOR_PRIMARY),
  listTileTheme: const ListTileThemeData(
    tileColor: COLOR_BACKGROUND_DARKER,
    subtitleTextStyle: TextStyle(color: COLOR_FORGROUND_ALT),
  ),
  cardTheme: const CardTheme(
    margin: EdgeInsets.all(0),
    color: COLOR_BACKGROUND_DARKER,
    clipBehavior: Clip.none,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  iconTheme: const IconThemeData(
    color: COLOR_FORGROUND,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(COLOR_FORGROUND),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
      color: COLOR_FORGROUND_ALT,
    ),
  ),
  chipTheme: const ChipThemeData(
    selectedColor: COLOR_PRIMARY,
  ),
);
