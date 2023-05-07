part of 'search_rooms_bloc.dart';

// @immutable
class SearchRoomsState{
  bool isExpanded;

  SearchRoomsState({required this.isExpanded});

  SearchRoomsState copyWith({bool? newIsExpanded}) {
    return SearchRoomsState(isExpanded: newIsExpanded ?? isExpanded);
  }
}

class SearchRoomsInitial extends SearchRoomsState {
  SearchRoomsInitial({required super.isExpanded});
}

class SearchRoomsLoadingState extends SearchRoomsState {
  SearchRoomsLoadingState({required super.isExpanded});
}

class SearchRoomsCompletedState extends SearchRoomsState {
  final List<RoomEntity> rooms;
  SearchRoomsCompletedState(this.rooms, {required super.isExpanded});
}

class SearchRoomsErrorState extends SearchRoomsState {
  final String errorMessage;
  SearchRoomsErrorState(this.errorMessage, {required super.isExpanded});
}
