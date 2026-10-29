import 'dart:io';

import 'package:dio/dio.dart';

import '/domain/failures/network/network_failure.dart';

class ApiErrorHandler {
  const ApiErrorHandler();

  NetworkFailure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return NetworkFailure(
          error: 'Connection timeout. Please check your internet connection.',
          type: NetworkFailureType.connectionTimeout,
          statusCode: error.response?.statusCode,
          additionalData: _extractAdditionalData(error),
        );
      case DioExceptionType.sendTimeout:
        return NetworkFailure(
          error: 'Send timeout. Request took too long to send.',
          type: NetworkFailureType.sendTimeout,
          statusCode: error.response?.statusCode,
          additionalData: _extractAdditionalData(error),
        );
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return NetworkFailure(
          error: 'Receive timeout. Server took too long to respond.',
          type: NetworkFailureType.receiveTimeout,
          statusCode: error.response?.statusCode,
          additionalData: _extractAdditionalData(error),
        );
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.connectionError:
        return _handleConnectionError(error);
      case DioExceptionType.cancel:
        return NetworkFailure(
          error: 'Request was cancelled',
          type: NetworkFailureType.cancelled,
          additionalData: _extractAdditionalData(error),
        );
      case DioExceptionType.badCertificate:
        return NetworkFailure(
          error:
              'SSL certificate error. Please check your connection security.',
          additionalData: _extractAdditionalData(error),
        );
      case DioExceptionType.unknown:
        return _handleUnknownError(error);
    }
  }

  NetworkFailure _handleBadResponse(DioException error) {
    final int? statusCode = error.response?.statusCode;
    final dynamic responseData = error.response?.data;
    final String errorMessage = _extractErrorMessage(responseData);

    switch (statusCode) {
      case 400:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? 'Bad request: $errorMessage'
              : 'Bad request. Please check your input.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 401:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? errorMessage
              : 'Unauthorized access. Please login again.',
          type: NetworkFailureType.unauthorized,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 403:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? errorMessage
              : "Access forbidden. You don't have permission.",
          type: NetworkFailureType.forbidden,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 404:
        return NetworkFailure(
          error: errorMessage.isNotEmpty ? errorMessage : 'Resource not found',
          type: NetworkFailureType.notFound,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 408:
        return NetworkFailure(
          error: 'Request timeout. Please try again.',
          type: NetworkFailureType.connectionTimeout,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 409:
        return NetworkFailure(
          error: errorMessage.isNotEmpty ? 'Conflict: $errorMessage' : 'Resource conflict. The request conflicts with the current state.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 410:
        return NetworkFailure(
          error: 'Resource is no longer available.',
          type: NetworkFailureType.notFound,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 413:
        return NetworkFailure(
          error: 'Request entity too large. Please reduce the size of your request.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 414:
        return NetworkFailure(
          error: 'Request URI too long.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 415:
        return NetworkFailure(
          error: 'Unsupported media type.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 422:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? 'Validation error: $errorMessage'
              : 'Validation error. Please check your input.',
          type: NetworkFailureType.validationError,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 423:
        return NetworkFailure(
          error: 'Resource is locked.',
          type: NetworkFailureType.forbidden,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 424:
        return NetworkFailure(
          error: 'Failed dependency.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 428:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? 'Precondition required: $errorMessage'
              : 'Precondition required.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 429:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? errorMessage
              : 'Too many requests. Please try again later.',
          type: NetworkFailureType.tooManyRequests,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 431:
        return NetworkFailure(
          error: 'Request header fields too large.',
          type: NetworkFailureType.badRequest,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 500:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? 'Server error: $errorMessage'
              : 'Internal server error. Please try again later.',
          type: NetworkFailureType.internalServerError,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 501:
        return NetworkFailure(
          error: 'Not implemented. The server does not support this operation.',
          type: NetworkFailureType.badResponse,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 502:
        return NetworkFailure(
          error: 'Bad gateway. Server is temporarily unavailable.',
          type: NetworkFailureType.badGateway,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 503:
        return NetworkFailure(
          error: errorMessage.isNotEmpty
              ? errorMessage
              : 'Service unavailable. Please try again later.',
          type: NetworkFailureType.serviceUnavailable,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 504:
        return NetworkFailure(
          error:
              'Gateway timeout. The server did not receive a timely response.',
          type: NetworkFailureType.badGateway,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 505:
        return NetworkFailure(
          error: 'HTTP version not supported.',
          type: NetworkFailureType.badResponse,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 507:
        return NetworkFailure(
          error: 'Insufficient storage.',
          type: NetworkFailureType.internalServerError,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 508:
        return NetworkFailure(
          error: 'Loop detected.',
          type: NetworkFailureType.badResponse,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 510:
        return NetworkFailure(
          error: 'Not extended.',
          type: NetworkFailureType.badResponse,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      case 511:
        return NetworkFailure(
          error: 'Network authentication required.',
          type: NetworkFailureType.unauthorized,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return NetworkFailure(
            error: errorMessage.isNotEmpty
                ? errorMessage
                : 'Client error occurred',
            type: NetworkFailureType.badRequest,
            statusCode: statusCode,
            additionalData: _normalizeAdditionalData(responseData),
          );
        } else if (statusCode != null && statusCode >= 500) {
          return NetworkFailure(
            error: errorMessage.isNotEmpty
                ? errorMessage
                : 'Server error occurred',
            type: NetworkFailureType.internalServerError,
            statusCode: statusCode,
            additionalData: _normalizeAdditionalData(responseData),
          );
        }
        return NetworkFailure(
          error: errorMessage.isNotEmpty ? errorMessage : 'Request failed',
          type: NetworkFailureType.badResponse,
          statusCode: statusCode,
          additionalData: _normalizeAdditionalData(responseData),
        );
    }
  }

  NetworkFailure _handleConnectionError(DioException error) {
    if (error.error is SocketException) {
      final SocketException socketError = error.error! as SocketException;
      return NetworkFailure(
        error: socketError.message.isNotEmpty
            ? 'Connection failed: ${socketError.message}'
            : 'No internet connection. Please check your network.',
        type: NetworkFailureType.noInternetConnection,
        additionalData: _extractAdditionalData(error),
      );
    }

    if (error.error is HttpException) {
      return NetworkFailure(
        error: 'HTTP error: ${error.error}',
        type: NetworkFailureType.badResponse,
        additionalData: _extractAdditionalData(error),
      );
    }

    return NetworkFailure(
      error: 'Connection error. Please check your internet connection.',
      type: NetworkFailureType.noInternetConnection,
      additionalData: _extractAdditionalData(error),
    );
  }

  NetworkFailure _handleUnknownError(DioException error) {
    if (error.error is SocketException) {
      final SocketException socketError = error.error! as SocketException;
      return NetworkFailure(
        error: socketError.message.isNotEmpty
            ? 'Network error: ${socketError.message}'
            : 'No internet connection. Please check your network.',
        type: NetworkFailureType.noInternetConnection,
        additionalData: _extractAdditionalData(error),
      );
    }

    if (error.error is HttpException) {
      return NetworkFailure(
        error: 'HTTP error: ${error.error}',
        type: NetworkFailureType.badResponse,
        additionalData: _extractAdditionalData(error),
      );
    }

    if (error.error is FormatException) {
      return NetworkFailure(
        error: 'Invalid response format from server.',
        type: NetworkFailureType.formatError,
        additionalData: _extractAdditionalData(error),
      );
    }

    if (error.error is TypeError) {
      return NetworkFailure(
        error: 'Type error: ${error.error}',
        type: NetworkFailureType.formatError,
        additionalData: _extractAdditionalData(error),
      );
    }

    final String errorString =
        error.error?.toString() ?? error.message ?? 'Unknown error';
    return NetworkFailure(
      error: 'Unknown network error: $errorString',
      additionalData: _extractAdditionalData(error),
    );
  }

  /// Extracts error message from various response data formats
  String _extractErrorMessage(dynamic responseData) {
    if (responseData == null) {
      return '';
    }

    // Handle String response
    if (responseData is String) {
      try {
        // Try to parse as JSON if it's a JSON string
        final String decoded = responseData.trim();
        if (decoded.startsWith('{') || decoded.startsWith('[')) {
          // It might be JSON, but we'll return it as is for now
          return decoded;
        }
        return decoded;
      } catch (_) {
        return responseData;
      }
    }

    // Handle Map response
    if (responseData is Map<String, dynamic>) {
      // Try common error message fields
      final dynamic message =
          responseData['message'] ??
          responseData['error'] ??
          responseData['error_message'] ??
          responseData['msg'] ??
          responseData['detail'] ??
          responseData['details'] ??
          responseData['description'] ??
          responseData['reason'] ??
          responseData['status_message'];

      if (message != null) {
        if (message is String) {
          return message;
        }
        if (message is List) {
          return message.map((dynamic e) => e.toString()).join(', ');
        }
        return message.toString();
      }

      // Handle nested error objects
      if (responseData['errors'] != null) {
        return _extractErrorsFromMap(responseData['errors']);
      }

      // Handle validation errors structure
      if (responseData['validation'] != null) {
        return _extractErrorsFromMap(responseData['validation']);
      }

      // If no message found, try to stringify the map
      if (responseData.isEmpty) {
        return '';
      }
      return responseData.toString();
    }

    // Handle List response
    if (responseData is List) {
      if (responseData.isEmpty) {
        return '';
      }
      return responseData.map((dynamic e) => e.toString()).join(', ');
    }

    return responseData.toString();
  }

  /// Extracts error messages from errors map/object
  String _extractErrorsFromMap(dynamic errors) {
    if (errors == null) {
      return '';
    }

    if (errors is String) {
      return errors;
    }

    if (errors is List) {
      return errors.map((dynamic e) => e.toString()).join(', ');
    }

    if (errors is Map) {
      final List<String> errorMessages = <String>[];
      errors.forEach((dynamic key, dynamic value) {
        if (value is List) {
          errorMessages.add('$key: ${value.join(", ")}');
        } else if (value is Map) {
          errorMessages.add('$key: ${_extractErrorsFromMap(value)}');
        } else {
          errorMessages.add('$key: $value');
        }
      });
      return errorMessages.join('; ');
    }

    return errors.toString();
  }

  /// Normalizes additional data to Map<String, dynamic> format
  Map<String, dynamic>? _normalizeAdditionalData(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    if (data is String) {
      try {
        // Try to parse JSON string
        return <String, dynamic>{'raw': data};
      } catch (_) {
        return <String, dynamic>{'raw': data};
      }
    }

    if (data is List) {
      return <String, dynamic>{'items': data};
    }

    return <String, dynamic>{'data': data.toString()};
  }

  /// Extracts additional data from DioException
  Map<String, dynamic>? _extractAdditionalData(DioException error) {
    final dynamic responseData = error.response?.data;
    return _normalizeAdditionalData(responseData);
  }
}
