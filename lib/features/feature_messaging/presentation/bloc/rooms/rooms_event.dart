part of 'rooms_bloc.dart';

@immutable
abstract class RoomsEvent {}

class RoomsStartedEvent extends RoomsEvent {
  final String? email;
  RoomsStartedEvent([this.email]);
}

class AddRoomEvent extends RoomsEvent {
  final AddRoomParams addRoomParams;
  AddRoomEvent(this.addRoomParams);
}

class UpdateRoomEvent extends RoomsEvent {
  final UpdateRoomParams updateRoomParams;
  UpdateRoomEvent(this.updateRoomParams);
}

class RemoveRoomEvent extends RoomsEvent {
  final RoomEntity room;
  RemoveRoomEvent(this.room);
}



