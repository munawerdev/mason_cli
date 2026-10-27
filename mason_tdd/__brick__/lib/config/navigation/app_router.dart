import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:go_router/go_router.dart';

import '/core/constants/global.dart';
import '/core/show/checker_navigator_observer.dart';
import '/features/auth/login/login_initial_params.dart';
import '/features/auth/login/login_page.dart';
import '/features/bottom_nav/bottom_nav_initial_params.dart';
import '/features/bottom_nav/bottom_nav_page.dart';
import '/features/splash/splash_initial_params.dart';
import '/features/splash/splash_page.dart';
import '/features/{{folder_name}}/{{initial_params_file_name}}';
import '/features/{{folder_name}}/{{page_file_name}}';
import '/injection_container.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: GlobalConstants.navigatorKey,
    initialLocation: AppRoutes.splash,
    observers: <NavigatorObserver>[CheckerNavigatorObserver()],
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) => SplashPage(
          cubit: getIt(param1: state.extra as SplashInitialParams? ?? const SplashInitialParams()),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) =>
            LoginPage(cubit: getIt(param1: state.extra! as LoginInitialParams)),
      ),
      GoRoute(
        path: AppRoutes.bottomNav,
        builder: (BuildContext context, GoRouterState state) =>
            BottomNavPage(cubit: getIt(param1: state.extra! as BottomNavInitialParams)),
      ),
       GoRoute(
        path: AppRoutes.{{folder_name_camelCase}},
        builder: (BuildContext context, GoRouterState state) =>
            {{class_name}}Page(cubit: getIt(param1: state.extra! as {{class_name}}InitialParams)),
      ),
    ],
  );
}
