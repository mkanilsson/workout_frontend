import 'dart:core';
import 'package:workout_frontend/api/api.dart';

enum ExerciseType { staticExercise, distanceOverTime, weightOverAmount }

class ExerciseResponse {
  String id;
  String userId;
  String name;
  ExerciseType exerciseType;

  ExerciseResponse({
    required this.id,
    required this.userId,
    required this.name,
    required this.exerciseType,
  });

  factory ExerciseResponse.fromJson(Map<String, dynamic> data) {
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

    return ExerciseResponse(
      id: data["id"],
      userId: data["user_id"],
      name: data["name"],
      exerciseType: exerciseType,
    );
  }
}

class ExerciseAPI {
  static Future<Response<List<ExerciseResponse>>> getAllExercises(
      String token) async {
    var json = await API.getWithAuth("/exercises", token);

    return Response<List<ExerciseResponse>>.fromJsonList(json, (elements) {
      List<ExerciseResponse> items = [];

      for (var element in elements) {
        items.add(ExerciseResponse.fromJson(element));
      }

      return items;
    });
  }
}
