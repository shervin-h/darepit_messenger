part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginStartedEvent extends LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String password;
  LoginButtonPressedEvent(this.email, this.password);
}
