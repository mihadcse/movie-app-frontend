import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_api_service.dart';

// Movie state class
class MovieState {
  final List<Movie> movies;
  final bool isLoading;
  final bool hasMoreData;
  final int currentPage;
  final String? error;

  const MovieState({
    this.movies = const [],
    this.isLoading = false,
    this.hasMoreData = true,
    this.currentPage = 0,
    this.error,
  });

  MovieState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? hasMoreData,
    int? currentPage,
    String? error,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

// Movie provider class
class MovieNotifier extends StateNotifier<MovieState> {
  MovieNotifier() : super(const MovieState()) {
    loadMovies();
  }

  Future<void> loadMovies({bool refresh = false}) async {
    if (refresh) {
      state = const MovieState(isLoading: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final moviePageResponse = await MovieApiService.getAllMovies(
        pageNumber: 0,
        pageSize: 20,
        sortBy: 'title',
        sortDir: 'ASC',
      );

      state = state.copyWith(
        movies: moviePageResponse.content,
        currentPage: 0,
        hasMoreData: !moviePageResponse.isLast,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMoreMovies() async {
    if (state.isLoading || !state.hasMoreData) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.currentPage + 1;
      final moviePageResponse = await MovieApiService.getAllMovies(
        pageNumber: nextPage,
        pageSize: 20,
        sortBy: 'title',
        sortDir: 'ASC',
      );

      state = state.copyWith(
        movies: [...state.movies, ...moviePageResponse.content],
        currentPage: nextPage,
        hasMoreData: !moviePageResponse.isLast,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Search state class
class SearchState {
  final List<Movie> searchResults;
  final bool isSearching;
  final bool hasSearched;
  final String query;
  final String? error;

  const SearchState({
    this.searchResults = const [],
    this.isSearching = false,
    this.hasSearched = false,
    this.query = '',
    this.error,
  });

  SearchState copyWith({
    List<Movie>? searchResults,
    bool? isSearching,
    bool? hasSearched,
    String? query,
    String? error,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      hasSearched: hasSearched ?? this.hasSearched,
      query: query ?? this.query,
      error: error,
    );
  }
}

// Search provider class
class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  Future<void> searchMovies(String keywords) async {
    if (keywords.trim().isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(
      isSearching: true,
      query: keywords,
      error: null,
    );

    try {
      final results = await MovieApiService.searchMoviesByTitle(keywords);
      
      state = state.copyWith(
        searchResults: results,
        isSearching: false,
        hasSearched: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        hasSearched: true,
        error: e.toString(),
      );
    }
  }

  void clearSearch() {
    state = const SearchState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider definitions
final movieProvider = StateNotifierProvider<MovieNotifier, MovieState>((ref) {
  return MovieNotifier();
});

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

// Convenience providers
final featuredMoviesProvider = Provider<List<Movie>>((ref) {
  final movies = ref.watch(movieProvider).movies;
  return movies.take(5).toList();
});

final allMoviesProvider = Provider<List<Movie>>((ref) {
  return ref.watch(movieProvider).movies;
});

final searchResultsProvider = Provider<List<Movie>>((ref) {
  return ref.watch(searchProvider).searchResults;
});

final isLoadingMoviesProvider = Provider<bool>((ref) {
  return ref.watch(movieProvider).isLoading;
});

final isSearchingProvider = Provider<bool>((ref) {
  return ref.watch(searchProvider).isSearching;
});