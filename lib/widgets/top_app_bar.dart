import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TopAppBarWidget extends StatelessWidget {
  final String title;
  final bool showSearch;
  final VoidCallback? onSearchClick;

  const TopAppBarWidget({
    super.key,
    required this.title,
    this.showSearch = true,
    this.onSearchClick,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.movie_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
            ).createShader(bounds),
            child: Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      actions: showSearch
          ? [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: onSearchClick,
              ),
            ]
          : null,
    );
  }
}
