import 'package:flutter/material.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/pages/add_exercise.dart';
import 'package:workout_frontend/pages/home.dart';
import 'package:workout_frontend/pages/login.dart';
import 'package:workout_frontend/pages/register.dart';
import 'package:workout_frontend/pages/user.dart';
import 'package:workout_frontend/pages/workout_add_exercise.dart';

MaterialPageRoute home() {
  return MaterialPageRoute(
    builder: (builder) => const HomePage(),
  );
}

MaterialPageRoute login() {
  return MaterialPageRoute(
    builder: (builder) => const LoginPage(),
  );
}

MaterialPageRoute register() {
  return MaterialPageRoute(
    builder: (builder) => const RegisterPage(),
  );
}

MaterialPageRoute user() {
  return MaterialPageRoute(
    builder: (builder) => const UserPage(),
  );
}

MaterialPageRoute addExercise() {
  return MaterialPageRoute(
    builder: (builder) => const AddExercisePage(),
  );
}

MaterialPageRoute workoutAddExercise() {
  return MaterialPageRoute(
    builder: (builder) => const WorkoutAddExercisePage(),
  );
}

MaterialPageRoute editExercise(ExerciseResponse exercise) {
  return MaterialPageRoute(
    builder: (builder) => AddExercisePage(
      exercise: exercise,
    ),
  );
}
