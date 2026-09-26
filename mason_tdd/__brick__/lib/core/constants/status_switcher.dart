import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '/config/response/api_response.dart';
import '/config/response/status.dart';
import '/core/utils/error_display_helper.dart';
import '/core/utils/extensions.dart';
import '/core/widgets/app_button.dart';
import '/domain/failures/network/network_failure.dart';

/// Configuration class for customizing StatusSwitcher appearance and behavior
class StatusSwitcherConfig {
  final bool showRetryButton;
  final String retryButtonText;
  final IconData errorIcon;
  final String defaultNoDataTitle;

  const StatusSwitcherConfig({
    this.showRetryButton = true,
    this.retryButtonText = 'Try Again',
    this.errorIcon = Icons.sentiment_dissatisfied_rounded,
    this.defaultNoDataTitle = "There's nothing here",
  });

  StatusSwitcherConfig copyWith({
    bool? showRetryButton,
    String? retryButtonText,
    IconData? errorIcon,
    String? defaultNoDataTitle,
  }) {
    return StatusSwitcherConfig(
      showRetryButton: showRetryButton ?? this.showRetryButton,
      retryButtonText: retryButtonText ?? this.retryButtonText,
      errorIcon: errorIcon ?? this.errorIcon,
      defaultNoDataTitle: defaultNoDataTitle ?? this.defaultNoDataTitle,
    );
  }
}

/// Main StatusSwitcher widget with improved architecture
class StatusSwitcher<T> extends StatelessWidget {
  final ApiResponse<T> response;
  final Widget Function(BuildContext context)? onLoading;
  final Widget Function(BuildContext context, NetworkFailure error)? onError;
  final Widget Function(BuildContext context, T data) onCompleted;
  final VoidCallback? onRetry;
  final StatusSwitcherConfig config;
  final String? customErrorTitle;
  final String? customNoDataTitle;
  final String? customNoDataSubtitle;

  const StatusSwitcher({
    super.key,
    required this.response,
    this.onLoading,
    this.onError,
    required this.onCompleted,
    this.onRetry,
    this.config = const StatusSwitcherConfig(),
    this.customErrorTitle,
    this.customNoDataTitle,
    this.customNoDataSubtitle,
  });

  @override
  Widget build(BuildContext context) => _buildStatusWidget(context);

  Widget _buildStatusWidget(BuildContext context) {
    switch (response.status) {
      case Status.LOADING:
        return onLoading?.call(context) ?? _DefaultLoadingWidget();
      case Status.ERROR:
        return onError?.call(context, response.error) ??
            _DefaultErrorWidget(
              failure: response.error,
              onRetry: onRetry,
              config: config,
              customTitle: customErrorTitle,
            );
      case Status.COMPLETED:
        if (_isDataEmpty(response.data)) {
          return _DefaultNoDataWidget(
            config: config,
            title: customNoDataTitle,
            subtitle: customNoDataSubtitle,
          );
        }
        return onCompleted(context, response.data);
      default:
        return const SizedBox.shrink();
    }
  }

  bool _isDataEmpty(T? data) {
    if (data == null) return true;
    if (data is Iterable) return data.isEmpty;
    if (data is String) return data.isEmpty;
    if (data is Map) return data.isEmpty;

    return false;
  }
}

/// Default loading widget component
class _DefaultLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator.adaptive());
}

/// Professional error widget with better UX
class _DefaultErrorWidget extends StatefulWidget {
  final NetworkFailure failure;
  final VoidCallback? onRetry;
  final StatusSwitcherConfig config;
  final String? customTitle;

  const _DefaultErrorWidget({
    required this.failure,
    this.onRetry,
    required this.config,
    this.customTitle,
  });

  @override
  State<_DefaultErrorWidget> createState() => _DefaultErrorWidgetState();
}

class _DefaultErrorWidgetState extends State<_DefaultErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ErrorDisplayProperties get _errorProperties =>
      ErrorDisplayHelper.getDisplayProperties(context, widget.failure);

  @override
  Widget build(BuildContext context) {
    final shouldShowRetry =
        widget.config.showRetryButton && widget.onRetry != null;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error Icon with animated container
                _buildErrorIcon(_errorProperties.color),

                24.verticalSpace,

                // Status code badge (if available)
                if (widget.failure.statusCode != null)
                  _buildStatusBadge(_errorProperties.color),

                if (widget.failure.statusCode != null) 12.verticalSpace,

                // Error title
                _buildErrorTitle(context),

                16.verticalSpace,

                // Error message
                _buildErrorMessage(context, _errorProperties.color),

                if (shouldShowRetry) ...[
                  32.verticalSpace,
                  _buildRetryButton(context, _errorProperties.color),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon(Color errorColor) => Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: errorColor.withValues(alpha: 0.1),
      border: Border.all(color: errorColor.withValues(alpha: 0.3), width: 2),
    ),
    child: Icon(_errorProperties.icon, size: 36.sp, color: errorColor),
  );

  Widget _buildStatusBadge(Color errorColor) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: errorColor.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: errorColor.withValues(alpha: 0.3), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline_rounded, size: 14.sp, color: errorColor),
        6.horizontalSpace,
        Text(
          'Error ${widget.failure.statusCode}',
          style: context.textTheme.labelMedium,
        ),
      ],
    ),
  );

  Widget _buildErrorTitle(BuildContext context) => Text(
    widget.customTitle ?? _errorProperties.title,
    style: context.textTheme.headlineSmall,
    textAlign: TextAlign.center,
  );

  Widget _buildErrorMessage(BuildContext context, Color errorColor) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: context.theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          widget.failure.error,

          style: context.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildRetryButton(BuildContext context, Color errorColor) =>
      AppButton(onPressed: widget.onRetry, text: widget.config.retryButtonText);
}

/// Default no data widget component
class _DefaultNoDataWidget extends StatelessWidget {
  final StatusSwitcherConfig config;
  final String? title;
  final String? subtitle;

  const _DefaultNoDataWidget({required this.config, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? config.defaultNoDataTitle,
            style: context.textTheme.titleMedium,
          ),
          if (subtitle != null) ...[
            11.verticalSpace,
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    ),
  );
}

/// Extension for easier StatusSwitcher usage
extension StatusSwitcherExtension<T> on ApiResponse<T> {
  Widget toWidget({
    required Widget Function(BuildContext context, T data) onCompleted,
    Widget Function(BuildContext context)? onLoading,
    Widget Function(BuildContext context, NetworkFailure error)? onError,
    VoidCallback? onRetry,
    StatusSwitcherConfig config = const StatusSwitcherConfig(),
    String? customErrorTitle,
    String? customNoDataTitle,
    String? customNoDataSubtitle,
  }) {
    return StatusSwitcher<T>(
      response: this,
      onCompleted: onCompleted,
      onLoading: onLoading,
      onError: onError,
      onRetry: onRetry,
      config: config,
      customErrorTitle: customErrorTitle,
      customNoDataTitle: customNoDataTitle,
      customNoDataSubtitle: customNoDataSubtitle,
    );
  }
}
