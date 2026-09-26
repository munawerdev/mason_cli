import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

/// Configuration class for AppCachedNetworkImage styling and behavior
class AppImageConfig {
  // Size and layout
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  // Styling
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final DecorationImage? backgroundImage;

  // Cache settings
  final int? memCacheWidth;
  final int? memCacheHeight;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final bool enableMemoryCache;
  final bool enableDiskCache;

  // Animation
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final Curve fadeInCurve;
  final Curve fadeOutCurve;
  final bool useOldImageOnUrlChange;

  // Loading indicator
  final bool showLoadingIndicator;
  final Widget? customLoadingWidget;
  final Color? loadingBackgroundColor;
  final Color? loadingIndicatorColor;
  final double loadingIndicatorSize;
  final double loadingIndicatorStrokeWidth;

  // Error handling
  final bool showErrorWidget;
  final Widget? customErrorWidget;
  final IconData errorIcon;
  final Color? errorIconColor;
  final double errorIconSize;
  final Color? errorBackgroundColor;

  // User initials (for profile images)
  final bool enableUserInitials;
  final Color? initialsBackgroundColor;
  final Color? initialsTextColor;
  final TextStyle? initialsTextStyle;
  final String defaultInitial;

  const AppImageConfig({
    // Size and layout
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,

    // Styling
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
    this.border,
    this.backgroundImage,

    // Cache settings
    this.memCacheWidth,
    this.memCacheHeight,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.enableMemoryCache = true,
    this.enableDiskCache = true,

    // Animation
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 100),
    this.fadeInCurve = Curves.easeIn,
    this.fadeOutCurve = Curves.easeOut,
    this.useOldImageOnUrlChange = false,

    // Loading indicator
    this.showLoadingIndicator = true,
    this.customLoadingWidget,
    this.loadingBackgroundColor,
    this.loadingIndicatorColor,
    this.loadingIndicatorSize = 24.0,
    this.loadingIndicatorStrokeWidth = 2.0,

    // Error handling
    this.showErrorWidget = true,
    this.customErrorWidget,
    this.errorIcon = Icons.error_outline,
    this.errorIconColor,
    this.errorIconSize = 24.0,
    this.errorBackgroundColor,

    // User initials
    this.enableUserInitials = false,
    this.initialsBackgroundColor,
    this.initialsTextColor,
    this.initialsTextStyle,
    this.defaultInitial = '?',
  });

  AppImageConfig copyWith({
    double? width,
    double? height,
    BoxFit? fit,
    Alignment? alignment,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    List<BoxShadow>? boxShadow,
    Border? border,
    DecorationImage? backgroundImage,
    int? memCacheWidth,
    int? memCacheHeight,
    int? maxWidthDiskCache,
    int? maxHeightDiskCache,
    bool? enableMemoryCache,
    bool? enableDiskCache,
    Duration? fadeInDuration,
    Duration? fadeOutDuration,
    Curve? fadeInCurve,
    Curve? fadeOutCurve,
    bool? useOldImageOnUrlChange,
    bool? showLoadingIndicator,
    Widget? customLoadingWidget,
    Color? loadingBackgroundColor,
    Color? loadingIndicatorColor,
    double? loadingIndicatorSize,
    double? loadingIndicatorStrokeWidth,
    bool? showErrorWidget,
    Widget? customErrorWidget,
    IconData? errorIcon,
    Color? errorIconColor,
    double? errorIconSize,
    Color? errorBackgroundColor,
    bool? enableUserInitials,
    Color? initialsBackgroundColor,
    Color? initialsTextColor,
    TextStyle? initialsTextStyle,
    String? defaultInitial,
  }) {
    return AppImageConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      fit: fit ?? this.fit,
      alignment: alignment ?? this.alignment,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      boxShadow: boxShadow ?? this.boxShadow,
      border: border ?? this.border,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      memCacheWidth: memCacheWidth ?? this.memCacheWidth,
      memCacheHeight: memCacheHeight ?? this.memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache ?? this.maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache ?? this.maxHeightDiskCache,
      enableMemoryCache: enableMemoryCache ?? this.enableMemoryCache,
      enableDiskCache: enableDiskCache ?? this.enableDiskCache,
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
      fadeOutDuration: fadeOutDuration ?? this.fadeOutDuration,
      fadeInCurve: fadeInCurve ?? this.fadeInCurve,
      fadeOutCurve: fadeOutCurve ?? this.fadeOutCurve,
      useOldImageOnUrlChange:
          useOldImageOnUrlChange ?? this.useOldImageOnUrlChange,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      customLoadingWidget: customLoadingWidget ?? this.customLoadingWidget,
      loadingBackgroundColor:
          loadingBackgroundColor ?? this.loadingBackgroundColor,
      loadingIndicatorColor:
          loadingIndicatorColor ?? this.loadingIndicatorColor,
      loadingIndicatorSize: loadingIndicatorSize ?? this.loadingIndicatorSize,
      loadingIndicatorStrokeWidth:
          loadingIndicatorStrokeWidth ?? this.loadingIndicatorStrokeWidth,
      showErrorWidget: showErrorWidget ?? this.showErrorWidget,
      customErrorWidget: customErrorWidget ?? this.customErrorWidget,
      errorIcon: errorIcon ?? this.errorIcon,
      errorIconColor: errorIconColor ?? this.errorIconColor,
      errorIconSize: errorIconSize ?? this.errorIconSize,
      errorBackgroundColor: errorBackgroundColor ?? this.errorBackgroundColor,
      enableUserInitials: enableUserInitials ?? this.enableUserInitials,
      initialsBackgroundColor:
          initialsBackgroundColor ?? this.initialsBackgroundColor,
      initialsTextColor: initialsTextColor ?? this.initialsTextColor,
      initialsTextStyle: initialsTextStyle ?? this.initialsTextStyle,
      defaultInitial: defaultInitial ?? this.defaultInitial,
    );
  }
}

