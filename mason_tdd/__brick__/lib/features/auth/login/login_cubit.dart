import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/show/show.dart';
import '/core/utils/app_url.dart';
import '/data/models/auth/login_model.dart';
import '/domain/repositories/network/network_base_api_service.dart';
import '/domain/usecases/user/user_use_cases.dart';
import '/features/{{folder_name}}/{{folder_name}}_initial_params.dart';
import 'login_initial_params.dart';
import 'login_navigator.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginInitialParams initialParams;
  final NetworkBaseApiService networkRepository;
  final UserUseCases userUseCases;
  final LoginNavigator navigator;
  final Show show;

  LoginCubit(
    this.initialParams,
    this.networkRepository,
    this.userUseCases,
    this.show,
    this.navigator,
  ) : super(LoginState.initial(initialParams: initialParams));

  Future<void> login({required LoginModel body}) async {
    emit(state.copyWith(isLoading: true));
    final login = await networkRepository.post<Map<String, dynamic>>(
      url: AppUrl.login,
      body: body.toJson(),
    );
    login.fold(
      (l) {
        emit(state.copyWith(isLoading: false));
        return show.showErrorSnackBar(l.error);
      },
      (userData) => userUseCases
          .execute(userData: userData)
          .then(
            (value) => value.fold(
              (l) {
                emit(state.copyWith(isLoading: false));
                return show.showErrorSnackBar(l.error);
              },
              (r) {
                emit(state.copyWith(isLoading: false));
                navigator.open{{class_name}}({{class_name}}InitialParams());
              },
            ),
          ),
    );
  }
}
