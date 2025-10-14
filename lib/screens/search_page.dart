import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';
import '../theme/app_theme.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  String _selectedGenre = 'all';
  List<Movie> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String _error = '';

  final List<String> _genres = [
    'All',
    'Action',
    'Romance',
    'Thriller',
    'Comedy',
    'Sci-Fi',
    'Drama',
    'Horror',
    'Crime',
  ];

  @override
  void initState() {
    super.initState();
    // Add debouncing to search as user types
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Debounce search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text.length >= 2) {
        _performSearch(_searchController.text);
      } else if (_searchController.text.isEmpty) {
        setState(() {
          _searchResults = [];
          _hasSearched = false;
          _error = '';
        });
      }
    });
  }

  Future<void> _performSearch(String keywords) async {
    if (keywords.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _error = '';
    });

    try {
      final results = await MovieApiService.searchMoviesByTitle(keywords);
      setState(() {
        _searchResults = results;
        _hasSearched = true;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isSearching = false;
        _hasSearched = true;
      });
    }
  }

  List<Movie> get _filteredMovies {
    List<Movie> movies = _searchResults;
    
    // Apply genre filter if not 'all'
    if (_selectedGenre != 'all') {
      movies = movies.where((movie) {
        return movie.genre?.toLowerCase() == _selectedGenre ||
               (movie.genres?.any((g) => g.toLowerCase() == _selectedGenre) ?? false);
      }).toList();
    }
    
    return movies;
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primary),
            SizedBox(height: 16),
            Text(
              'Searching movies...',
              style: TextStyle(color: AppTheme.mutedForeground),
            ),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.destructive,
            ),
            const SizedBox(height: 16),
            const Text(
              'Search Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error,
              style: const TextStyle(color: AppTheme.mutedForeground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _performSearch(_searchController.text),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
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
              child: const Icon(
                Icons.search,
                size: 48,
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Search for movies',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter at least 2 characters to start searching',
              style: TextStyle(
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredMovies.isEmpty) {
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
              child: const Icon(
                Icons.search_off,
                size: 48,
                color: AppTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No movies found for "${_searchController.text}"',
              style: const TextStyle(
                color: AppTheme.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredMovies.length,
      itemBuilder: (context, index) {
        final movie = _filteredMovies[index];
        final imageUrl = MovieApiService.getMoviePosterUrl(movie);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Navigate to movie details
              Navigator.pushNamed(
                context,
                '/movie-details',
                arguments: movie,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.muted,
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.muted,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie,
                                size: 32,
                                color: AppTheme.mutedForeground,
                              ),
                              SizedBox(height: 4),
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
                        if (movie.genre != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              movie.genre!,
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontSize: 10,
                              ),
                            ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search movies by title...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchResults = [];
                                _hasSearched = false;
                                _error = '';
                              });
                            },
                          ),
                        IconButton(
                          icon: Icon(
                            _showFilters
                                ? Icons.filter_list
                                : Icons.filter_list_outlined,
                          ),
                          color: _showFilters
                              ? AppTheme.primary
                              : null,
                          onPressed: () {
                            setState(() {
                              _showFilters = !_showFilters;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _performSearch(value);
                    }
                  },
                ),
                if (_showFilters && _hasSearched && _searchResults.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Filter by Genre'),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _genres.map((genre) {
                              final isSelected =
                                  _selectedGenre == genre.toLowerCase();
                              return FilterChip(
                                label: Text(genre),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedGenre = selected ? genre.toLowerCase() : 'all';
                                  });
                                },
                                selectedColor: AppTheme.primary,
                                backgroundColor: AppTheme.muted,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}