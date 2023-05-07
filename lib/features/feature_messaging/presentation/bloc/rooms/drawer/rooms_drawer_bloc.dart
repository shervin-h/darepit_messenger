import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/pick_profile_image_use_case.dart';
import 'package:meta/meta.dart';

part 'rooms_drawer_event.dart';
part 'rooms_drawer_state.dart';

class RoomsDrawerBloc extends Bloc<RoomsDrawerEvent, RoomsDrawerState> {
  RoomsDrawerBloc() : super(RoomsDrawerInitial()) {
    on<RoomsDrawerEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<PickProfileImageEvent>((event, emit) async {
      emit(RoomsDrawerProfileImageLoadingState());
      await PickProfileImageUseCase()().then((DataState<String> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(RoomsDrawerProfileImageCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(RoomsDrawerProfileImageErrorState(dataState.error!));
        } else {
          emit(RoomsDrawerInitial());
        }
      });
    });
  }
}
