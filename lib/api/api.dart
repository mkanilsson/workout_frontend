import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workout_frontend/constants.dart';

enum ResponseStatus { success, failure }

class Response<T> {
  final ResponseStatus status;
  final String message;
  final T? data;

  Response({required this.status, required this.message, required this.data});

  factory Response.fromJsonMap(Map<String, dynamic> data,
      T Function(Map<String, dynamic> data) dataParser) {
    final status = data["status"] == "Success"
        ? ResponseStatus.success
        : ResponseStatus.failure;

    final message = data["message"];
    T? responseData;
    // FIXME: Ugly hack
    if (status == ResponseStatus.success && message != "logged out") {
      responseData = dataParser(data["data"]);
    }

    return Response(status: status, message: message, data: responseData);
  }

  factory Response.fromJsonList(
      Map<String, dynamic> data, T Function(List<dynamic> data) dataParser) {
    final status = data["status"] == "Success"
        ? ResponseStatus.success
        : ResponseStatus.failure;

    final message = data["message"];
    T? responseData;
    if (status == ResponseStatus.success) {
      responseData = dataParser(data["data"]);
    }

    return Response(status: status, message: message, data: responseData);
  }
}

class API {
  static Future<Map<String, dynamic>> get(String endpoint) async {
    var response = await http.get(
      Uri.parse("$baseURL/api$endpoint"),
    );

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, dynamic body) async {
    var response = await http.post(
      Uri.parse("$baseURL/api$endpoint"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> postWithAuth(
      String endpoint, String token, dynamic body) async {
    var response = await http.post(
      Uri.parse("$baseURL/api$endpoint"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json", "Authorization": token},
    );
    var decoded = utf8.decode(response.bodyBytes);
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> putWithAuth(
      String endpoint, String token, dynamic body) async {
    var response = await http.put(
      Uri.parse("$baseURL/api$endpoint"),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json", "Authorization": token},
    );
    var decoded = utf8.decode(response.bodyBytes);
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getWithAuth(
      String endpoint, String token) async {
    var response = await http.get(
      Uri.parse("$baseURL/api$endpoint"),
      headers: {"Authorization": token},
    );
    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> deleteWithAuth(
      String endpoint, String token) async {
    var response = await http.delete(
      Uri.parse("$baseURL/api$endpoint"),
      headers: {"Authorization": token},
    );
    var decoded = utf8.decode(response.bodyBytes);
    return jsonDecode(decoded) as Map<String, dynamic>;
  }
}
