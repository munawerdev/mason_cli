import 'package:material_ui/material_ui.dart';

class SlideFromRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget widget;

  SlideFromRightPageRoute({required this.widget})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
      );
}

class SlideFromLeftPageRoute<T> extends PageRouteBuilder<T> {
  final Widget widget;

  SlideFromLeftPageRoute({required this.widget})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              const begin = Offset(-1.0, 0.0); // Start from the left
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
      );
}

class SlideFromBottomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget widget;

  SlideFromBottomPageRoute({required this.widget})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              const begin = Offset(0.0, 1.0); // Start from bottom
              const end = Offset.zero; // End at current position
              const curve = Curves.ease;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
      );
}

class SlideFromTopPageRoute<T> extends PageRouteBuilder<T> {
  final Widget widget;

  SlideFromTopPageRoute({required this.widget})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              const begin = Offset(0.0, -1.0); // Start from top
              const end = Offset.zero; // End at current position
              const curve = Curves.ease;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
      );
}
