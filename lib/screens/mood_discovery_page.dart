import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../screens/movie_details.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart'; // Import the new theme provider

class MoodDiscoveryPage extends ConsumerStatefulWidget { // Change to ConsumerStatefulWidget
  const MoodDiscoveryPage({super.key});

  @override
  ConsumerState<MoodDiscoveryPage> createState() => _MoodDiscoveryPageState(); // Change to ConsumerState
}

class _MoodDiscoveryPageState extends ConsumerState<MoodDiscoveryPage> { // Change to ConsumerState
  String? _selectedMood;

  final List<Mood> _moods = [
    Mood(
      id: 'happy',
      emoji: '😊',
      label: 'Happy',
      colors: [const Color(0xFFFBB03B), const Color(0xFFFF9800)],
    ),
    Mood(
      id: 'romantic',
      emoji: '💕',
      label: 'Romantic',
      colors: [const Color(0xFFEC407A), const Color(0xFFF06292)],
    ),
    Mood(
      id: 'thrilling',
      emoji: '😱',
      label: 'Thrilling',
      colors: [const Color(0xFFEF5350), const Color(0xFF9C27B0)],
    ),
    Mood(
      id: 'mysterious',
      emoji: '🤔',
      label: 'Mysterious',
      colors: [const Color(0xFF5C6BC0), const Color(0xFF42A5F5)],
    ),
    Mood(
      id: 'adventurous',
      emoji: '🚀',
      label: 'Adventurous',
      colors: [const Color(0xFF26C6DA), const Color(0xFF26A69A)],
    ),
    Mood(
      id: 'chill',
      emoji: '😌',
      label: 'Chill',
      colors: [const Color(0xFF66BB6A), const Color(0xFF26A69A)],
    ),
    Mood(
      id: 'emotional',
      emoji: '😢',
      label: 'Emotional',
      colors: [const Color(0xFF42A5F5), const Color(0xFF5C6BC0)],
    ),
    Mood(
      id: 'inspired',
      emoji: '✨',
      label: 'Inspired',
      colors: [const Color(0xFF9C27B0), const Color(0xFFEC407A)],
    ),
  ];

  final Map<String, List<Movie>> _moodMovies = {
    'happy': [
      Movie(
        id: '1',
        title: 'Comedy Central',
        rating: 7.8,
        image: 'https://images.unsplash.com/photo-1758525862263-af89b090fb56?w=400',
        genre: 'Comedy',
      ),
      Movie(
        id: '2',
        title: 'Laugh Out Loud',
        rating: 7.6,
        image: 'https://images.unsplash.com/photo-1758525862263-af89b090fb56?w=400',
        genre: 'Comedy',
      ),
    ],
    'romantic': [
      Movie(
        id: '3',
        title: 'Love in Paris',
        rating: 8.3,
        image: 'https://images.unsplash.com/photo-1627964464837-6328f5931576?w=400',
        genre: 'Romance',
      ),
      Movie(
        id: '4',
        title: 'Eternal Love',
        rating: 8.2,
        image: 'https://images.unsplash.com/photo-1627964464837-6328f5931576?w=400',
        genre: 'Romance',
      ),
    ],
    'thrilling': [
      Movie(
        id: '5',
        title: 'Dark Memories',
        rating: 9.1,
        image: 'https://images.unsplash.com/photo-1558877025-102791db823f?w=400',
        genre: 'Thriller',
      ),
      Movie(
        id: '6',
        title: 'The Night Shift',
        rating: 8.5,
        image: 'https://images.unsplash.com/photo-1753944847480-92f369a5f00e?w=400',
        genre: 'Thriller',
      ),
    ],
    'adventurous': [
      Movie(
        id: '7',
        title: 'Quantum Nexus',
        rating: 8.7,
        image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
        genre: 'Sci-Fi',
      ),
      Movie(
        id: '8',
        title: 'Cosmic Journey',
        rating: 8.9,
        image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
        genre: 'Sci-Fi',
      ),
    ],
  };

  List<Movie> get _currentMovies {
    if (_selectedMood == null) return [];
    return _moodMovies[_selectedMood] ?? [];
  }

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModeType = ref.watch(themeProvider); // Watch the theme provider
    final isDarkMode = themeModeType == ThemeModeType.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Mood Discovery',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your mood and discover the perfect movie for you',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Mood Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: _moods.length,
          itemBuilder: (context, index) {
            final mood = _moods[index];
            final isSelected = _selectedMood == mood.id;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedMood = mood.id;
                });
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: mood.colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Movie Recommendations
        if (_selectedMood != null && _currentMovies.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              children: [
                const TextSpan(text: 'Perfect for your '),
                TextSpan(
                  text: _moods
                      .firstWhere((m) => m.id == _selectedMood)
                      .label,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const TextSpan(text: ' mood'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: _currentMovies.length,
            itemBuilder: (context, index) {
              return MovieCard(
                movie: _currentMovies[index],
                width: double.infinity,
                onTap: () => _navigateToDetails(_currentMovies[index]),
              );
            },
          ),
        ] else if (_selectedMood == null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Select a mood above to discover movies that match your vibe',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
