import 'package:flutter/material.dart';
import 'package:workout_frontend/auth_service.dart';
import 'package:workout_frontend/pages/add_exercise.dart';
import 'package:workout_frontend/pages/home.dart';
import 'package:workout_frontend/pages/login.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 72, 133, 136),
        ),
        useMaterial3: true,
      ),
      routes: <String, WidgetBuilder>{
        "/home": (BuildContext context) => const HomePage(),
        "/login": (BuildContext context) => const LoginPage(),
        "/add_exercise": (BuildContext context) => const AddExercisePage(),
      },
    ),
  );
}
