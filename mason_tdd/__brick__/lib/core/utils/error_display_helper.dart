import 'package:material_ui/material_ui.dart';

import '/core/utils/extensions.dart';
import '/domain/failures/network/network_failure.dart';

/// Helper class for displaying errors in UI with type-specific styling
class ErrorDisplayHelper {
  /// Gets error-specific UI properties
  static ErrorDisplayProperties getDisplayProperties(
    BuildContext context,
    NetworkFailure failure,
  ) {
    switch (failure.type) {
      case NetworkFailureType.noInternetConnection:
        return ErrorDisplayProperties(
          icon: Icons.wifi_off_rounded,
          title: 'No Internet Connection',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.connectionTimeout:
      case NetworkFailureType.sendTimeout:
      case NetworkFailureType.receiveTimeout:
        return ErrorDisplayProperties(
          icon: Icons.timer_off_rounded,
          title: 'Connection Timeout',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.unauthorized:
        return ErrorDisplayProperties(
          icon: Icons.lock_outline_rounded,
          title: 'Authentication Required',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.forbidden:
        return ErrorDisplayProperties(
          icon: Icons.block_rounded,
          title: 'Access Denied',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.notFound:
        return ErrorDisplayProperties(
          icon: Icons.search_off_rounded,
          title: 'Not Found',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.validationError:
        return ErrorDisplayProperties(
          icon: Icons.error_outline_rounded,
          title: 'Validation Error',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.tooManyRequests:
        return ErrorDisplayProperties(
          icon: Icons.hourglass_empty_rounded,
          title: 'Too Many Requests',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.internalServerError:
      case NetworkFailureType.badGateway:
      case NetworkFailureType.serviceUnavailable:
        return ErrorDisplayProperties(
          icon: Icons.cloud_off_rounded,
          title: 'Server Error',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.badRequest:
        return ErrorDisplayProperties(
          icon: Icons.report_problem_rounded,
          title: 'Invalid Request',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.badResponse:
      case NetworkFailureType.formatError:
        return ErrorDisplayProperties(
          icon: Icons.broken_image_rounded,
          title: 'Invalid Response',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.cancelled:
        return ErrorDisplayProperties(
          icon: Icons.cancel_outlined,
          title: 'Request Cancelled',
          color: context.theme.colorScheme.primary,
        );
      case NetworkFailureType.unknown:
        return ErrorDisplayProperties(
          icon: Icons.sentiment_dissatisfied_rounded,
          title: 'Something Went Wrong',
          color: context.theme.colorScheme.primary,
        );
    }
  }
}

/// Properties for error display
class ErrorDisplayProperties {
  final IconData icon;
  final String title;
  final Color color;

  const ErrorDisplayProperties({
    required this.icon,
    required this.title,
    required this.color,
  });
}
