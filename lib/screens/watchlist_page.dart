import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../screens/movie_details.dart';
import '../theme/app_theme.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
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
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppTheme.muted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFavorite ? Icons.favorite_outline : Icons.watch_later_outlined,
                size: 48,
                color: AppTheme.mutedForeground,
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
              style: const TextStyle(
                color: AppTheme.mutedForeground,
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
            side: const BorderSide(
              color: AppTheme.mutedForeground,
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
                        color: AppTheme.muted,
                        child: const Center(
                          child: CircularProgressIndicator(),
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
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.mutedForeground,
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
                                          ? AppTheme.secondary
                                          : AppTheme.muted,
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  Text(
                                    movie.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Remove Button
                          InkWell(
                            onTap: () => _removeMovie(movie, isFavorite),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: AppTheme.destructive,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.destructive,
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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.muted,
            borderRadius: BorderRadius.circular(24),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(24),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: AppTheme.mutedForeground,
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