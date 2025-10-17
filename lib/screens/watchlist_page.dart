import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../models/movie.dart';
import '../screens/movie_details.dart';
// import '../providers/theme_provider.dart';

class WatchlistPage extends ConsumerStatefulWidget { // Change to ConsumerStatefulWidget
  const WatchlistPage({super.key});

  @override
  ConsumerState<WatchlistPage> createState() => _WatchlistPageState(); // Change to ConsumerState
}

class _WatchlistPageState extends ConsumerState<WatchlistPage> // Change to ConsumerState
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Movie> _favorites = [
    Movie(
      id: '1',
      title: 'Quantum Nexus',
      rating: 8.7,
      image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
      genre: 'Sci-Fi',
      year: 2024,
    ),
    Movie(
      id: '2',
      title: 'Dark Memories',
      rating: 9.1,
      image: 'https://images.unsplash.com/photo-1558877025-102791db823f?w=400',
      genre: 'Thriller',
      year: 2024,
    ),
    Movie(
      id: '3',
      title: 'Love in Paris',
      rating: 8.3,
      image: 'https://images.unsplash.com/photo-1627964464837-6328f5931576?w=400',
      genre: 'Romance',
      year: 2024,
    ),
  ];

  final List<Movie> _watchLater = [
    Movie(
      id: '4',
      title: 'The Night Shift',
      rating: 8.5,
      image: 'https://images.unsplash.com/photo-1753944847480-92f369a5f00e?w=400',
      genre: 'Thriller',
      year: 2024,
    ),
    Movie(
      id: '5',
      title: 'Cosmic Journey',
      rating: 8.9,
      image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
      genre: 'Sci-Fi',
      year: 2023,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  void _removeMovie(Movie movie, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        _favorites.remove(movie);
      } else {
        _watchLater.remove(movie);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${movie.title} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              if (isFavorite) {
                _favorites.add(movie);
              } else {
                _watchLater.add(movie);
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildMovieList(List<Movie> movies, bool isFavorite) {
  // Theme can be accessed via Theme.of(context)

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite_outline : Icons.watch_later_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFavorite ? 'No favorites yet' : 'Watch later list is empty',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFavorite
                  ? 'Start adding movies to your favorites'
                  : 'Add movies you want to watch later',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => _navigateToDetails(movie),
            child: SizedBox(
              height: 140,
              child: Row(
                children: [
                  // Movie Poster
                  SizedBox(
                    width: 95,
                    child: CachedNetworkImage(
                      imageUrl: movie.image,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: Center(
                          child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
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
                                movie.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${movie.genre} · ${movie.year}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ...List.generate(5, (starIndex) {
                                    return Icon(
                                      Icons.star,
                                      size: 16,
                                      color: starIndex < (movie.rating / 2).floor()
                                          ? Theme.of(context).colorScheme.secondary
                                          : Theme.of(context).colorScheme.surfaceVariant,
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  Text(
                                    movie.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Remove Button
                          InkWell(
                            onTap: () => _removeMovie(movie, isFavorite),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  // Theme can be accessed via Theme.of(context)

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, size: 16),
                    SizedBox(width: 8),
                    Text('Favorites'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.watch_later, size: 16),
                    SizedBox(width: 8),
                    Text('Watch Later'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMovieList(_favorites, true),
              _buildMovieList(_watchLater, false),
            ],
          ),
        ),
      ],
    );
  }
}
