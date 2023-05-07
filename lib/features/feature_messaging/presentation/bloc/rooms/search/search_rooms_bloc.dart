import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/search_rooms_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../domain/entities/room_entity.dart';

part 'search_rooms_event.dart';
part 'search_rooms_state.dart';

class SearchRoomsBloc extends Bloc<SearchRoomsEvent, SearchRoomsState> {
  SearchRoomsBloc() : super(SearchRoomsInitial(isExpanded: false)) {
    on<SearchRoomsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SearchRoomsByNameEvent>((event, emit) async {
      emit(SearchRoomsLoadingState(isExpanded: true));
      await SearchRoomsUseCase()(event.searchTerm).then((DataState<List<RoomEntity>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(SearchRoomsCompletedState(dataState.data!, isExpanded: true));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(SearchRoomsErrorState(dataState.error!, isExpanded: true));
        } else {
          emit(SearchRoomsInitial(isExpanded: false));
        }
      });
    });

    on<SearchRoomsExpandedEvent>((event, emit) {
      emit(state.copyWith(newIsExpanded: true));
    });

    on<SearchRoomsCollapsedEvent>((event, emit) {
      emit(state.copyWith(newIsExpanded: false));
    });


  }
}
