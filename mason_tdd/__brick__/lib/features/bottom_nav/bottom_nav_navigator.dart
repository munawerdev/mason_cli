import 'package:material_ui/material_ui.dart';

import '/config/navigation/app_navigator.dart';
import '/injection_container.dart';
import 'bottom_nav_initial_params.dart';
import 'bottom_nav_page.dart';

class BottomNavNavigator {
  BottomNavNavigator(this.navigator);
  @override
  late BuildContext context;
  @override
  AppNavigator navigator;
}

mixin BottomNavRoute {
  void openBottomNav(BottomNavInitialParams initialParams) => navigator.push(
    context: context,
    routeName: BottomNavPage(cubit: getIt(param1: initialParams)),
  );

  AppNavigator get navigator;

  BuildContext get context;
}
