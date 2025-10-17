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

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    try {
      final data = jsonDecode(response.body);
      // Try common shapes: {response: "text"} or {response: [{text: "..."}]} or just {text: "..."}
      if (data is Map<String, dynamic>) {
        if (data.containsKey('response')) {
          final resp = data['response'];
          if (resp is String) return resp;
          if (resp is List && resp.isNotEmpty) {
            final first = resp.first;
            if (first is Map && first['text'] is String) return first['text'] as String;
          }
        }
        if (data['text'] is String) return data['text'] as String;
        if (data['message'] is String) return data['message'] as String;
      }
      // Fallback to raw body if structure unexpected
      return response.body.toString();
    } catch (e) {
      // If decoding fails, return raw text
      return response.body.toString();
    }
  }
}
