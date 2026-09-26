import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'bottom_nav_cubit.dart';

class BottomNavPage extends StatefulWidget {
  final BottomNavCubit cubit;

  const BottomNavPage({super.key, required this.cubit});

  @override
  State<BottomNavPage> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNavPage> {
  BottomNavCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.navigator.context = context;
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final state = cubit.state;
        if (state.selectedIndex > 0) {
          cubit.setSelectedIndex(0); // Navigate to home tab
          return;
        }

        // Show exit dialog and wait for result
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => ExitAppDialog(
            text: 'Are you sure you want to exit the app?',
            label: 'Exit App',
            onPressed: SystemNavigator.pop,
          ),
        );

        // If user confirmed exit, close the app
        if (shouldExit == true) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(),
    );
  }
}

class ExitAppDialog extends StatelessWidget {
  final String text;
  final String label;
  final VoidCallback onPressed;
  const ExitAppDialog({
    super.key,
    required this.text,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(text),
    actions: [TextButton(onPressed: onPressed, child: Text(label))],
  );
}
