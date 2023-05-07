part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashCompletedState extends SplashState {}

class SplashErrorState extends SplashState {
  final String errorMessage;
  SplashErrorState(this.errorMessage);
}
