import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color.fromARGB(255, 72, 133, 136);
const COLOR_SECONDARY = Color.fromARGB(255, 177, 98, 134);
const COLOR_ERROR = Color.fromARGB(255, 204, 36, 29);
const COLOR_ORANGE = Color.fromARGB(255, 214, 93, 14);
const COLOR_FORGROUND = Color.fromARGB(255, 235, 219, 178);
const COLOR_FORGROUND_ALT = Color.fromARGB(255, 168, 153, 132);
const COLOR_BACKGROUND = Color.fromARGB(255, 40, 40, 40);
const COLOR_BACKGROUND_DARKER = Color.fromARGB(255, 29, 32, 33);

ThemeData theme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: COLOR_PRIMARY,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    background: COLOR_BACKGROUND,
    onBackground: COLOR_FORGROUND,
    primary: COLOR_PRIMARY,
    onPrimary: COLOR_FORGROUND,
    secondary: COLOR_SECONDARY,
    onSecondary: COLOR_FORGROUND,
    error: COLOR_ERROR,
    onError: COLOR_FORGROUND,
    surface: COLOR_ORANGE,
    onSurface: COLOR_FORGROUND,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: COLOR_PRIMARY,
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(COLOR_FORGROUND),
      backgroundColor: MaterialStateProperty.all(COLOR_PRIMARY),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),
      textStyle: MaterialStateProperty.all(
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
);
