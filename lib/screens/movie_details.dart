import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../providers/auth_provider.dart';
import '../services/rating_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/save_to_selection_sheet.dart'; // Import the new widget

class MovieDetailsPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    movie.image,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).colorScheme.background.withOpacity(0.6),
                          Theme.of(context).colorScheme.background,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(movie.rating.toString()),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '2024',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '2h 15m',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: ['Sci-Fi', 'Action', 'Adventure']
                        .map(
                          (genre) => Chip(
                            label: Text(genre),
                            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Watch Trailer'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final selectedOption = await showModalBottomSheet<String?>(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              builder: (ctx) => const SaveToSelectionSheet(),
                            );
                            // TODO: Handle selectedOption (favorites or watch_later) when functionality is requested
                            if (selectedOption != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected: $selectedOption'),
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Watchlist'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: auth.isAuthenticated ? () {
                            _showRateBottomSheet(context, ref, movie);
                          } : null,
                          icon: const Icon(Icons.star_outline),
                          label: Text(auth.isAuthenticated ? 'Rate' : 'Login to rate'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Synopsis',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'In a world where quantum technology has opened portals to parallel universes, a team of elite explorers must navigate through dangerous dimensions to prevent a catastrophic collapse of reality itself.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

void _showRateBottomSheet(BuildContext context, WidgetRef ref, Movie movie) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _RateMovieSheet(movie: movie),
  );
}

class _RateMovieSheet extends ConsumerStatefulWidget {
  final Movie movie;
  
  const _RateMovieSheet({required this.movie});

  @override
  ConsumerState<_RateMovieSheet> createState() => _RateMovieSheetState();
}

class _RateMovieSheetState extends ConsumerState<_RateMovieSheet> {
  double _current = 3.0;
  bool _busy = false;

  Future<void> _submit() async {
    final auth = ref.read(authProvider);
    final token = auth.token;
    final user = auth.user;

    if (token == null || user == null) {
      if (!mounted) return;
      Navigator.pop(context);
      return;
    }
    
    setState(() => _busy = true);
    
    try {
      await RatingService.rateMovie(
        token: token,
        userId: user.id.toString(),
        movieId: widget.movie.id.toString(),
        score: _current,
      );
      
      if (!mounted) return;
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thanks for your rating!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not submit rating: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Rate this movie', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Select a score between 0.5 and 5.0', style: TextStyle(color: cs.onSurfaceVariant)),
          const SizedBox(height: 16),
          _Stars(
            value: _current,
            onChanged: _busy ? null : (v) => setState(() => _current = v),
          ),
          const SizedBox(height: 12),
          Text('${_current.toStringAsFixed(1)} / 5.0'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _busy ? null : _submit,
              icon: _busy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send),
              label: Text(_busy ? 'Submitting…' : 'Submit'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double value; // 0.5 .. 5.0, step 0.5
  final ValueChanged<double>? onChanged;
  const _Stars({required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 6,
      children: List.generate(5, (i) {
        final index = i + 1; // star 1..5
        final filled = value >= index;
        final half = !filled && value >= index - 0.5;
        return GestureDetector(
          onTap: onChanged == null ? null : () => onChanged!(index.toDouble()),
          onLongPress: onChanged == null ? null : () => onChanged!(index - 0.5),
          child: Icon(
            half ? Icons.star_half_rounded : (filled ? Icons.star_rounded : Icons.star_border_rounded),
            color: cs.secondary,
            size: 32,
          ),
        );
      }),
    );
  }
}
