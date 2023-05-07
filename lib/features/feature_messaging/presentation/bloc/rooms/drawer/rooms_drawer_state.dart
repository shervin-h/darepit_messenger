part of 'rooms_drawer_bloc.dart';

@immutable
abstract class RoomsDrawerState {}

class RoomsDrawerInitial extends RoomsDrawerState {}

class RoomsDrawerProfileImageLoadingState extends RoomsDrawerState {}

class RoomsDrawerProfileImageCompletedState extends RoomsDrawerState {
  final String encoded;
  RoomsDrawerProfileImageCompletedState(this.encoded);
}

class RoomsDrawerProfileImageErrorState extends RoomsDrawerState {
  final String errorMessage;
  RoomsDrawerProfileImageErrorState(this.errorMessage);
}