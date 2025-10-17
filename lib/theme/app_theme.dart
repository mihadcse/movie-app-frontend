import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  // Define a custom color for destructive actions, not part of FlexColorScheme directly
  static const Color destructive = Color(0xFFD4183D);

  // Custom "Rust deep blue" color
  static const Color _rustDeepBluePrimary = const Color.fromARGB(255, 24, 50, 199);

  // Custom FlexSchemeColor for light theme
  static final FlexSchemeColor _lightFlexScheme = FlexSchemeColor.from(
    primary: const Color.fromARGB(255, 24, 50, 199),
    brightness: Brightness.light,
    // You can define other colors here if needed, or let FlexColorScheme derive them
  );

  // Custom FlexSchemeColor for dark theme
  static final FlexSchemeColor _darkFlexScheme = FlexSchemeColor.from(
    primary: _rustDeepBluePrimary,
    brightness: Brightness.dark,
    // You can define other colors here if needed, or let FlexColorScheme derive them
  );

  static ThemeData lightTheme = FlexThemeData.light(
    colors: _lightFlexScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    appBarOpacity: 0.95,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 10,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 24.0, // Apply a default border radius to all components
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedBorderIsColored: false,
      chipSchemeColor: SchemeColor.primary,
      cardRadius: 16.0, // Card radius
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  ).copyWith(
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFFFFFFF),
      indicatorColor: _rustDeepBluePrimary.withOpacity(0.12),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return IconThemeData(
          size: isSelected ? 26 : 24,
        );
      }),
    ),
    cardTheme: const CardThemeData(
      elevation: 4,
      shadowColor: Colors.black45,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shadowColor: Colors.black45,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _rustDeepBluePrimary.withOpacity(0.7)),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: _darkFlexScheme,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    appBarOpacity: 0.90,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      defaultRadius: 24.0, // Apply a default border radius to all components
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedBorderIsColored: false,
      chipSchemeColor: SchemeColor.primary,
      cardRadius: 16.0, // Card radius
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  ).copyWith(
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF121212),
      indicatorColor: _rustDeepBluePrimary.withOpacity(0.24),
      labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((states) {
        final isSelected = states.contains(MaterialState.selected);
        return IconThemeData(
          size: isSelected ? 26 : 24,
        );
      }),
    ),
    cardTheme: const CardThemeData(
      elevation: 12,
      shadowColor: Colors.white30 ,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 12,
        shadowColor: Colors.white30,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _rustDeepBluePrimary.withOpacity(1.0)),
        elevation: 6,
        shadowColor: Colors.white24,
      ),
    ),
  );
}