/// Main AppCachedNetworkImage widget with improved architecture
class AppCachedNetworkImage extends StatelessWidget {
  // Core properties
  final String? imageUrl;
  final AppImageConfig? config;

  // Fallback and user info
  final String? userName;
  final String? fallbackAsset;
  final Widget? fallbackWidget;

  // Callbacks
  final VoidCallback? onTap;
  final VoidCallback? onImageLoaded;
  final void Function(Object error)? onImageError;

  // Accessibility
  final String? semanticLabel;
  final bool excludeFromSemantics;

  const AppCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.config,
    this.userName,
    this.fallbackAsset,
    this.fallbackWidget,
    this.onTap,
    this.onImageLoaded,
    this.onImageError,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config ?? _getBaseDefaultConfig(context);
    Widget imageWidget = _buildImageWidget(context, effectiveConfig);

    // Add tap functionality if provided
    if (onTap != null) {
      imageWidget = GestureDetector(onTap: onTap, child: imageWidget);
    }

    // Add semantics
    if (!excludeFromSemantics) {
      imageWidget = Semantics(
        label: semanticLabel ?? 'Image',
        image: true,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  AppImageConfig _getBaseDefaultConfig(BuildContext context) {
    final theme = Theme.of(context);
    return AppImageConfig(
      loadingBackgroundColor: theme.colorScheme.surfaceContainerHighest,
      loadingIndicatorColor: theme.colorScheme.primary,
      errorBackgroundColor: theme.colorScheme.errorContainer,
      errorIconColor: theme.colorScheme.onErrorContainer,
    );
  }

  Widget _buildImageWidget(BuildContext context, AppImageConfig config) {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return _buildFallbackWidget(context, config);
    }

    return Container(
      width: config.width?.w,
      height: config.height?.h,
      decoration: BoxDecoration(
        borderRadius: config.borderRadius,
        boxShadow: config.boxShadow,
        border: config.border,
      ),
      child: ClipRRect(
        borderRadius: config.borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: config.width?.w,
          height: config.height?.h,
          fit: config.fit,
          alignment: config.alignment,
          memCacheWidth: config.memCacheWidth,
          memCacheHeight: config.memCacheHeight,
          maxWidthDiskCache: config.maxWidthDiskCache,
          maxHeightDiskCache: config.maxHeightDiskCache,
          fadeInDuration: config.fadeInDuration,
          fadeOutDuration: config.fadeOutDuration,
          fadeInCurve: config.fadeInCurve,
          fadeOutCurve: config.fadeOutCurve,
          useOldImageOnUrlChange: config.useOldImageOnUrlChange,
          imageBuilder: (context, imageProvider) {
            onImageLoaded?.call();
            return Container(
              decoration: BoxDecoration(
                color: config.backgroundColor,
                image: DecorationImage(
                  image: imageProvider,
                  fit: config.fit,
                  alignment: config.alignment,
                ),
              ),
            );
          },
          placeholder: config.showLoadingIndicator
              ? (context, url) => _buildLoadingWidget(context, config)
              : null,
          errorWidget: config.showErrorWidget
              ? (context, url, error) {
                  onImageError?.call(error);
                  return _buildErrorWidget(context, config);
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context, AppImageConfig config) {
    if (config.customLoadingWidget != null) {
      return config.customLoadingWidget!;
    }

    return Container(
      width: config.width?.w,
      height: config.height?.h,
      color:
          config.loadingBackgroundColor ??
          Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: config.loadingIndicatorSize.w,
          height: config.loadingIndicatorSize.h,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: config.loadingIndicatorStrokeWidth.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              config.loadingIndicatorColor ??
                  Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, AppImageConfig config) {
    if (config.customErrorWidget != null) {
      return config.customErrorWidget!;
    }

    // Show user initials for avatar type or when explicitly enabled
    if (config.enableUserInitials && userName != null) {
      return _buildUserInitialsWidget(context, config);
    }

    // Show fallback asset if available
    if (fallbackAsset != null) {
      return _buildAssetFallback(context, config);
    }

    // Show custom fallback widget
    if (fallbackWidget != null) {
      return SizedBox(
        width: config.width?.w,
        height: config.height?.h,
        child: fallbackWidget,
      );
    }

    // Default error widget
    return Container(
      width: config.width?.w,
      height: config.height?.h,
      color:
          config.errorBackgroundColor ??
          Theme.of(context).colorScheme.errorContainer,
      child: Center(
        child: Icon(
          config.errorIcon,
          color:
              config.errorIconColor ??
              Theme.of(context).colorScheme.onErrorContainer,
          size: config.errorIconSize.w,
        ),
      ),
    );
  }

  Widget _buildUserInitialsWidget(BuildContext context, AppImageConfig config) {
    final theme = Theme.of(context);
    final initials = _getUserInitials(userName);
    final fontSize = config.width != null ? (config.width! / 2.5).sp : 16.0.sp;

    return Container(
      width: config.width?.w,
      height: config.height?.h,
      decoration: BoxDecoration(
        color:
            config.initialsBackgroundColor ??
            theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: config.borderRadius,
      ),
      child: Center(
        child: Text(
          initials,
          style:
              config.initialsTextStyle?.copyWith(
                fontSize: fontSize,
                color: config.initialsTextColor,
              ) ??
              TextStyle(
                fontSize: fontSize,
                color: config.initialsTextColor ?? theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget _buildAssetFallback(BuildContext context, AppImageConfig config) {
    return Container(
      width: config.width?.w,
      height: config.height?.h,
      decoration: BoxDecoration(
        borderRadius: config.borderRadius,
        image: DecorationImage(
          image: AssetImage(fallbackAsset!),
          fit: config.fit,
          alignment: config.alignment,
        ),
      ),
    );
  }

  Widget _buildFallbackWidget(BuildContext context, AppImageConfig config) {
    // Show user initials if available
    if (config.enableUserInitials && userName != null) {
      return _buildUserInitialsWidget(context, config);
    }

    // Show asset fallback
    if (fallbackAsset != null) {
      return _buildAssetFallback(context, config);
    }

    // Show custom fallback widget
    if (fallbackWidget != null) {
      return SizedBox(
        width: config.width?.w,
        height: config.height?.h,
        child: fallbackWidget,
      );
    }

    // Default fallback
    return _buildErrorWidget(context, config);
  }

  String _getUserInitials(String? name) {
    if (name == null || name.trim().isEmpty)
      return config?.defaultInitial ?? '?';

    final trimmedName = name.trim();
    final words = trimmedName.split(RegExp(r'\s+'));

    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else {
      return trimmedName.substring(0, 1).toUpperCase();
    }
  }
}
