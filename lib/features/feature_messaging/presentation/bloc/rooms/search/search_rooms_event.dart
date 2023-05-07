part of 'search_rooms_bloc.dart';

@immutable
abstract class SearchRoomsEvent {}

class SearchRoomsByNameEvent extends SearchRoomsEvent {
  final String searchTerm;
  SearchRoomsByNameEvent(this.searchTerm);
}

class SearchRoomsExpandedEvent extends SearchRoomsEvent {}

class SearchRoomsCollapsedEvent extends SearchRoomsEvent {}
