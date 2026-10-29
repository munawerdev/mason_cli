import '/features/splash/splash_initial_params.dart';

class SplashState {
  SplashState({required this.isloading});
  factory SplashState.initial({required SplashInitialParams initialParams}) => SplashState(isloading: false);
  final bool isloading;
  SplashState copyWith({bool? isloading}) =>
      SplashState(isloading: isloading ?? this.isloading);
}
