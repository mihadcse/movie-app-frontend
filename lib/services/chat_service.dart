import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_helper.dart';

class ChatService {
  // static const String baseUrl = "http://localhost:8080/api/chat";
  static final String baseUrl = "${ApiConfig.baseUrl}/api/chat";


  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final parts = data["response"];
      return parts[0]["text"]; // Adjust if nested
    } else {
      return "Error: ${response.body}";
    }
  }
}
