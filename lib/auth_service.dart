import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout_frontend/api/api.dart';
import 'package:workout_frontend/api/auth.dart';

class AuthService {
  static UserResponse? user;
  static String? token;

  static Future<bool> login(String email, String password) async {
    final response = await AuthAPI.login(email, password);
    if (response.status == ResponseStatus.failure) return false;

    user = response.data!.user;
    token = response.data!.token;

    await save(user!, token!);

    return true;
  }

  static Future<bool> logout() async {
    await AuthAPI.logout(token!);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("token");

    user = null;
    token = null;

    return true;
  }

  static save(UserResponse user, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("token", token);
  }

  static Future<bool> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var foundToken = prefs.getString("token");

    if (foundToken == null) return false;

    token = foundToken;
    return true;
  }

  static Future<bool> refresh() async {
    final response = await AuthAPI.refereshToken(token!);
    if (response.status == ResponseStatus.failure) return false;

    user = response.data!.user;
    token = response.data!.token;

    await save(user!, token!);

    return true;
  }

  static Future<bool> loadAndRefresh() async {
    var loaded = await load();
    if (loaded == false) return false;

    return await refresh();
  }
}
