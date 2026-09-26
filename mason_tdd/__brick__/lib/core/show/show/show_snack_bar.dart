import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';

import '/core/constants/global.dart';
import '/core/utils/error_display_helper.dart';
import '/domain/failures/network/network_failure.dart';

/// An animated text widget for SnackBars
class AnimatedSnackBarContent extends StatefulWidget {
  final String message;

  const AnimatedSnackBarContent({super.key, required this.message});

  @override
  State<AnimatedSnackBarContent> createState() =>
      _AnimatedSnackBarContentState();
}

class _AnimatedSnackBarContentState extends State<AnimatedSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          widget.message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

void _showAppSnackBar(SnackBar snackBar) {
  final messenger = GlobalConstants.scaffoldMessengerKey.currentState;
  if (messenger == null) return;

  messenger.clearSnackBars();
  messenger.showSnackBar(snackBar);
}

mixin ShowSnackBarSuccess {
  void showSuccessSnackBar(String message) {
    _showAppSnackBar(
      SnackBar(
        content: AnimatedSnackBarContent(message: message),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
        duration: const Duration(seconds: 3),
        persist: false,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

mixin ShowSnackBarError {
  /// Shows error snackbar with NetworkFailure
  void showNetworkErrorSnackBar(BuildContext context, NetworkFailure failure) {
    final properties = ErrorDisplayHelper.getDisplayProperties(
      context,
      failure,
    );

    _showAppSnackBar(
      SnackBar(
        content: _ErrorSnackBarContent(
          message: properties.title,
          icon: properties.icon,
          color: properties.color,
        ),
        // backgroundColor: properties.backgroundColor,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          side: BorderSide(
            color: properties.color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
        duration: const Duration(seconds: 3),
        persist: false,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: properties.color,
          onPressed: () {},
        ),
      ),
    );
  }

  /// Shows error snackbar with simple string message (backward compatibility)
  void showErrorSnackBar(String message) {
    _showAppSnackBar(
      SnackBar(
        content: AnimatedSnackBarContent(message: message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.r),
          side: BorderSide(color: Colors.red.withOpacity(0.3), width: 1.5),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
        duration: const Duration(seconds: 3),
        persist: false,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

/// Enhanced snackbar content with icon for errors
class _ErrorSnackBarContent extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;

  const _ErrorSnackBarContent({
    required this.message,
    required this.icon,
    required this.color,
  });

  @override
  State<_ErrorSnackBarContent> createState() => _ErrorSnackBarContentState();
}

class _ErrorSnackBarContentState extends State<_ErrorSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: widget.color, size: 20.sp),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
