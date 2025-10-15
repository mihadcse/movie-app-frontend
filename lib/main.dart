import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'router.dart';
import 'providers/theme_provider.dart'; // Import the new theme provider

void main() {
  // Add error handling for Flutter web mouse tracking issues
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // Filter out known mouse tracking assertions in debug mode
      if (details.toString().contains('mouse_tracker.dart') ||
          details.toString().contains('Assertion failed')) {
        debugPrint('🐭 Mouse tracking assertion filtered: ${details.exception}');
        return;
      }
      FlutterError.presentError(details);
    }
  };
  
  runApp(
    // Wrap the app with ProviderScope for Riverpod
    const ProviderScope(
      child: CineMatchApp(),
    ),
  );
}

class CineMatchApp extends ConsumerWidget { // Change to ConsumerWidget
  const CineMatchApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Add WidgetRef ref
    final themeModeType = ref.watch(themeProvider); // Watch the theme provider

    return MaterialApp.router(
      title: 'CineMatch',
      theme: AppTheme.lightTheme, // Set light theme as default
      darkTheme: AppTheme.darkTheme, // Define dark theme
      themeMode: themeModeType == ThemeModeType.dark ? ThemeMode.dark : ThemeMode.light, // Use themeMode from provider
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
