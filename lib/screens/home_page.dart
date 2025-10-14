import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';
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
  List<Movie> _movies = [];
  bool _isLoading = true;
  String _error = '';
  int _currentPage = 0;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 500) { // Increased threshold
      if (!_isLoading && _hasMoreData) {
        _loadMoreMovies();
      }
    }
  }

  Future<void> _loadMovies() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final moviePageResponse = await MovieApiService.getAllMovies(
        pageNumber: 0,
        pageSize: 20,
        sortBy: 'title',
        sortDir: 'ASC',
      );

      setState(() {
        _movies = moviePageResponse.content;
        _currentPage = 0;
        _hasMoreData = !moviePageResponse.isLast;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreMovies() async {
    if (_isLoading) return; // Prevent multiple concurrent requests
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      final nextPage = _currentPage + 1;
      final moviePageResponse = await MovieApiService.getAllMovies(
        pageNumber: nextPage,
        pageSize: 20,
        sortBy: 'title',
        sortDir: 'ASC',
      );

      setState(() {
        _movies.addAll(moviePageResponse.content);
        _currentPage = nextPage;
        _hasMoreData = !moviePageResponse.isLast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading more movies: $e'),
          backgroundColor: AppTheme.destructive,
        ),
      );
    }
  }

  Future<void> _refreshMovies() async {
    await _loadMovies();
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
    final featuredMovies = _movies.take(5).toList();
    
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
                        color: AppTheme.muted,
                        child: const Icon(
                          Icons.movie,
                          size: 64,
                          color: AppTheme.mutedForeground,
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
                                  color: AppTheme.primary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  movie.year.toString(),
                                  style: const TextStyle(
                                    color: AppTheme.primary,
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
                                  color: AppTheme.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  movie.genre!,
                                  style: const TextStyle(
                                    color: AppTheme.secondary,
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
                        ? AppTheme.primary
                        : AppTheme.muted,
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
      itemCount: _movies.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _movies.length) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          );
        }

        final movie = _movies[index];
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
                      color: AppTheme.muted,
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.muted,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie,
                                size: 32,
                                color: AppTheme.mutedForeground,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'No Image',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.mutedForeground,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (movie.year != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            movie.year.toString(),
                            style: const TextStyle(
                              color: AppTheme.mutedForeground,
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
                                  color: AppTheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(
                                    color: AppTheme.primary,
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
        color: AppTheme.primary,
        child: _isLoading && _movies.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primary),
                    SizedBox(height: 16),
                    Text(
                      'Loading movies...',
                      style: TextStyle(color: AppTheme.mutedForeground),
                    ),
                  ],
                ),
              )
            : _error.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.destructive,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load movies',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error,
                          style: const TextStyle(color: AppTheme.mutedForeground),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadMovies,
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
                                            '${_movies.length} movies available',
                                            style: const TextStyle(
                                              color: AppTheme.mutedForeground,
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