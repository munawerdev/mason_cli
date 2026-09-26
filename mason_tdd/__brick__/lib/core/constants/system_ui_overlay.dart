import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Centralized system UI overlay styles for managing status bar and navigation bar appearance
class AppSystemUI {
  // Private constructor to prevent instantiation
  AppSystemUI._();

  /// Light theme system UI overlay - dark icons on light background
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light, // For iOS
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  /// Dark theme system UI overlay - light icons on dark background
  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark, // For iOS
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.transparent,
  );

  /// Custom overlay style with specific colors
  static SystemUiOverlayStyle custom({
    Color statusBarColor = Colors.transparent,
    Color navigationBarColor = Colors.transparent,
    Brightness statusBarIconBrightness = Brightness.dark,
    Brightness navigationBarIconBrightness = Brightness.dark,
    Color? dividerColor,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: statusBarIconBrightness,
      statusBarBrightness: statusBarIconBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: navigationBarColor,
      systemNavigationBarIconBrightness: navigationBarIconBrightness,
      systemNavigationBarDividerColor: dividerColor ?? Colors.transparent,
    );
  }

  /// Apply overlay style based on theme brightness
  ///
  /// [brightness] - The current theme brightness
  /// [customStyle] - Optional custom style to override defaults
  static void apply({
    Brightness brightness = Brightness.light,
    SystemUiOverlayStyle? customStyle,
  }) {
    final style = customStyle ?? (brightness == Brightness.dark ? dark : light);

    SystemChrome.setSystemUIOverlayStyle(style);
  }

  /// Apply overlay style based on boolean flag (legacy compatibility)
  ///
  /// [isDark] - Whether to use dark theme styling
  static void applyLegacy({bool isDark = false}) {
    apply(brightness: isDark ? Brightness.dark : Brightness.light);
  }

  /// Apply style based on BuildContext theme
  ///
  /// [context] - BuildContext to get theme from
  static void applyFromContext(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    apply(brightness: brightness);
  }

  /// Set system UI to be fully immersive (hide status and navigation bars)
  static void setFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  /// Restore normal system UI visibility
  static void exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Set preferred orientations
  static Future<void> setOrientation(List<DeviceOrientation> orientations) {
    return SystemChrome.setPreferredOrientations(orientations);
  }

  /// Lock to portrait orientation
  static Future<void> lockPortrait() {
    return setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Lock to landscape orientation
  static Future<void> lockLandscape() {
    return setOrientation([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allow all orientations
  static Future<void> allowAllOrientations() {
    return setOrientation(DeviceOrientation.values);
  }

  /// Initialize system UI with default settings
  /// Call this in your main() function or MyApp initialization
  static void initialize({
    Brightness defaultBrightness = Brightness.light,
    List<DeviceOrientation>? preferredOrientations,
  }) {
    apply(brightness: defaultBrightness);

    if (preferredOrientations != null) {
      setOrientation(preferredOrientations);
    }
  }
}
