import 'package:material_ui/material_ui.dart';

import '/core/constants/global.dart';

class CheckerNavigatorObserver extends NavigatorObserver {
  void hideCurrentMessages() {
    GlobalConstants.scaffoldMessengerKey.currentState!
      ..hideCurrentSnackBar()
      ..hideCurrentMaterialBanner();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    hideCurrentMessages();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    hideCurrentMessages();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    hideCurrentMessages();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    hideCurrentMessages();
  }
}
