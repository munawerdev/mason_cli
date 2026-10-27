import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'bottom_nav_cubit.dart';
import 'bottom_nav_state.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key, required this.cubit});
  final BottomNavCubit cubit;

  @override
  State<BottomNavPage> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNavPage> {
  BottomNavCubit get cubit => widget.cubit;

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        final BottomNavState state = cubit.state;
        if (state.selectedIndex > 0) {
          cubit.setSelectedIndex(0); // Navigate to home tab
          return;
        }

        // Show exit dialog and wait for result
        final bool? shouldExit = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => const ExitAppDialog(
            text: 'Are you sure you want to exit the app?',
            label: 'Exit App',
            onPressed: SystemNavigator.pop,
          ),
        );

        // If user confirmed exit, close the app
        if (shouldExit ?? false) {
          await SystemNavigator.pop();
        }
      },
      child: const Scaffold(),
    );
  }
}

class ExitAppDialog extends StatelessWidget {
  const ExitAppDialog({
    super.key,
    required this.text,
    required this.label,
    required this.onPressed,
  });
  final String text;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(text),
    actions: <Widget>[TextButton(onPressed: onPressed, child: Text(label))],
  );
}
