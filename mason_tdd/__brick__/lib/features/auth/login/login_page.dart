import 'package:material_ui/material_ui.dart';

import 'login_cubit.dart';

class LoginPage extends StatefulWidget {
  final LoginCubit cubit;

  const LoginPage({super.key, required this.cubit});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  LoginCubit get cubit => widget.cubit;

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox());
  }
}
