import 'dart:core';

import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/exercises.dart';

enum WorkoutStatus { ongoing, done }

enum SetType { warmup, normal }

class WorkoutSet {
  String id;
  String userId;
  String exerciseWorkoutId;
  double quality;
  double quantity;
  String? note;
  SetType setType;
  DateTime createdAt;
  DateTime updatedAt;

  WorkoutSet({
    required this.id,
    required this.userId,
    required this.exerciseWorkoutId,
    required this.quality,
    required this.quantity,
    required this.note,
    required this.setType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> data) {
    var setType =
        data["set_type"] == "warmup" ? SetType.warmup : SetType.normal;

    return WorkoutSet(
      id: data["id"],
      userId: data["user_id"],
      exerciseWorkoutId: data["exercise_workout_id"],
      quality: data["quality"],
      quantity: data["quantity"],
      note: data["note"],
      setType: setType,
      createdAt: DateTime.parse(data["created_at"]),
      updatedAt: DateTime.parse(data["updated_at"]),
    );
  }
}

class DetailedExercise {
  String id;
  String name;
  ExerciseType exerciseType;
  DateTime createdAt;
  DateTime updatedAt;
  List<WorkoutSet> sets;

  DetailedExercise({
    required this.id,
    required this.name,
    required this.exerciseType,
    required this.createdAt,
    required this.updatedAt,
    required this.sets,
  });

  factory DetailedExercise.fromJson(Map<String, dynamic> data) {
    // TODO: Move to seperate function
    var exerciseType = ExerciseType.staticExercise;

    switch (data["exercise_type"]) {
      case "static":
        exerciseType = ExerciseType.staticExercise;
        break;
      case "WeightOverAmount":
        exerciseType = ExerciseType.weightOverAmount;
        break;
      case "DistanceOverTime":
        exerciseType = ExerciseType.distanceOverTime;
        break;
      default:
    }

    List<WorkoutSet> sets = [];

    for (var set in data["sets"]) {
      sets.add(WorkoutSet.fromJson(set));
    }

    return DetailedExercise(
      id: data["id"],
      name: data["name"],
      exerciseType: exerciseType,
      createdAt: DateTime.parse(data["created_at"]),
      updatedAt: DateTime.parse(data["updated_at"]),
      sets: sets,
    );
  }

  String get setDescription {
    var warmup =
        sets.where((element) => element.setType == SetType.warmup).length;
    var normal =
        sets.where((element) => element.setType == SetType.normal).length;
    return "${sets.length} set${sets.length != 1 ? 's' : ''}, $warmup warmup and $normal normal";
  }
}

class Workout {
  String id;
  String userId;
  WorkoutStatus status;
  DateTime createdAt;
  DateTime updatedAt;

  Workout({
    required this.id,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workout.fromJson(Map<String, dynamic> data) {
    var status = data["status"] == "ongoing"
        ? WorkoutStatus.ongoing
        : WorkoutStatus.done;

    return Workout(
      id: data["id"],
      userId: data["user_id"],
      status: status,
      createdAt: DateTime.parse(data["created_at"]),
      updatedAt: DateTime.parse(data["updated_at"]),
    );
  }
}

class DetailedWorkout {
  String id;
  WorkoutStatus status;
  DateTime createdAt;
  DateTime updatedAt;
  List<DetailedExercise> exercises;

  DetailedWorkout({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.exercises,
  });

  factory DetailedWorkout.fromJson(Map<String, dynamic> data) {
    var status = data["status"] == "ongoing"
        ? WorkoutStatus.ongoing
        : WorkoutStatus.done;

    List<DetailedExercise> exercises = [];

    for (var exercise in data["exercises"]) {
      exercises.add(DetailedExercise.fromJson(exercise));
    }

    return DetailedWorkout(
      id: data["id"],
      status: status,
      exercises: exercises,
      createdAt: DateTime.parse(data["created_at"]),
      updatedAt: DateTime.parse(data["updated_at"]),
    );
  }
}

class WorkoutAPI {
  static Future<Response<DetailedWorkout>> current(String token) async {
    var json = await API.getWithAuth("/workouts/current", token);

    return Response<DetailedWorkout>.fromJsonMap(
      json,
      DetailedWorkout.fromJson,
    );
  }

  static Future<Response<Workout>> startWorkout(String token) async {
    var json = await API.postWithAuth("/workouts", token, {});

    return Response<Workout>.fromJsonMap(
      json,
      Workout.fromJson,
    );
  }
}
