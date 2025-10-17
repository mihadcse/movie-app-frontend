import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ThemeModeType { light, dark }

class ThemeNotifier extends StateNotifier<ThemeModeType> {
  ThemeNotifier() : super(ThemeModeType.dark); // Default to dark mode

  void toggleTheme() {
    state = state == ThemeModeType.dark ? ThemeModeType.light : ThemeModeType.dark;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeModeType>((ref) {
  return ThemeNotifier();
});
