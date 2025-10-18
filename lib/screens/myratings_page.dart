import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../services/rating_service.dart';
import '../models/movie.dart';
import 'movie_details.dart';

class MyRatingsPage extends ConsumerStatefulWidget {
  const MyRatingsPage({super.key});

  @override
  ConsumerState<MyRatingsPage> createState() => _MyRatingsPageState();
}

class _MyRatingsPageState extends ConsumerState<MyRatingsPage> {
  List<RatingItem> _ratings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    final auth = ref.read(authProvider);
    final token = auth.token;

    if (token == null) {
      setState(() {
        _isLoading = false;
        _error = 'Not authenticated';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await RatingService.myRatings(token: token);
      final ratings = data.map((json) => RatingItem.fromJson(json)).toList();
      
      if (mounted) {
        setState(() {
          _ratings = ratings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToMovie(RatingItem rating) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(
          movie: Movie(
            id: rating.movieId,
            title: rating.movieTitle,
            rating: rating.score,
            image: rating.moviePosterUrl ?? '',
            posterUrl: rating.moviePosterUrl,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final cs = Theme.of(context).colorScheme;

    if (!auth.isAuthenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login,
              size: 64,
              color: cs.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Please login to view your ratings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: const Text('My Ratings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRatings,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: cs.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Loading your ratings...',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: cs.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load ratings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _error!,
                          style: TextStyle(color: cs.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadRatings,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _ratings.isEmpty
                  ? _buildEmptyState(cs)
                  : RefreshIndicator(
                      onRefresh: _loadRatings,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _ratings.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final rating = _ratings[index];
                          return _buildRatingCard(rating, cs);
                        },
                      ),
                    ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: cs.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_outline,
              size: 48,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No ratings yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start rating movies to see them here',
              style: TextStyle(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Browse Movies'),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(RatingItem rating, ColorScheme cs) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _navigateToMovie(rating),
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              // Movie Poster
              SizedBox(
                width: 95,
                child: rating.moviePosterUrl != null && rating.moviePosterUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: rating.moviePosterUrl!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        placeholder: (context, url) => Container(
                          color: cs.surfaceVariant,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: cs.surfaceVariant,
                          child: Icon(
                            Icons.movie,
                            size: 32,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        color: cs.surfaceVariant,
                        child: Icon(
                          Icons.movie,
                          size: 32,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
              ),
              
              // Movie Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rating.movieTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          
                          // Your Rating
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [cs.primary, cs.secondary],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: cs.onPrimary,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Your rating: ${rating.score.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    color: cs.onPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // ID info (optional - can remove in production)
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Rating ID: ${rating.ratingId}',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Arrow indicator
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.chevron_right,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Model for rating items
class RatingItem {
  final String ratingId;
  final double score;
  final String movieId;
  final String movieTitle;
  final String? moviePosterUrl;
  final String userId;
  final String userName;

  RatingItem({
    required this.ratingId,
    required this.score,
    required this.movieId,
    required this.movieTitle,
    this.moviePosterUrl,
    required this.userId,
    required this.userName,
  });

  factory RatingItem.fromJson(Map<String, dynamic> json) {
    final movie = json['movie'] as Map<String, dynamic>?;
    final user = json['user'] as Map<String, dynamic>?;

    return RatingItem(
      ratingId: json['id']?.toString() ?? '0',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      movieId: movie?['id']?.toString() ?? '0',
      movieTitle: movie?['title']?.toString() ?? 'Unknown Movie',
      moviePosterUrl: movie?['posterUrl']?.toString(),
      userId: user?['id']?.toString() ?? '0',
      userName: user?['name']?.toString() ?? 'Unknown User',
    );
  }
}
