import 'package:flutter/material.dart';
import 'package:workout_frontend/api/exercises.dart';
import 'package:workout_frontend/pages/add_exercise.dart';

MaterialPageRoute editExercise(ExerciseResponse exercise) {
  return MaterialPageRoute(
    builder: (builder) => AddExercisePage(
      exercise: exercise,
    ),
  );
}
