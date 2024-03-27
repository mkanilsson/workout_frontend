import 'package:flutter/material.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/pages/add_exercise.dart';
import 'package:workout_frontend/pages/home.dart';
import 'package:workout_frontend/pages/login.dart';
import 'package:workout_frontend/theme.dart';

void main() async {
  Widget defaultPage = const LoginPage();
  var loggedIn = await AuthService.loadAndRefresh();

  if (loggedIn) {
    defaultPage = const HomePage();
  }

  runApp(
    MaterialApp(
      title: "Workout",
      home: defaultPage,
      theme: theme,
      darkTheme: theme,
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => const HomePage(),
        "/login": (BuildContext context) => const LoginPage(),
        "/add_exercise": (BuildContext context) => const AddExercisePage(),
      },
    ),
  );
}
