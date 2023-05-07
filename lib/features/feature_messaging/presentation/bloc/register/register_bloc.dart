import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../domain/usecases/sign_up_supabase_use_case.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<RegisterButtonPressedEvent>((event, emit) async {
      emit(RegisterLoadingState());
      await SignUpSupabaseUseCase()(event.email, event.password).then((DataState<User> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(RegisterCompletedState());
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(RegisterErrorState(dataState.error!));
        } else {
          emit(RegisterInitial());
        }
      });
    });
  }
}
