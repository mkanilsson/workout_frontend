import 'dart:core';
import 'package:workout_frontend/api/api.dart';

class LoginResponse {
  String token;
  UserResponse user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> data) {
    return LoginResponse(
        token: data["token"], user: UserResponse.fromJson(data["user"]));
  }
}

class UserResponse {
  String id;
  String email;

  DateTime createdAt;
  DateTime updatedAt;

  UserResponse(
      {required this.id,
      required this.email,
      required this.createdAt,
      required this.updatedAt});

  factory UserResponse.fromJson(Map<String, dynamic> data) {
    return UserResponse(
        id: data["id"],
        email: data["email"],
        createdAt: DateTime.parse(data["created_at"]),
        updatedAt: DateTime.parse(data["updated_at"]));
  }
}

class AuthAPI {
  static Future<Response<LoginResponse>> login(
      String email, String password) async {
    var json =
        await API.post("/auth/login", {"email": email, "password": password});
    return Response<LoginResponse>.fromJsonMap(json, LoginResponse.fromJson);
  }

  static Future<Response<UserResponse>> register(
      String email, String password) async {
    var json = await API
        .post("/auth/register", {"email": email, "password": password});
    return Response<UserResponse>.fromJsonMap(json, UserResponse.fromJson);
  }

  static Future<Response<LoginResponse>> refereshToken(String token) async {
    var json = await API.getWithAuth("/auth/refresh", token);
    return Response<LoginResponse>.fromJsonMap(json, LoginResponse.fromJson);
  }

  static Future<Response<void>> logout(String token) async {
    var json = await API.deleteWithAuth("/auth/logout", token);
    return Response<void>.fromJsonMap(json, (data) => {});
  }
}
