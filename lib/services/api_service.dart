import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:8080/api/v1/auth"; 
  // Example: "http://192.168.0.105:8080/api/v1/auth"

  // REGISTER
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String about,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "about": about,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to register user: ${response.body}");
    }
  }

  // LOGIN
  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token']; // JWT token
    } else {
      throw Exception("Invalid credentials");
    }
  }
}
