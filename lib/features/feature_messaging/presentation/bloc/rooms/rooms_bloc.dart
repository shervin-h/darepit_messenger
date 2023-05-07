import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/core/params/add_room_params.dart';
import 'package:flusher/core/params/update_room_params.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/add_room_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/delete_room_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/fetch_user_rooms_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/search_rooms_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/update_room_use_case.dart';
import 'package:meta/meta.dart';

import '../../../domain/entities/room_entity.dart';

part 'rooms_event.dart';
part 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomsBloc() : super(RoomsInitial()) {
    on<RoomsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<RoomsStartedEvent>((event, emit) async {
      emit(RoomsLoadingState());
      await FetchUserRoomsUseCase()(event.email).then((DataState<List<RoomEntity>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(RoomsCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(RoomsErrorState(dataState.error!));
        } else {
          emit(RoomsInitial());
        }
      });
    });

    on<AddRoomEvent>((event, emit) async {
      emit(RoomsLoadingState());
      await AddRoomUseCase()(event.addRoomParams).then((DataState<List<RoomEntity>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(RoomsCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(RoomsErrorState(dataState.error!));
        } else {
          emit(RoomsInitial());
        }
      });
    });

    on<UpdateRoomEvent>((event, emit) async {
      emit(RoomsLoadingState());
      await UpdateRoomUseCase()(event.updateRoomParams).then((DataState<List<RoomEntity>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(RoomsCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(RoomsErrorState(dataState.error!));
        } else {
          emit(RoomsInitial());
        }
      });
    });

    on<RemoveRoomEvent>((event, emit) async {
      emit(RoomsLoadingState());
      await DeleteRoomUseCase()(event.room).then((DataState<List<RoomEntity>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(RoomsCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(RoomsErrorState(dataState.error!));
        } else {
          emit(RoomsInitial());
        }
      });
    });

  }
}
