import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

// Theme
ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: AppColors.lightColorScheme,
  textTheme: AppTextStyles.textTheme,
  primaryTextTheme: AppTextStyles.textTheme,

  // App Bar Theme
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.lightColorScheme.surface,
    foregroundColor: AppColors.lightColorScheme.onSurface,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.lightColorScheme.shadow,
    toolbarHeight: 56.h,
    leadingWidth: 80.w,
    titleSpacing: 0,
    titleTextStyle: AppTextStyles.titleLarge.copyWith(
      fontWeight: FontWeight.w600,
      color: AppColors.lightColorScheme.onSurface,
    ),
    iconTheme: IconThemeData(
      color: AppColors.lightColorScheme.onSurface,
      size: 24.r,
    ),
    actionsIconTheme: IconThemeData(
      color: AppColors.lightColorScheme.onSurface,
      size: 24.r,
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark, // For iOS
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.lightColorScheme.primary,
      foregroundColor: AppColors.lightColorScheme.onPrimary,
      disabledBackgroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.12,
      ),
      disabledForegroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.38,
      ),
      minimumSize: Size(double.infinity.w, 48.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      textStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
      animationDuration: const Duration(milliseconds: 200),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.lightColorScheme.primary,
      disabledForegroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.38,
      ),
      side: BorderSide(color: AppColors.lightColorScheme.primary, width: 1.w),
      disabledBackgroundColor: Colors.transparent,
      minimumSize: Size(double.infinity.w, 48.h),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      textStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
      animationDuration: const Duration(milliseconds: 200),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.lightColorScheme.primary,
      disabledForegroundColor: AppColors.lightColorScheme.onSurface.withValues(
        alpha: 0.38,
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
      minimumSize: Size(0, 48.h),
      textStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
      animationDuration: const Duration(milliseconds: 200),
    ),
  ),

  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: AppColors.lightColorScheme.surface,
      padding: EdgeInsets.zero,
      minimumSize: Size(40.w, 40.h),
      shape: const CircleBorder(),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightColorScheme.surface,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

    // Border styles
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.lightColorScheme.outline,
        width: 1.w,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.lightColorScheme.outline,
        width: 1.w,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.lightColorScheme.primary,
        width: 2.w,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.lightColorScheme.error,
        width: 1.w,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.lightColorScheme.error,
        width: 2.w,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.lightColorScheme.outline.withValues(alpha: 0.38),
        width: 1.w,
      ),
    ),

    // Typography
    labelStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.lightColorScheme.onSurfaceVariant,
    ),
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: AppColors.lightColorScheme.onSurfaceVariant.withValues(alpha: 0.6),
    ),
    errorStyle: AppTextStyles.bodySmall.copyWith(
      color: AppColors.lightColorScheme.error,
    ),
    helperStyle: AppTextStyles.bodySmall.copyWith(
      color: AppColors.lightColorScheme.onSurfaceVariant.withValues(alpha: 0.6),
    ),

    // Behavior
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    alignLabelWithHint: true,
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(thickness: 1.w, space: 1.h),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: AppColors.darkColorScheme,
  textTheme: AppTextStyles.textTheme,
  primaryTextTheme: AppTextStyles.textTheme,
);
