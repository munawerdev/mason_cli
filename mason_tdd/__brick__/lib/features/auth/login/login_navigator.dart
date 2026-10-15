import '/config/navigation/app_navigator.dart';
import '/config/navigation/app_routes.dart';
import '/features/{{folder_name}}/{{folder_name}}_navigator.dart';
import 'login_initial_params.dart';

class LoginNavigator with {{class_name}}Route {
  LoginNavigator(this.navigator);

  @override
  final AppNavigator navigator;
}

mixin LoginRoute {
  void openLogin(
    LoginInitialParams initialParams) => navigator.go(AppRoutes.login, extra: initialParams);

  AppNavigator get navigator;
}
