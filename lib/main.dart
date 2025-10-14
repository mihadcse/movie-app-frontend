import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'theme/app_theme.dart';
import 'router.dart';

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
  
  runApp(const CineMatchApp());
}

class CineMatchApp extends StatelessWidget {
  const CineMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineMatch',
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}