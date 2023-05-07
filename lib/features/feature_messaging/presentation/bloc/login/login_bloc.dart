import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/sign_in_supabase_use_case.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/resources/data_state.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoginStartedEvent>((event, emit) {
      emit(LoginInitial());
    });

    on<LoginButtonPressedEvent>((event, emit) async {
      emit(LoginLoadingState());
      await SignInSupabaseUseCase()(event.email, event.password).then((DataState<User> dataState) {
        if (dataState is DataSuccess) {
          emit(LoginCompletedState());
        }
        if (dataState is DataFailed && dataState.error != null) {
          emit(LoginErrorState(dataState.error!));
        }
      });
    });
  }
}
