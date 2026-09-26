import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

/// App Text Styles - Centralized typography definitions
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  static TextStyle _style(double size, FontWeight weight) =>
      TextStyle(fontSize: size.sp, fontWeight: weight);

  // Display Styles
  static TextStyle get displayLarge => _style(57, FontWeight.w400);

  static TextStyle get displayMedium => _style(45, FontWeight.w400);

  static TextStyle get displaySmall => _style(36, FontWeight.w400);

  // Headline Styles
  static TextStyle get headlineLarge => _style(32, FontWeight.w400);

  static TextStyle get headlineMedium => _style(28, FontWeight.w400);

  static TextStyle get headlineSmall => _style(24, FontWeight.w400);

  // Title Styles
  static TextStyle get titleLarge => _style(22, FontWeight.w400);

  static TextStyle get titleMedium => _style(16, FontWeight.w500);

  static TextStyle get titleSmall => _style(14, FontWeight.w500);

  // Body Styles
  static TextStyle get bodyLarge => _style(16, FontWeight.w400);

  static TextStyle get bodyMedium => _style(14, FontWeight.w400);

  static TextStyle get bodySmall => _style(12, FontWeight.w400);

  // Label Styles
  static TextStyle get labelLarge => _style(14, FontWeight.w500);

  static TextStyle get labelMedium => _style(12, FontWeight.w500);

  static TextStyle get labelSmall => _style(11, FontWeight.w500);

  /// Get the complete TextTheme
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
