import 'package:flutter/material.dart';

class Movie {
  final String id;
  final String title;
  final double rating;
  final String image;
  final String? genre;
  final int? year;
  final String? duration;
  final List<String>? genres;
  final String? synopsis;
  final List<CastMember>? cast;

  Movie({
    required this.id,
    required this.title,
    required this.rating,
    required this.image,
    this.genre,
    this.year,
    this.duration,
    this.genres,
    this.synopsis,
    this.cast,
  });

  // Factory constructor for API response
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      rating: 0.0, // Default rating since API doesn't provide it
      image: '', // We'll use a placeholder since API doesn't provide images
      year: json['releaseYear'], // Updated to match Spring Boot entity
      genres: json['genres']?.toString().split(',').map((e) => e.trim()).toList() ?? [],
      genre: json['genres']?.toString().split(',').first.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'image': image,
      'genre': genre,
      'year': year,
      'duration': duration,
      'genres': genres,
      'synopsis': synopsis,
    };
  }
}

// API Response models
class MoviePageResponse {
  final List<Movie> content;
  final int totalElements;
  final int totalPages;
  final int pageNumber;
  final int pageSize;
  final bool isFirst;
  final bool isLast;

  MoviePageResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.pageNumber,
    required this.pageSize,
    required this.isFirst,
    required this.isLast,
  });

  factory MoviePageResponse.fromJson(Map<String, dynamic> json) {
    return MoviePageResponse(
      content: (json['content'] as List<dynamic>)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      isFirst: json['pageNumber'] == 0, // Calculate from pageNumber
      isLast: json['lastPage'] ?? true, // Updated to match Spring Boot response
    );
  }
}

class CastMember {
  final String name;
  final String role;
  final String image;

  CastMember({
    required this.name,
    required this.role,
    required this.image,
  });
}

class Mood {
  final String id;
  final String emoji;
  final String label;
  final List<Color> colors;

  Mood({
    required this.id,
    required this.emoji,
    required this.label,
    required this.colors,
  });
}