import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../widgets/top_app_bar.dart';
import '../screens/movie_details.dart';
import '../theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _carouselIndex = 0;

  final List<Movie> _trendingMovies = [
    Movie(
      id: '1',
      title: 'Quantum Nexus',
      rating: 8.7,
      image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
    ),
    Movie(
      id: '2',
      title: 'Dark Memories',
      rating: 9.1,
      image: 'https://images.unsplash.com/photo-1558877025-102791db823f?w=400',
    ),
    Movie(
      id: '3',
      title: 'Love in Paris',
      rating: 8.3,
      image: 'https://images.unsplash.com/photo-1627964464837-6328f5931576?w=400',
    ),
  ];

  final List<Movie> _recommendedMovies = [
    Movie(
      id: '4',
      title: 'The Night Shift',
      rating: 8.5,
      image: 'https://images.unsplash.com/photo-1753944847480-92f369a5f00e?w=400',
      genre: 'Thriller',
    ),
    Movie(
      id: '5',
      title: 'Cosmic Journey',
      rating: 8.9,
      image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
      genre: 'Sci-Fi',
    ),
  ];

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: TopAppBarWidget(
          title: 'CineMatch',
          onSearchClick: () {
            // Navigate to search
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Carousel
          SizedBox(
            height: 500,
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: _trendingMovies.length,
                  options: CarouselOptions(
                    height: 500,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    onPageChanged: (index, reason) {
                      setState(() {
                        _carouselIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final movie = _trendingMovies[index];
                    return Stack(
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
                                AppTheme.background.withOpacity(0.6),
                                AppTheme.background,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 80,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondary
                                          .withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: AppTheme.secondary,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          movie.rating.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    '2024 · Action · 2h 15m',
                                    style: TextStyle(
                                      color: AppTheme.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Watch Now'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () =>
                                        _navigateToDetails(movie),
                                    child: const Text('Info'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _trendingMovies.asMap().entries.map((entry) {
                      return Container(
                        width: entry.key == _carouselIndex ? 32 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: entry.key == _carouselIndex
                              ? AppTheme.primary
                              : AppTheme.muted,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Recommended Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended for You',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recommendedMovies.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: _recommendedMovies[index],
                        onTap: () => _navigateToDetails(
                            _recommendedMovies[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}