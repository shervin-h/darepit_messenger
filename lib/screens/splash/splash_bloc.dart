import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../core/resources/data_state.dart';
import '../../features/feature_messaging/domain/usecases/is_online_use_case.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SplashStartedEvent>((event, emit) async {
      emit(SplashLoadingState());
      await IsOnlineUseCase()().then((DataState<bool> dataState) {
        if (dataState is DataSuccess) {
          emit(SplashCompletedState());
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(SplashErrorState(dataState.error!));
        } else {
          emit(SplashInitial());
        }
      });
    });

  }
}
