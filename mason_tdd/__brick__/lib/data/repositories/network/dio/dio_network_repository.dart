import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '/data/datasources/user/user_data_sources.dart';
import '/data/repositories/network/errors/api_error_handler.dart';
import '/domain/failures/network/network_failure.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';
import '/domain/repositories/network/network_base_api_service.dart';
import 'dio_config.dart';

class DioNetworkRepository implements NetworkBaseApiService {
  DioNetworkRepository(this._userDataSources, this._localStorageRepository, this._apiErrorHandler) {
    _dio = DioConfig.createDio(
      userDataSources: _userDataSources,
      localStorageRepository: _localStorageRepository,
    );
  }
  final UserDataSources _userDataSources;
  final LocalStorageBaseApiService _localStorageRepository;
  final ApiErrorHandler _apiErrorHandler;
  late final Dio _dio;

  @override
  Future<Either<NetworkFailure, T>> get<T>({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest<T>(
      () => _dio.get(
        url,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, T>> post<T>({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _executeRequest<T>(
      () => _dio.post(
        url,
        data: isFormData ? FormData.fromMap(body) : body,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          headers: headers,
          contentType: isFormData ? Headers.multipartFormDataContentType : Headers.jsonContentType,
        ),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, T>> patch<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _executeRequest<T>(
      () => _dio.patch(
        url,
        data: isFormData && body != null ? FormData.fromMap(body) : body,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          headers: headers,
          contentType: isFormData ? Headers.multipartFormDataContentType : Headers.jsonContentType,
        ),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, T>> put<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    bool isFormData = false,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    return _executeRequest<T>(
      () => _dio.put(
        url,
        data: isFormData && body != null ? FormData.fromMap(body) : body,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: Options(
          headers: headers,
          contentType: isFormData ? Headers.multipartFormDataContentType : Headers.jsonContentType,
        ),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, T>> delete<T>({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _executeRequest<T>(
      () => _dio.delete(
        url,
        data: body,
        cancelToken: cancelToken,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<Either<NetworkFailure, T>> upload<T>({
    required String url,
    required String filePath,
    required String fileName,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        ...?data,
      });

      return await _executeRequest<T>(
        () => _dio.post(
          url,
          data: formData,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          options: Options(headers: headers),
        ),
      );
    } catch (e) {
      return left(NetworkFailure(error: 'File upload preparation failed: $e'));
    }
  }

  /// Common method to execute requests and handle errors
  Future<Either<NetworkFailure, T>> _executeRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    try {
      final Response<dynamic> response = await request();
      return right(response.data as T);
    } on DioException catch (e) {
      return left(_apiErrorHandler.handleDioError(e));
    } catch (e) {
      return left(NetworkFailure(error: 'Unexpected error: $e'));
    }
  }
}
