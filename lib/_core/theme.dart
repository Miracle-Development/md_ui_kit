import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.3.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFF4355B9),
      primaryContainer: Color(0xFFDEE0FF),
      secondary: Color(0xFF3C64AE),
      secondaryContainer: Color(0xFFD8E2FF),
      tertiary: Color(0xFF537577),
      tertiaryContainer: Color(0xFFA9D4D6),
      appBarColor: Color(0xFFD8E2FF),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
    ),
    // Input color modifiers.
    useMaterial3ErrorColors: true,
    swapLegacyOnMaterial3: true,
    // Surface color adjustments.
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 10,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnLevel: 35,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // User defined custom colors made with FlexSchemeColor() API.
    colors: const FlexSchemeColor(
      primary: Color(0xFFBAC3FF),
      primaryContainer: Color(0xFF293CA0),
      primaryLightRef: Color(0xFF4355B9), // The color of light mode primary
      secondary: Color(0xFFAEC6FF),
      secondaryContainer: Color(0xFF14448D),
      secondaryLightRef: Color(0xFF3C64AE), // The color of light mode secondary
      tertiary: Color(0xFFA9CDCF),
      tertiaryContainer: Color(0xFF2A4C4E),
      tertiaryLightRef: Color(0xFF537577), // The color of light mode tertiary
      appBarColor: Color(0xFFD8E2FF),
      error: Color(0xFFFFB4AB),
      errorContainer: Color(0xFF93000A),
    ),
    // Input color modifiers.
    useMaterial3ErrorColors: true,
    swapLegacyOnMaterial3: true,
    swapColors: true,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
