import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import 'mood_recommendations_page.dart';

class MoodDiscoveryPage extends ConsumerStatefulWidget {
  const MoodDiscoveryPage({super.key});

  @override
  ConsumerState<MoodDiscoveryPage> createState() => _MoodDiscoveryPageState();
}

class _MoodDiscoveryPageState extends ConsumerState<MoodDiscoveryPage> {

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

  @override
  Widget build(BuildContext context) {
  // Theme can be accessed via Theme.of(context)

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

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodRecommendationsPage(
                      mood: mood.id,
                      moodLabel: mood.label,
                      moodEmoji: mood.emoji,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.transparent,
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
                              color: Theme.of(context).colorScheme.onSurface,
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
      ],
    );
  }
}
