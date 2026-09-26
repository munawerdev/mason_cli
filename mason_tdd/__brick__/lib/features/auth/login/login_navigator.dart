import 'package:material_ui/material_ui.dart';
import '/features/{{folder_name}}/{{folder_name}}_navigator.dart';
import 'login_initial_params.dart';
import 'login_page.dart';
import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import '/config/navigation/transition_type.dart';

class LoginNavigator with {{class_name}}Route{
  LoginNavigator(this.navigator);
  @override
  late BuildContext context;

  @override
  AppNavigator navigator;
}

mixin LoginRoute {
 void openLogin(LoginInitialParams initialParams) =>
navigator.pushAndRemoveUntil(
        context: context,
        routeName: LoginPage(cubit: getIt(param1: initialParams)),
        transitionType: TransitionType.slideFromLeft,
        predicate: (route) => false);


  AppNavigator get navigator;

  BuildContext get context;
}
