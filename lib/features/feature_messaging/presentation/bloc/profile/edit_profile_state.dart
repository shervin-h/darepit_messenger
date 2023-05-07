part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileCompletedState extends EditProfileState {
  UserEntity userEntity;
  EditButtonPressedStatus editButtonPressedStatus;

  EditProfileCompletedState({required this.userEntity, required this.editButtonPressedStatus});

  EditProfileCompletedState copyWith({
    UserEntity? newUserEntity,
    EditButtonPressedStatus? newEditButtonPressedStatus,
  }) {
    return EditProfileCompletedState(
      userEntity: newUserEntity ?? userEntity,
      editButtonPressedStatus: newEditButtonPressedStatus ?? editButtonPressedStatus,
    );
  }
}

class EditProfileErrorState extends EditProfileState {
  final String errorMessage;
  EditProfileErrorState(this.errorMessage);
}


/////////////////////////////////////////////
//////// Edit Button Pressed Status /////////
/////////////////////////////////////////////
abstract class EditButtonPressedStatus {}

class EditButtonPressedInitialState extends EditButtonPressedStatus {}

class EditButtonPressedLoadingState extends EditButtonPressedStatus {}

class EditButtonPressedCompletedState extends EditButtonPressedStatus {
  final UserEntity userEntity;
  EditButtonPressedCompletedState(this.userEntity);
}

class EditButtonPressedErrorStatus extends EditButtonPressedStatus {
  final String errorMessage;
  EditButtonPressedErrorStatus(this.errorMessage);
}
