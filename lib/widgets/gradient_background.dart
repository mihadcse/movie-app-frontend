import 'package:flutter/material.dart';

/// A modern gradient background widget that adapts to light and dark themes
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
              ? [
                  const Color(0xFF0A0E27), // Deep navy blue
                  const Color(0xFF121212), // Dark gray
                  const Color.fromARGB(255, 45, 45, 78), // Dark blue-gray
                  const Color(0xFF0F0F0F), // Near black
                ]
              : [
                  const Color.fromARGB(255, 173, 210, 237), // Light blue
                  const Color(0xFFFAFAFA), // Off-white
                  const Color(0xFFF5F5F5), // Light gray
                  const Color.fromARGB(255, 210, 241, 255), // Very light cyan
                ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: child,
    );
  }
}
