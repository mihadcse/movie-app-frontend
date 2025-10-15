import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';
import 'screens/search_page.dart';
import 'screens/watchlist_page.dart';
import 'screens/profile_page.dart';
import 'screens/movie_details.dart';
import 'screens/mood_discovery_page.dart';
import 'screens/chat_page.dart';
import 'models/movie.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Chat Route
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => ChatPage(),
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          // Home Tab
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: '/movie-details',
                name: 'movie-details-from-home',
                builder: (context, state) {
                  final movie = state.extra as Movie;
                  return MovieDetailsPage(movie: movie);
                },
              ),
            ],
          ),

          // Search Tab
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchPage(),
            routes: [
              GoRoute(
                path: '/movie-details',
                name: 'movie-details-from-search',
                builder: (context, state) {
                  final movie = state.extra as Movie;
                  return MovieDetailsPage(movie: movie);
                },
              ),
            ],
          ),

          // Watchlist Tab
          GoRoute(
            path: '/watchlist',
            name: 'watchlist',
            builder: (context, state) => const WatchlistPage(),
            routes: [
              GoRoute(
                path: '/movie-details',
                name: 'movie-details-from-watchlist',
                builder: (context, state) {
                  final movie = state.extra as Movie;
                  return MovieDetailsPage(movie: movie);
                },
              ),
            ],
          ),

          // Profile Tab
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),

          // Mood Discovery
          GoRoute(
            path: '/mood-discovery',
            name: 'mood-discovery',
            builder: (context, state) => const MoodDiscoveryPage(),
          ),
        ],
      ),

      // Standalone Movie Details (for direct navigation)
      GoRoute(
        path: '/movie/:id',
        name: 'movie-details',
        builder: (context, state) {
          final movieId = state.pathParameters['id']!;
          final movie = state.extra as Movie?;
          
          if (movie != null) {
            return MovieDetailsPage(movie: movie);
          }
          
          // If no movie object is passed, create a placeholder or fetch from API
          return MovieDetailsPage(
            movie: Movie(
              id: movieId,
              title: 'Loading...',
              rating: 0.0,
              image: '',
            ),
          );
        },
      ),
    ],
    redirect: (context, state) {
      // You can add authentication logic here
      // For now, we'll allow access to all routes
      // Replace this with actual authentication check when needed
      
      return null; // No redirect needed for now
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you requested could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Main Shell Widget that provides bottom navigation
class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/watchlist');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine current index based on location
    final location = GoRouterState.of(context).fullPath;
    if (location?.startsWith('/home') == true) {
      _selectedIndex = 0;
    } else if (location?.startsWith('/search') == true) {
      _selectedIndex = 1;
    } else if (location?.startsWith('/watchlist') == true) {
      _selectedIndex = 2;
    } else if (location?.startsWith('/profile') == true) {
      _selectedIndex = 3;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Navigation Extensions for easier usage
extension AppRouterExtension on GoRouter {
  void goToLogin() => go('/login');
  void goToRegister() => go('/register');
  void goToHome() => go('/home');
  void goToSearch() => go('/search');
  void goToWatchlist() => go('/watchlist');
  void goToProfile() => go('/profile');
  void goToMoodDiscovery() => go('/mood-discovery');
  
  void goToMovieDetails(Movie movie, {String? from}) {
    if (from != null) {
      go('/$from/movie-details', extra: movie);
    } else {
      go('/movie/${movie.id}', extra: movie);
    }
  }
  
  void pushMovieDetails(Movie movie) {
    push('/movie/${movie.id}', extra: movie);
  }
}

// Helper class for navigation
class AppNavigation {
  static final GoRouter _router = AppRouter.router;
  
  // Authentication Navigation
  static void toLogin() => _router.goToLogin();
  static void toRegister() => _router.goToRegister();
  
  // Main App Navigation
  static void toHome() => _router.goToHome();
  static void toSearch() => _router.goToSearch();
  static void toWatchlist() => _router.goToWatchlist();
  static void toProfile() => _router.goToProfile();
  static void toMoodDiscovery() => _router.goToMoodDiscovery();
  
  // Movie Details Navigation
  static void toMovieDetails(Movie movie) => _router.pushMovieDetails(movie);
  static void toMovieDetailsFromTab(Movie movie, String tab) {
    _router.goToMovieDetails(movie, from: tab);
  }
  
  // Navigation Actions
  static void back() => _router.pop();
  static void backToRoot() => _router.go('/home');
  
  // Get current location
  static String get currentLocation => _router.routerDelegate.currentConfiguration.fullPath;
  
  // Check if can pop
  static bool get canPop => _router.canPop();
}
