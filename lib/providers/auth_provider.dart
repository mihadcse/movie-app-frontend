import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/user.dart';

// Auth state class
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final User? user;
  final String? token;
  final String? error;
  final bool justLoggedIn; // New field

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.token,
    this.error,
    this.justLoggedIn = false, // Initialize new field
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    User? user,
    String? token,
    String? error,
    bool? justLoggedIn, // Allow copying new field
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error ?? this.error,
      justLoggedIn: justLoggedIn ?? this.justLoggedIn, // Copy new field
    );
  }
}

// Auth provider class
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token != null && token.isNotEmpty) {
        // Verify token and load user data
        await _loadUserProfile(token, justLoggedIn: false); // Not a fresh login
      } else {
        state = state.copyWith(isLoading: false, justLoggedIn: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        justLoggedIn: false,
      );
    }
  }

  Future<void> _loadUserProfile(String token, {bool justLoggedIn = false}) async {
    try {
      final userData = await ApiService.getUserProfile(token);
      final user = User.fromJson(userData);
      
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        token: token,
        error: null,
        justLoggedIn: justLoggedIn, // Set based on parameter
      );
    } catch (e) {
      // Token might be invalid, clear it
      await logout();
      state = state.copyWith(
        isLoading: false,
        error: 'Session expired. Please login again.',
        justLoggedIn: false,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null, justLoggedIn: false); // Reset before login attempt
    
    try {
      final token = await ApiService.loginUser(email: email, password: password);
      
      // Store token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      
      // Load user profile, indicating a fresh login
      await _loadUserProfile(token, justLoggedIn: true);
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        justLoggedIn: false,
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String about,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await ApiService.registerUser(
        name: name,
        email: email,
        password: password,
        about: about,
      );
      
      // Auto-login after registration
      return await login(email, password);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        justLoggedIn: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, justLoggedIn: false); // Reset on logout
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      
      state = const AuthState(justLoggedIn: false); // Ensure justLoggedIn is false on logout
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        justLoggedIn: false,
      );
    }
  }

  void clearJustLoggedIn() {
    state = state.copyWith(justLoggedIn: false);
  }
}

// Provider definition
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).token;
});
