import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieApiService {
  // Replace with your actual backend URL
  static const String baseUrl = 'http://localhost:8080/api/movies';
  
  static Future<MoviePageResponse> getAllMovies({
    int pageNumber = 0,
    int pageSize = 10,
    String sortBy = 'title',
    String sortDir = 'ASC',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/').replace(queryParameters: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'sortBy': sortBy,
        'sortDir': sortDir,
      });

      print('🔗 Making API request to: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ Successfully fetched ${jsonData['content']?.length ?? 0} movies from API');
        return MoviePageResponse.fromJson(jsonData);
      } else if (response.statusCode == 500) {
        print('❌ API Error: ${response.statusCode} - Server Error');
        throw ApiException('Server is experiencing issues. Please try again later.', response.statusCode);
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw ApiException('Failed to load movies: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      print('🚨 API Exception: $e');
      throw Exception('Error fetching movies: $e');
    }
  }

  static Future<Movie> getMovieById(String movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$movieId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Movie.fromJson(jsonData);
      } else {
        throw ApiException('Failed to load movie: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      throw Exception('Error fetching movie: $e');
    }
  }

  // Search movies by title
  static Future<List<Movie>> searchMoviesByTitle(String keywords) async {
    try {
      if (keywords.trim().isEmpty) {
        return [];
      }

      final uri = Uri.parse('$baseUrl/search/${Uri.encodeComponent(keywords)}');
      
      print('🔍 Searching movies with keywords: $keywords');
      print('🔗 Search API request to: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 Search API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<Movie> movies = jsonData.map((movieJson) => Movie.fromJson(movieJson)).toList();
        print('✅ Successfully found ${movies.length} movies matching "$keywords"');
        return movies;
      } else {
        print('❌ Search API Error: ${response.statusCode} - ${response.body}');
        throw ApiException('Failed to search movies: ${response.statusCode}', response.statusCode);
      }
    } catch (e) {
      print('🚨 Search API Exception: $e');
      throw Exception('Error searching movies: $e');
    }
  }

  // Method to generate movie poster URL
  static String getMoviePosterUrl(Movie movie) {
    if (movie.posterUrl != null && movie.posterUrl!.isNotEmpty) {
      return movie.posterUrl!;
    }

    final genre = movie.genre?.toLowerCase() ?? 'drama';
    
    // Using working placeholder images based on genre
    switch (genre) {
      case 'comedy':
        return 'https://via.placeholder.com/400x600/FFD700/000000?text=Comedy';
      case 'romance':
        return 'https://via.placeholder.com/400x600/FF69B4/FFFFFF?text=Romance';
      case 'action':
        return 'https://via.placeholder.com/400x600/FF4500/FFFFFF?text=Action';
      case 'thriller':
        return 'https://via.placeholder.com/400x600/8B0000/FFFFFF?text=Thriller';
      case 'sci-fi':
      case 'science fiction':
        return 'https://via.placeholder.com/400x600/4169E1/FFFFFF?text=Sci-Fi';
      case 'horror':
        return 'https://via.placeholder.com/400x600/800080/FFFFFF?text=Horror';
      case 'drama':
        return 'https://via.placeholder.com/400x600/2E8B57/FFFFFF?text=Drama';
      case 'crime':
        return 'https://via.placeholder.com/400x600/696969/FFFFFF?text=Crime';
      default:
        return 'https://via.placeholder.com/400x600/708090/FFFFFF?text=Movie';
    }
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
