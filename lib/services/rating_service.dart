import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_helper.dart';

class RatingService {
  static final String _base = ApiConfig.baseUrl;

  /// Rate a movie (creates or updates rating)
  /// POST /api/ratings/{userId}/{movieId}/{score}
  static Future<Map<String, dynamic>> rateMovie({
    required String token,
    required String userId,
    required String movieId,
    required double score,
  }) async {
    // Validate score range
    if (score < 0.5 || score > 5.0) {
      throw Exception('Score must be between 0.5 and 5.0');
    }
    
    final url = Uri.parse('$_base/api/ratings/$userId/$movieId/$score');
    
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Rating failed (${resp.statusCode}): ${resp.body}');
  }
  
  /// Get current user's ratings
  /// GET /api/ratings/my-ratings
  static Future<List<Map<String, dynamic>>> myRatings({
    required String token,
  }) async {
    final url = Uri.parse('$_base/api/ratings/my-ratings');
    
    final resp = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      }
      return const [];
    }
    throw Exception('Failed to load ratings (${resp.statusCode}): ${resp.body}');
  }
}