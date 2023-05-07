part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterCompletedState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}
