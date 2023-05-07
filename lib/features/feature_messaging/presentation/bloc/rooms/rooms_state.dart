part of 'rooms_bloc.dart';

@immutable
abstract class RoomsState {}

class RoomsInitial extends RoomsState {}

class RoomsLoadingState extends RoomsState {}

class RoomsCompletedState extends RoomsState {
  final List<RoomEntity> rooms;
  RoomsCompletedState(this.rooms);
}

class RoomsErrorState extends RoomsState {
  final String errorMessage;
  RoomsErrorState(this.errorMessage);
}
