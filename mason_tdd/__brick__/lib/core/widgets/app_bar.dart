import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

/// Lightweight config for quick actions in the custom app bar.
class AppBarAction {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const AppBarAction({required this.icon, this.onPressed, this.tooltip});
}

/// Theme-aware custom app bar — use like any PreferredSizeWidget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.toolbarHeight,
    this.leadingWidth,
    this.centerTitle,
    this.automaticallyImplyLeading = false,
    this.showLeading = true,
    this.leading,
    this.onLeadingPressed,
    this.leadingIconAsset,
    this.leadingIcon,
    this.leadingIconSize,
    this.leadingIconPadding,
    this.quickActions,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.scrolledUnderElevation,
    this.shape,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.bottom,
    this.semanticLabel,
  });

  // Core
  final String? title;
  final Widget? titleWidget;

  // Layout
  final double? toolbarHeight;
  final double? leadingWidth;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;

  // Navigation
  final bool showLeading;
  final Widget? leading;
  final VoidCallback? onLeadingPressed;
  final String? leadingIconAsset;
  final IconData? leadingIcon;
  final double? leadingIconSize;
  final EdgeInsets? leadingIconPadding;

  // Actions
  final List<AppBarAction>? quickActions;
  final List<Widget>? actions;

  // Styling
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final double? elevation;
  final double? scrolledUnderElevation;
  final ShapeBorder? shape;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool forceMaterialTransparency;

  // Bottom
  final PreferredSizeWidget? bottom;

  // Accessibility
  final String? semanticLabel;

  @override
  Size get preferredSize => Size.fromHeight(
    (toolbarHeight?.h ?? _kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
  );

  // Matches Flutter's internal default, avoids depending on theme at build time
  static const double _kToolbarHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    Widget appBar = AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      shadowColor: shadowColor ?? appBarTheme.shadowColor,
      surfaceTintColor: surfaceTintColor ?? appBarTheme.surfaceTintColor,
      elevation: elevation ?? appBarTheme.elevation ?? 0.0,
      scrolledUnderElevation:
          scrolledUnderElevation ?? appBarTheme.scrolledUnderElevation ?? 0.0,
      toolbarHeight: toolbarHeight?.h ?? appBarTheme.toolbarHeight?.h,
      leadingWidth: leadingWidth?.w ?? appBarTheme.leadingWidth?.w,
      centerTitle: centerTitle ?? appBarTheme.centerTitle ?? true,
      titleSpacing: appBarTheme.titleSpacing ?? 0,
      shape: shape ?? appBarTheme.shape,
      systemOverlayStyle: systemOverlayStyle ?? appBarTheme.systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      leading: _buildLeading(context, theme),
      title: _buildTitle(appBarTheme),
      actions: _buildActions(),
      bottom: bottom,
    );

    if (semanticLabel != null) {
      appBar = Semantics(label: semanticLabel, child: appBar);
    }

    return appBar;
  }

  Widget? _buildLeading(BuildContext context, ThemeData theme) {
    if (!showLeading) return null;
    if (leading != null) return leading;

    final appBarTheme = theme.appBarTheme;
    final iconTheme = appBarTheme.iconTheme ?? theme.iconTheme;
    final iconSize = leadingIconSize?.sp ?? iconTheme.size?.sp ?? 24.0.sp;
    final iconPadding = leadingIconPadding ?? EdgeInsets.all(14.0.w);

    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: IconButton(
        padding: iconPadding,
        icon: _buildLeadingIcon(iconSize, iconTheme.color),
        onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildLeadingIcon(double size, Color? color) {
    if (leadingIconAsset != null) {
      return Image.asset(
        leadingIconAsset!,
        color: color,
        height: size,
        width: size,
      );
    }

    return Icon(
      leadingIcon ?? Icons.arrow_back_ios_new_rounded,
      color: color,
      size: size,
    );
  }

  Widget? _buildTitle(AppBarThemeData appBarTheme) {
    if (titleWidget != null) return titleWidget;
    if (title == null) return null;

    return Text(
      title!,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: titleTextStyle ?? appBarTheme.titleTextStyle,
    );
  }

  List<Widget>? _buildActions() {
    final allActions = <Widget>[
      if (quickActions != null)
        ...quickActions!.map(
          (action) => Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: IconButton(
              onPressed: action.onPressed,
              icon: action.icon,
              tooltip: action.tooltip,
            ),
          ),
        ),
      if (actions != null) ...actions!,
    ];

    if (allActions.isEmpty) return null;

    // Trailing padding done via a SizedBox action — cleaner than hacking margins
    return [...allActions, SizedBox(width: 8.w)];
  }
}
