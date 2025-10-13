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