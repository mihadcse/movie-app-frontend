import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_helper.dart';

class MoodDiscoveryService {
  static final String _base = ApiConfig.baseUrl;

  /// Get movie recommendations based on mood
  /// POST /api/mood-discovery
  static Future<MoodDiscoveryResponse> discoverByMood({
    required String mood,
    int count = 10,
  }) async {
    final url = Uri.parse('$_base/api/mood-discovery');
    
    final resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mood': mood,
        'count': count,
      }),
    );
    
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return MoodDiscoveryResponse.fromJson(data);
    }
    
    throw Exception('Failed to get mood recommendations (${resp.statusCode}): ${resp.body}');
  }

  /// Get available moods
  /// GET /api/mood-discovery/moods
  static Future<List<String>> getAvailableMoods() async {
    final url = Uri.parse('$_base/api/mood-discovery/moods');
    
    final resp = await http.get(url);
    
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final moods = data['moods'] as List<dynamic>;
      return moods.map((m) => m.toString()).toList();
    }
    
    return ['happy', 'romantic', 'thrilling', 'mysterious', 'adventurous', 'chill', 'emotional', 'inspired'];
  }
}

// Response model
class MoodDiscoveryResponse {
  final String mood;
  final List<MovieRecommendation> movies;
  final String? description;

  MoodDiscoveryResponse({
    required this.mood,
    required this.movies,
    this.description,
  });

  factory MoodDiscoveryResponse.fromJson(Map<String, dynamic> json) {
    final moviesList = json['movies'] as List<dynamic>?;
    final movies = moviesList?.map((m) => MovieRecommendation.fromJson(m as Map<String, dynamic>)).toList() ?? [];
    
    return MoodDiscoveryResponse(
      mood: json['mood']?.toString() ?? '',
      movies: movies,
      description: json['description']?.toString(),
    );
  }
}

class MovieRecommendation {
  final String title;
  final int? year;
  final String? description;
  final String? reason;
  final String? posterUrl;
  final double? rating;

  MovieRecommendation({
    required this.title,
    this.year,
    this.description,
    this.reason,
    this.posterUrl,
    this.rating,
  });

  factory MovieRecommendation.fromJson(Map<String, dynamic> json) {
    return MovieRecommendation(
      title: json['title']?.toString() ?? 'Unknown',
      year: json['year'] as int?,
      description: json['description']?.toString(),
      reason: json['reason']?.toString(),
      posterUrl: json['posterUrl']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }
}
