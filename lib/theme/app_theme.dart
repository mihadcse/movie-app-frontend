import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  // Define a custom color for destructive actions, not part of FlexColorScheme directly
  static const Color destructive = Color(0xFFEF5350);

  // Modern vibrant primary color - brighter blue for better visibility
  static const Color _modernBluePrimary = Color(0xFF2196F3);
  static const Color _modernBlueLight = Color(0xFF64B5F6);

  // Custom FlexSchemeColor for light theme with vibrant colors
  static final FlexSchemeColor _lightFlexScheme = FlexSchemeColor.from(
    primary: _modernBluePrimary,
    primaryContainer: const Color(0xFFE3F2FD),
    secondary: const Color(0xFF26A69A), // Teal accent
    secondaryContainer: const Color(0xFFB2DFDB),
    brightness: Brightness.light,
  );

  // Custom FlexSchemeColor for dark theme with high contrast
  static final FlexSchemeColor _darkFlexScheme = FlexSchemeColor.from(
    primary: _modernBlueLight, // Brighter primary for dark mode
    primaryContainer: const Color(0xFF1565C0),
    secondary: const Color(0xFF4DB6AC), // Lighter teal for dark mode
    secondaryContainer: const Color(0xFF00695C),
    brightness: Brightness.dark,
  );

  static ThemeData lightTheme = FlexThemeData.light(
    colors: _lightFlexScheme,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 7,
    appBarOpacity: 0.98,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 16.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: true,
      inputDecoratorRadius: 12.0,
      chipSchemeColor: SchemeColor.primary,
      cardRadius: 12.0,
      elevatedButtonRadius: 12.0,
      outlinedButtonRadius: 12.0,
      textButtonRadius: 12.0,
      filledButtonRadius: 12.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
  ).copyWith(
    // Enhanced text theme for better readability
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Color(0xFF424242), fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Color(0xFF212121)),
      bodyMedium: TextStyle(color: Color(0xFF424242)),
      bodySmall: TextStyle(color: Color(0xFF616161)),
      labelLarge: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: Color(0xFF424242)),
      labelSmall: TextStyle(color: Color(0xFF616161)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFAFAFA),
      indicatorColor: _modernBluePrimary.withOpacity(0.15),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: isSelected ? 13 : 12,
          color: isSelected ? _modernBluePrimary : const Color(0xFF616161),
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return IconThemeData(
          size: isSelected ? 28 : 24,
          color: isSelected ? _modernBluePrimary : const Color(0xFF757575),
        );
      }),
    ),
    cardTheme: const CardThemeData(
      elevation: 2,
      shadowColor: Colors.black26,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: Colors.black38,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _modernBluePrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: _darkFlexScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 15,
    appBarOpacity: 0.95,
    darkIsTrueBlack: false, // Use dark gray instead of pure black for better contrast
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 30,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 16.0,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedBorderIsColored: true,
      inputDecoratorRadius: 12.0,
      chipSchemeColor: SchemeColor.primary,
      cardRadius: 12.0,
      elevatedButtonRadius: 12.0,
      outlinedButtonRadius: 12.0,
      textButtonRadius: 12.0,
      filledButtonRadius: 12.0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
  ).copyWith(
    // High contrast text theme for dark mode - much more visible
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color(0xFFF5F5F5), fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color(0xFFF5F5F5), fontWeight: FontWeight.w600),
      headlineLarge: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color(0xFFF5F5F5), fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Color(0xFFF0F0F0), fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Color(0xFFEEEEEE), fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Color(0xFFE0E0E0), fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Color(0xFFEEEEEE), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
      bodySmall: TextStyle(color: Color(0xFFBDBDBD), fontSize: 12),
      labelLarge: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: Color(0xFFE0E0E0)),
      labelSmall: TextStyle(color: Color(0xFFBDBDBD)),
    ),
    // Better surface colors for dark mode
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: _modernBlueLight.withOpacity(0.25),
      elevation: 8,
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: isSelected ? 13 : 12,
          color: isSelected ? _modernBlueLight : const Color(0xFFB0B0B0),
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return IconThemeData(
          size: isSelected ? 28 : 24,
          color: isSelected ? _modernBlueLight : const Color(0xFFA0A0A0),
        );
      }),
    ),
    cardTheme: const CardThemeData(
      elevation: 4,
      shadowColor: Colors.black54,
      color: Color(0xFF1E1E1E),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shadowColor: Colors.black54,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: _modernBluePrimary,
        foregroundColor: Colors.white,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: _modernBlueLight,
        foregroundColor: const Color(0xFF000000),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _modernBlueLight, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        foregroundColor: _modernBlueLight,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _modernBlueLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    // Better input decoration for dark mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      labelStyle: const TextStyle(color: Color(0xFFB0B0B0)),
      hintStyle: const TextStyle(color: Color(0xFF757575)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _modernBlueLight, width: 2),
      ),
    ),
    // Better divider color
    dividerColor: const Color(0xFF424242),
    // Better icon theme
    iconTheme: const IconThemeData(
      color: Color(0xFFE0E0E0),
      size: 24,
    ),
  );
}
