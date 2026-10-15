import 'package:go_router/go_router.dart';

import '/core/constants/global.dart';
import '/core/show/checker_navigator_observer.dart';
import '/features/auth/login/login_initial_params.dart';
import '/features/auth/login/login_page.dart';
import '/features/bottom_nav/bottom_nav_initial_params.dart';
import '/features/bottom_nav/bottom_nav_page.dart';
import '/features/{{folder_name}}/{{initial_params_file_name}}';
import '/features/{{folder_name}}/{{page_file_name}}';
import '/features/splash/splash_initial_params.dart';
import '/features/splash/splash_page.dart';
import '/injection_container.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: GlobalConstants.navigatorKey,
    initialLocation: AppRoutes.splash,
    observers: [CheckerNavigatorObserver()],
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => SplashPage(
          cubit: getIt(
            param1:
                state.extra as SplashInitialParams? ??
                const SplashInitialParams(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) =>
            LoginPage(cubit: getIt(param1: state.extra as LoginInitialParams)),
      ),
      GoRoute(
        path: AppRoutes.bottomNav,
        builder: (context, state) => BottomNavPage(
          cubit: getIt(param1: state.extra as BottomNavInitialParams),
        ),
      ),
      GoRoute(
        path: AppRoutes.{{folder_name_camelCase}},
        builder: (context, state) =>
            {{class_name}}Page(cubit: getIt(param1: state.extra as {{class_name}}InitialParams)),
      ),
    ],
  );
}
