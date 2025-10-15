import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  // Define a custom color for destructive actions, not part of FlexColorScheme directly
  static const Color destructive = Color(0xFFD4183D);

  // Custom "Rust deep orange" color
  static const Color _rustDeepOrangePrimary = Color(0xFFDA5B0B);

  // Custom FlexSchemeColor for light theme
  static final FlexSchemeColor _lightFlexScheme = FlexSchemeColor.from(
    primary: _rustDeepOrangePrimary,
    brightness: Brightness.light,
    // You can define other colors here if needed, or let FlexColorScheme derive them
  );

  // Custom FlexSchemeColor for dark theme
  static final FlexSchemeColor _darkFlexScheme = FlexSchemeColor.from(
    primary: _rustDeepOrangePrimary,
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
  );
}
