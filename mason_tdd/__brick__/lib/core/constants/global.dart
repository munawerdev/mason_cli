import 'package:material_ui/material_ui.dart';

abstract class GlobalConstants {
  static const String themeKey = 'IS_DARK_THEME';
  // static Future mockRepoTime = Future.delayed(const Duration(seconds: 2));
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
