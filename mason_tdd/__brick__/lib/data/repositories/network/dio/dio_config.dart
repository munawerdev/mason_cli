import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '/core/utils/app_url.dart';
import '/data/datasources/user/user_data_sources.dart';
import '/data/models/user/user_info_store_model.dart';
import '/domain/repositories/local/local_storage_base_api_service.dart';
import '../../../../domain/failures/local/set_local_storage_failure.dart';

class DioConfig {
  static Dio createDio({
    required UserDataSources userDataSources,
    required LocalStorageBaseApiService localStorageRepository,
  }) {
    final Dio dio = Dio();

    // Base configuration
    dio.options = BaseOptions(
      // baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: <String, dynamic>{'Content-Type': 'application/json'},
    );

    // Separate dio for refresh token calls. It shares the same base options
    // and logger but does NOT include the AuthInterceptor to avoid recursion.
    final Dio refreshDio = Dio()
      ..options = dio.options
      ..interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printErrorHeaders: false,
            printErrorMessage: false,
          ),
        ),
      );

    // Add interceptors in order
    dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(
        userDataSources: userDataSources,
        localStorageRepository: localStorageRepository,
        refreshDio: refreshDio,
      ),
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printErrorHeaders: false,
          printErrorMessage: false,
        ),
      ),
    ]);

    return dio;
  }
}

/// Attaches the access token to every request and retries once on 401.
///
/// Uses a lock so that concurrent 401 responses only trigger a single
/// refresh-token request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._userDataSources,
    required this._localStorageRepository,
    required this._refreshDio,
  });
  final UserDataSources _userDataSources;
  final LocalStorageBaseApiService _localStorageRepository;
  final Dio _refreshDio;

  bool _isRefreshing = false;
  final List<Completer<String?>> _pendingTokenRefresh = <Completer<String?>>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String token = _userDataSources.state.accessToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final String? token = await _refreshTokenWithLock();
    if (token == null || token.isEmpty) {
      return handler.next(err);
    }

    final RequestOptions requestOptions = err.requestOptions;
    requestOptions.headers['Authorization'] = 'Bearer $token';

    try {
      final Response<dynamic> response = await _retry(requestOptions);
      return handler.resolve(response);
    } catch (e) {
      log('Retry after token refresh failed: $e');
      return handler.next(err);
    }
  }

  Future<String?> _refreshTokenWithLock() async {
    if (!_isRefreshing) {
      _isRefreshing = true;
      final String? token = await _refreshToken();
      _isRefreshing = false;

      // Complete all pending requests waiting for the new token
      for (final Completer<String?> completer in _pendingTokenRefresh) {
        completer.complete(token);
      }
      _pendingTokenRefresh.clear();
      return token;
    }

    // Another request is already refreshing the token. Wait for it.
    final Completer<String?> completer = Completer<String?>();
    _pendingTokenRefresh.add(completer);
    return completer.future;
  }

  Future<String?> _refreshToken() async {
    final String refreshToken = _userDataSources.state.refreshToken;
    if (refreshToken.isEmpty) {
      log('No refresh token available');
      return null;
    }

    try {
      final Response<dynamic> refreshResponse = await _refreshDio.post(
        AppUrl.refreshToken,
        data: <String, String>{'refreshToken': refreshToken},
        options: Options(
          headers: <String, dynamic>{'Content-Type': 'application/json'},
        ),
      );

      log('Refresh Token Response: ${refreshResponse.data}');

      if (refreshResponse.statusCode != 200) {
        log('Failed to refresh token: ${refreshResponse.data}');
        return null;
      }

      final Map<String, dynamic> newTokensJson =
          refreshResponse.data as Map<String, dynamic>;
      final UserInfoStoreModel newUserData = UserInfoStoreModel.fromJson(
        newTokensJson,
      );
      final String newAccessToken = newUserData.accessToken;

      if (newAccessToken.isEmpty) {
        log('Refresh token response did not contain an access token');
        return null;
      }

      // Persist and update in-memory session
      final Either<SetLocalStorageFailure, bool> result =
          await _localStorageRepository.setUserData(
            userInfoStoreModel: newUserData,
          );
      result.fold(
        (SetLocalStorageFailure l) => log('Failed to save user data: $l'),
        (bool r) => _userDataSources.setUserDataSources(
          userInfoStoreModel: newUserData,
        ),
      );

      return newAccessToken;
    } catch (e) {
      log('Token refresh failed: $e');
      return null;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    // Use a clean Dio instance to retry the original request. This avoids
    // re-running the auth interceptor on the retry.
    final Dio retryDio = Dio()..options = _refreshDio.options;
    final Response<dynamic> retriedResponse = await retryDio.fetch(
      requestOptions,
    );
    log('Retried Response: ${retriedResponse.data}');
    return retriedResponse;
  }
}
