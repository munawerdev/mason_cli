import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

enum _ButtonVariant { elevated, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.text,
    required this.onPressed,
    this.onLongPress,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.textStyle,
    this.loading = false,
    this.disabled = false,
    this.child,
    this.icon,
    this.loadingColor,
    this.loadingSize,
    this.tooltip,
    this.semanticLabel,
  }) : _variant = _ButtonVariant.elevated,
       borderColor = null,
       borderWidth = null,
       assert(
         text != null || child != null,
         'Either text or child must be provided',
       );

  const AppButton.outlined({
    super.key,
    this.text,
    required this.onPressed,
    this.onLongPress,
    this.width,
    this.height,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.textStyle,
    this.loading = false,
    this.disabled = false,
    this.child,
    this.icon,
    this.loadingColor,
    this.loadingSize,
    this.tooltip,
    this.semanticLabel,
  }) : _variant = _ButtonVariant.outlined,
       backgroundColor = null,
       elevation = null,
       assert(
         text != null || child != null,
         'Either text or child must be provided',
       );

  const AppButton.text({
    super.key,
    this.text,
    required this.onPressed,
    this.onLongPress,
    this.width,
    this.height,
    this.foregroundColor,
    this.textStyle,
    this.loading = false,
    this.disabled = false,
    this.child,
    this.icon,
    this.loadingColor,
    this.loadingSize,
    this.tooltip,
    this.semanticLabel,
  }) : _variant = _ButtonVariant.text,
       backgroundColor = null,
       elevation = null,
       borderColor = null,
       borderWidth = null,
       assert(
         text != null || child != null,
         'Either text or child must be provided',
       );

  final _ButtonVariant _variant;
  final String? text;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? elevation;
  final TextStyle? textStyle;
  final bool loading;
  final bool disabled;
  final Widget? child;
  final Widget? icon;
  final Color? loadingColor;
  final double? loadingSize;
  final String? tooltip;
  final String? semanticLabel;

  bool get _isDisabled => disabled || onPressed == null || loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget button = SizedBox(
      // Text buttons shouldn't force full width by default
      width: _variant == _ButtonVariant.text
          ? width?.w
          : (width?.w ?? double.infinity),
      height: height?.h,
      child: switch (_variant) {
        _ButtonVariant.elevated => _buildElevated(context, theme),
        _ButtonVariant.outlined => _buildOutlined(context, theme),
        _ButtonVariant.text => _buildText(context, theme),
      },
    );

    // Wrap once, not in every branch
    if (semanticLabel != null) {
      button = Semantics(label: semanticLabel, child: button);
    }
    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  Widget _buildElevated(BuildContext context, ThemeData theme) {
    return ElevatedButton(
      style: theme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: backgroundColor != null
            ? WidgetStateProperty.all(backgroundColor)
            : null,
        foregroundColor: foregroundColor != null
            ? WidgetStateProperty.all(foregroundColor)
            : null,
        elevation: elevation != null
            ? WidgetStateProperty.all(elevation)
            : null,
      ),
      onPressed: _isDisabled ? null : onPressed,
      onLongPress: _isDisabled ? null : onLongPress,
      child: _buildContent(context),
    );
  }

  Widget _buildOutlined(BuildContext context, ThemeData theme) {
    return OutlinedButton(
      style: theme.outlinedButtonTheme.style?.copyWith(
        foregroundColor: foregroundColor != null
            ? WidgetStateProperty.all(foregroundColor)
            : null,
        side: borderColor != null || borderWidth != null
            ? WidgetStateProperty.all(
                BorderSide(
                  color: borderColor ?? theme.colorScheme.primary,
                  width: borderWidth ?? 1.0,
                ),
              )
            : null,
      ),
      onPressed: _isDisabled ? null : onPressed,
      onLongPress: _isDisabled ? null : onLongPress,
      child: _buildContent(context),
    );
  }

  Widget _buildText(BuildContext context, ThemeData theme) {
    return TextButton(
      style: theme.textButtonTheme.style?.copyWith(
        foregroundColor: foregroundColor != null
            ? WidgetStateProperty.all(foregroundColor)
            : null,
      ),
      onPressed: _isDisabled ? null : onPressed,
      onLongPress: _isDisabled ? null : onLongPress,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (loading) {
      final size = (loadingSize ?? 20.0).w;
      return SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(
            loadingColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (child != null) return child!;

    if (icon == null) {
      return Text(
        text!,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: textStyle,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon!,
        if (text != null) ...[
          SizedBox(width: 8.w),
          Text(
            text!,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textStyle,
          ),
        ],
      ],
    );
  }
}
