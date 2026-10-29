import 'package:flutter_bloc/flutter_bloc.dart';

import '/domain/usecases/local/check_for_existing_user_use_case.dart';
import '/domain/usecases/theme/get_theme_use_case.dart';
import '/features/auth/login/login_initial_params.dart';
import '/features/splash/splash_navigator.dart';
import '/features/{{folder_name}}/{{folder_name}}_initial_params.dart';
import 'splash_initial_params.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {

  SplashCubit(this.initialParams, this.navigator,
      this.checkForExistingUserUseCase, this.getThemeUseCase)
      : super(SplashState.initial(initialParams: initialParams));
  final SplashInitialParams initialParams;
  final SplashNavigator navigator;
  final CheckForExistingUserUseCase checkForExistingUserUseCase;
  final GetThemeUseCase getThemeUseCase;

  void checkUser() {
    getThemeUseCase.execute();

    emit(state.copyWith(isloading: true));
    checkForExistingUserUseCase.execute().then(
          (value) => value.fold(
            (l) {
              emit(state.copyWith(isloading: false));
              return navigator.openLogin(const LoginInitialParams());
            },
            (r) {
              emit(state.copyWith(isloading: false));
              return navigator.open{{class_name}}(const {{class_name}}InitialParams());
            },
          ),
        );
  }
}
