part of 'visited_rooms_bloc.dart';

@immutable
abstract class VisitedRoomsState {}

class VisitedRoomsInitial extends VisitedRoomsState {}

class VisitedRoomsLoadingState extends VisitedRoomsState {}

class VisitedRoomsCompletedState extends VisitedRoomsState {
  final List<RoomEntity> rooms;
  VisitedRoomsCompletedState(this.rooms);
}

class VisitedRoomsErrorState extends VisitedRoomsState {
  final String errorMessage;
  VisitedRoomsErrorState(this.errorMessage);
}
