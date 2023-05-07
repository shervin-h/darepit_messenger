part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterButtonPressedEvent extends RegisterEvent {
  final String email;
  final String password;

  RegisterButtonPressedEvent(this.email, this.password);
}
