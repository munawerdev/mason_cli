import 'package:material_ui/material_ui.dart';

import 'login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.cubit});
  final LoginCubit cubit;

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
