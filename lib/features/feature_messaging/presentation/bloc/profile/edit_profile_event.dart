part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileStartedEvent extends EditProfileEvent {}

class EditProfileButtonPressedEvent extends EditProfileEvent {
  final UserEntity userEntity;
  EditProfileButtonPressedEvent(this.userEntity);
}
