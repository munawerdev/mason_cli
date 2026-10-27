enum NetworkFailureType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  validationError,
  tooManyRequests,
  internalServerError,
  badGateway,
  serviceUnavailable,
  badResponse,
  cancelled,
  noInternetConnection,
  formatError,
  unknown,
}

class NetworkFailure {
  const NetworkFailure({
    required this.error,
    this.type = NetworkFailureType.unknown,
    this.statusCode,
    this.additionalData,
  });
  final String error;
  final NetworkFailureType type;
  final int? statusCode;
  final Map<String, dynamic>? additionalData;

  @override
  String toString() => 'NetworkFailure(error: $error, type: $type, statusCode: $statusCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkFailure &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          type == other.type &&
          statusCode == other.statusCode;

  @override
  int get hashCode => error.hashCode ^ type.hashCode ^ statusCode.hashCode;
}
