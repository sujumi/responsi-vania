import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.100.133:8000/api';
  static const storage = FlutterSecureStorage();

  static Future<Map<String, String>> getHeaders() async {
    final token = await storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await storage.write(
        key: 'access_token',
        value: data['token']['access_token'],
      );
      return data;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<void> logout() async {
    await storage.delete(key: 'access_token');
  }

  static Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<Map<String, dynamic>> createUser(
      Map<String, String> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: await getHeaders(),
      body: json.encode(user),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<Map<String, dynamic>> updateUser(
      String id, Map<String, String> user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/$id'),
      headers: await getHeaders(),
      body: json.encode(user),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  static Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/user/$id'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}
