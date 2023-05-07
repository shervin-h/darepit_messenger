import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/get_visited_rooms_from_db_use_case.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/resources/data_state.dart';
import '../../../../domain/entities/room_entity.dart';

part 'visited_rooms_event.dart';
part 'visited_rooms_state.dart';

class VisitedRoomsBloc extends Bloc<VisitedRoomsEvent, VisitedRoomsState> {
  VisitedRoomsBloc() : super(VisitedRoomsInitial()) {
    on<VisitedRoomsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<VisitedRoomsStartedEvent>((event, emit) async {
      emit(VisitedRoomsLoadingState());
      await GetVisitedRoomsFromDbUseCase()().then((DataState<List<RoomEntity>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(VisitedRoomsCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(VisitedRoomsErrorState(dataState.error!));
        } else {
          emit(VisitedRoomsInitial());
        }
      });
    });

  }
}
