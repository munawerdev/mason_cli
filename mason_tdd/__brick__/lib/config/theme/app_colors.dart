import 'package:material_ui/material_ui.dart';

/// App Colors - Centralized color definitions
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  // static const Color primaryVariant = Color(0xFF1976D2);

  // // Secondary Colors
  // static const Color secondary = Color(0xFF03DAC6);
  // static const Color secondaryVariant = Color(0xFF018786);

  // // Background Colors
  // static const Color background = Color(0xFFFAFAFA);
  // static const Color surface = Color(0xFFFFFFFF);

  // // Text Colors
  // static const Color onPrimary = Color(0xFFFFFFFF);
  // static const Color onSecondary = Color(0xFF000000);
  // static const Color onBackground = Color(0xFF000000);
  // static const Color onSurface = Color(0xFF000000);

  // // Error Colors
  // static const Color error = Color(0xFFB00020);

  // // Additional Colors
  // static const Color disabled = Color(0xFFBDBDBD);
  // static const Color divider = Color(0xFFE0E0E0);

  // // Utility Colors
  // static const Color shadow = Color(0xFF000000);
  // static const Color scrim = Color(0xFF000000);
  // static const Color inverseSurface = Color(0xFF121212);
  // static const Color onInverseSurface = Color(0xFFFFFFFF);
  // static const Color inversePrimary = Color(0xFF1976D2);

  // Color Scheme
  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    // onPrimary: onPrimary,
    // primaryContainer: primaryVariant,
    // onPrimaryContainer: onPrimary,
    // secondary: secondary,
    // onSecondary: onSecondary,
    // secondaryContainer: secondaryVariant,
    // onSecondaryContainer: onSecondary,
    // tertiary: secondary,
    // onTertiary: onSecondary,
    // tertiaryContainer: secondaryVariant,
    // onTertiaryContainer: onSecondary,
    // error: error,
    // onError: onPrimary,
    // errorContainer: error,
    // onErrorContainer: onPrimary,
    // background: background,
    // onBackground: onBackground,
    // surface: surface,
    // onSurface: onSurface,
    // surfaceVariant: surface,
    // onSurfaceVariant: onSurface,
    // outline: divider,
    // outlineVariant: divider,
    // shadow: shadow,
    // scrim: scrim,
    // inverseSurface: inverseSurface,
    // onInverseSurface: onInverseSurface,
    // inversePrimary: inversePrimary,
    // surfaceTint: primary,
  );
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    primary: primary,
    seedColor: primary,
    brightness: Brightness.dark,
  );
}
