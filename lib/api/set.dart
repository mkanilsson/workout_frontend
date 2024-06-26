import 'package:workout_frontend/api/api.dart';

enum SetType { warmup, normal }

extension SetTypExtension on SetType {
  String get value {
    switch (this) {
      case SetType.warmup:
        return "Warmup";
      case SetType.normal:
        return "Normal";
      default:
        return "WTF";
    }
  }
}

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
        data["set_type"] == "Warmup" ? SetType.warmup : SetType.normal;

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

  int get hours {
    return (quantity / 3600).floor();
  }

  int get minutes {
    return ((quantity - (hours * 3600)) / 60).floor();
  }

  double get seconds {
    return quantity - (hours * 3600) - (minutes * 60);
  }
}

extension DoubleExtension on double {
  String beautifulToString() {
    var value = toString();
    if (value.endsWith(".0")) return value.replaceAll(".0", "");
    return value;
  }
}

extension DateTimeExtension on DateTime {
  String beautifulToString() {
    return "$day/$month/$year";
  }
}

class SetAPI {
  static Future<Response<WorkoutSet>> delete(String token, String id) async {
    var json = await API.deleteWithAuth("/sets/$id", token);

    return Response<WorkoutSet>.fromJsonMap(
      json,
      WorkoutSet.fromJson,
    );
  }

  static Future<Response<WorkoutSet>> create(
    String token,
    String exerciseWorkoutId,
    SetType setType,
  ) async {
    var json = await API.postWithAuth(
      "/sets",
      token,
      {
        "exercise_workout_id": exerciseWorkoutId,
        "quality": 0,
        "quantity": 0,
        "set_type": setType.value,
      },
    );

    return Response<WorkoutSet>.fromJsonMap(
      json,
      WorkoutSet.fromJson,
    );
  }

  static Future<Response<WorkoutSet>> update(
    String token,
    String setId,
    double newQuality,
    double newQuantity,
    SetType newSetType,
  ) async {
    var json = await API.putWithAuth(
      "/sets/$setId",
      token,
      {
        "quality": newQuality,
        "quantity": newQuantity,
        "set_type": newSetType.value
      },
    );

    return Response<WorkoutSet>.fromJsonMap(
      json,
      WorkoutSet.fromJson,
    );
  }
}
