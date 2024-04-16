import 'dart:core';
import 'package:workout_frontend/api/api.dart';

class TargetResponse {
  String id;
  String name;

  TargetResponse({
    required this.id,
    required this.name,
  });

  factory TargetResponse.fromJson(Map<String, dynamic> data) {
    return TargetResponse(
      id: data["id"],
      name: data["name"],
    );
  }
}

class TargetAPI {
  static Future<Response<List<TargetResponse>>> getAllTargets() async {
    var json = await API.get("/targets");

    return Response<List<TargetResponse>>.fromJsonList(json, (elements) {
      List<TargetResponse> items = [];

      for (var element in elements) {
        items.add(TargetResponse.fromJson(element));
      }

      return items;
    });
  }
}
