import 'dart:core';
import 'package:workout_frontend/api/api.dart';

enum ExerciseType { staticExercise, distanceOverTime, weightOverAmount }

extension ExerciseTypeExtension on ExerciseType {
  String get description {
    switch (this) {
      case ExerciseType.staticExercise:
        return "Weight and Time";
      case ExerciseType.distanceOverTime:
        return "Distance and Time";
      case ExerciseType.weightOverAmount:
        return "Weight and Reps";
      default:
    }

    return "WTF";
  }

  String get value {
    switch (this) {
      case ExerciseType.staticExercise:
        return "Static";
      case ExerciseType.distanceOverTime:
        return "DistanceOverTime";
      case ExerciseType.weightOverAmount:
        return "WeightOverAmount";
      default:
    }

    return "WTF";
  }

  String get quantityUnit {
    switch (this) {
      case ExerciseType.staticExercise:
        return "kg";
      case ExerciseType.distanceOverTime:
        return "km";
      case ExerciseType.weightOverAmount:
        return "kg";
      default:
    }

    return "WTF";
  }

  String get qualityUnit {
    switch (this) {
      case ExerciseType.staticExercise:
        return "seconds";
      case ExerciseType.distanceOverTime:
        return "seconds";
      case ExerciseType.weightOverAmount:
        return "reps";
      default:
    }

    return "WTF";
  }
}

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

  static Future<Response<ExerciseResponse>> create(
      String token, String name, ExerciseType exerciseType) async {
    var json = await API.postWithAuth(
      "/exercises",
      token,
      {"name": name, "exercise_type": exerciseType.value},
    );

    return Response<ExerciseResponse>.fromJsonMap(
        json, ExerciseResponse.fromJson);
  }
}
