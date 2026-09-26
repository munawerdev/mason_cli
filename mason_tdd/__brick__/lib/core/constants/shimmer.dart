import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

// Assuming your extensions file has theme extension
// import '/core/utils/extensions.dart';

/// A comprehensive shimmer utility for consistent loading placeholders
class AppShimmer {
  // Private constructor to prevent instantiation
  AppShimmer._();

  /// Default shimmer duration
  static const Duration _defaultDuration = Duration(milliseconds: 1200);

  /// Default shimmer direction
  static const ShimmerDirection _defaultDirection = ShimmerDirection.ltr;

  /// Creates a shimmer effect wrapping [child] with customizable properties
  static Widget shimmer(
    BuildContext context, {
    Color? baseColor,
    Color? highlightColor,
    Duration duration = _defaultDuration,
    ShimmerDirection direction = _defaultDirection,
    required Widget child,
  }) => Shimmer.fromColors(
    period: duration,
    baseColor: baseColor ?? Colors.grey[300]!.withValues(alpha: 0.6),
    highlightColor: highlightColor ?? Colors.grey[100]!.withValues(alpha: 0.3),
    direction: direction,
    child: child,
  );
}
