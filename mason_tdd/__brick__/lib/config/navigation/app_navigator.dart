import 'package:go_router/go_router.dart';

import 'app_router.dart';

class AppNavigator {
  AppNavigator({GoRouter? router}) : _router = router ?? AppRouter.router;

  final GoRouter _router;

  void go(String location, {Object? extra}) =>
      _router.go(location, extra: extra);

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) => _router.goNamed(
    name,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
  );

  Future<T?> push<T>(String location, {Object? extra}) =>
      _router.push<T>(location, extra: extra);

  Future<T?> pushNamed<T>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) => _router.pushNamed<T>(
    name,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
  );

  void pushReplacement(String location, {Object? extra}) =>
      _router.pushReplacement(location, extra: extra);

  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) => _router.pushReplacementNamed(
    name,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
  );

  void pop<T>([T? result]) {
    if (canPop) {
      _router.pop<T>(result);
    }
  }

  bool get canPop => _router.canPop();
}
