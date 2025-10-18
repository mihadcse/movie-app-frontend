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
                  const Color.fromARGB(255, 34, 34, 34), // Dark gray
                  const Color.fromARGB(255, 51, 51, 88), // Dark blue-gray
                  const Color(0xFF0F0F0F), // Near black
                ]
              : [
                  const Color.fromARGB(255, 173, 210, 237), // Light blue
                  const Color(0xFFFAFAFA), // Off-white
                  const Color.fromARGB(255, 199, 197, 197), // Light gray
                  const Color.fromARGB(255, 155, 200, 221), // Very light cyan
                ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: child,
    );
  }
}
