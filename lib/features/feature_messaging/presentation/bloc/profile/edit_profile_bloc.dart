import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/fetch_user_info_from_db_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/update_user_use_case.dart';
import 'package:meta/meta.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    on<EditProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<EditProfileStartedEvent>((event, emit) async {
      emit(EditProfileLoadingState());
      await FetchUserInfoFromDbUseCase()().then((DataState<UserEntity> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(EditProfileCompletedState(userEntity: dataState.data!, editButtonPressedStatus: EditButtonPressedInitialState()));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(EditProfileErrorState(dataState.error!));
        } else {
          emit(EditProfileInitial());
        }
      });
    });

    on<EditProfileButtonPressedEvent>((event, emit) async {
      final editProfileCompletedState = state as EditProfileCompletedState;
      emit(editProfileCompletedState.copyWith(newEditButtonPressedStatus: EditButtonPressedLoadingState()));
      await UpdateUserUseCase()(event.userEntity).then((DataState<UserEntity> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(editProfileCompletedState.copyWith(
            newUserEntity: dataState.data!,
            newEditButtonPressedStatus: EditButtonPressedCompletedState(dataState.data!),
          ));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(editProfileCompletedState.copyWith(newEditButtonPressedStatus: EditButtonPressedErrorStatus(dataState.error!)));
        } else {
          emit(editProfileCompletedState.copyWith(newEditButtonPressedStatus: EditButtonPressedInitialState()));
        }
      });
    });

  }
}
