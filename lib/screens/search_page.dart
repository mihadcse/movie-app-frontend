import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
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

  final List<String> _genres = [
    'All',
    'Action',
    'Romance',
    'Thriller',
    'Comedy',
    'Sci-Fi',
  ];

  final List<Movie> _allMovies = [
    Movie(
      id: '1',
      title: 'Quantum Nexus',
      rating: 8.7,
      image: 'https://images.unsplash.com/photo-1644772715611-0d1f77c10e36?w=400',
      genre: 'Sci-Fi',
    ),
    // Add more movies...
  ];

  List<Movie> get _filteredMovies {
    return _allMovies.where((movie) {
      final matchesSearch = movie.title
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      final matchesGenre = _selectedGenre == 'all' ||
          movie.genre?.toLowerCase() == _selectedGenre.toLowerCase();
      return matchesSearch && matchesGenre;
    }).toList();
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
                    hintText: 'Search movies...',
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
                  onChanged: (value) => setState(() {}),
                ),
                if (_showFilters) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Genre'),
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
                                    _selectedGenre = genre.toLowerCase();
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
            child: _filteredMovies.isEmpty
                ? Center(
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
                        const Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                        movie: _filteredMovies[index],
                        width: double.infinity,
                      );
                    },
                  ),
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