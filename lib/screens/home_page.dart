import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';
import '../widgets/top_app_bar.dart';
import '../screens/movie_details.dart';
import '../theme/app_theme.dart';
import '../providers/movie_provider.dart';
import '../providers/theme_provider.dart'; // Import the new theme provider

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _carouselIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 500) {
      final movieNotifier = ref.read(movieProvider.notifier);
      final movieState = ref.read(movieProvider);
      
      if (!movieState.isLoading && movieState.hasMoreData) {
        movieNotifier.loadMoreMovies();
      }
    }
  }

  Future<void> _refreshMovies() async {
    await ref.read(movieProvider.notifier).loadMovies(refresh: true);
  }

  void _navigateToDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  Widget _buildFeaturedMoviesCarousel() {
    final featuredMovies = ref.watch(featuredMoviesProvider);
    final themeModeType = ref.watch(themeProvider); // Watch the theme provider
    final isDarkMode = themeModeType == ThemeModeType.dark;
    
    if (featuredMovies.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: featuredMovies.length,
            options: CarouselOptions(
              height: 400,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6), // Slower auto-play
              enableInfiniteScroll: false, // Reduce mouse tracking issues
              pauseAutoPlayOnTouch: true, // Pause on interaction
              pauseAutoPlayInFiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _carouselIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final movie = featuredMovies[index];
              final imageUrl = MovieApiService.getMoviePosterUrl(movie);
              
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceVariant, // Use theme-specific muted color
                        child: Icon(
                          Icons.movie,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant, // Use theme-specific mutedForeground color
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).colorScheme.background.withOpacity(0.6), // Use theme-specific background color
                          Theme.of(context).colorScheme.background, // Use theme-specific background color
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
                          style: Theme.of(context).textTheme.displaySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (movie.year != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  movie.year.toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (movie.genre != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  movie.genre!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _navigateToDetails(movie),
                                child: const Text('View Details'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Icon(Icons.bookmark_outline),
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
              children: featuredMovies.asMap().entries.map((entry) {
                return Container(
                  width: entry.key == _carouselIndex ? 32 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: entry.key == _carouselIndex
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant, // Use theme-specific muted color
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid() {
    final movieState = ref.watch(movieProvider);
    final movies = movieState.movies;
    final hasMoreData = movieState.hasMoreData;
    final themeModeType = ref.watch(themeProvider); // Watch the theme provider
    final isDarkMode = themeModeType == ThemeModeType.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= movies.length) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        final movie = movies[index];
        final imageUrl = MovieApiService.getMoviePosterUrl(movie);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _navigateToDetails(movie),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant, // Use theme-specific muted color
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.surfaceVariant, // Use theme-specific muted color
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie,
                                size: 32,
                                color: Theme.of(context).colorScheme.onSurfaceVariant, // Use theme-specific mutedForeground color
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'No Image',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant, // Use theme-specific mutedForeground color
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (movie.year != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            movie.year.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant, // Use theme-specific mutedForeground color
                              fontSize: 12,
                            ),
                          ),
                        ],
                        if (movie.genres != null && movie.genres!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: movie.genres!.take(2).map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  genre,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(movieProvider);
    final movies = movieState.movies;
    final isLoading = movieState.isLoading;
    final error = movieState.error;
    final themeModeType = ref.watch(themeProvider); // Watch the theme provider
    final isDarkMode = themeModeType == ThemeModeType.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: TopAppBarWidget(
          title: 'CineMatch',
          onSearchClick: () {
            context.go('/search');
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMovies,
        color: Theme.of(context).colorScheme.primary,
        child: isLoading && movies.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Loading movies...',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant), // Use theme-specific mutedForeground color
                    ),
                  ],
                ),
              )
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load movies',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant), // Use theme-specific mutedForeground color
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.read(movieProvider.notifier).loadMovies(refresh: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            // Featured Movies Carousel
                            _buildFeaturedMoviesCarousel(),
                            
                            const SizedBox(height: 24),
                            
                            // Section Header
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'All Movies',
                                        style: Theme.of(context).textTheme.headlineMedium,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${movies.length} movies available',
                                            style: TextStyle(
                                              color: Theme.of(context).colorScheme.onSurfaceVariant, // Use theme-specific mutedForeground color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: _refreshMovies,
                                    icon: const Icon(Icons.refresh),
                                    tooltip: 'Refresh',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Movies Grid
                      SliverToBoxAdapter(
                        child: _buildMovieGrid(),
                      ),
                    ],
                  ),
      ),
    );
  }
}
