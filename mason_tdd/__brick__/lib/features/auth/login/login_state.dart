import 'login_initial_params.dart';

class LoginState {
  LoginState({required this.isLoading});
  factory LoginState.initial({required LoginInitialParams initialParams}) =>
      LoginState(isLoading: false);
  final bool isLoading;
  LoginState copyWith({bool? isLoading}) => LoginState(isLoading: isLoading ?? this.isLoading);
}
