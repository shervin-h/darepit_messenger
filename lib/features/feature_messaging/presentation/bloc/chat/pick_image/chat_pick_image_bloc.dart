import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/pick_chat_image_use_case.dart';
import 'package:meta/meta.dart';

part 'chat_pick_image_event.dart';
part 'chat_pick_image_state.dart';

class ChatPickImageBloc extends Bloc<ChatPickImageEvent, ChatPickImageState> {
  ChatPickImageBloc() : super(ChatPickImageInitial()) {
    on<ChatPickImageEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ChatPickImageStartedEvent>((event, emit) async {
      emit(ChatPickImageLoadingState());
      await PickChatImageUseCase()().then((DataState<File> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(ChatPickImageCompletedState(dataState.data!));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(ChatPickImageErrorState(dataState.error!));
        } else {
          emit(ChatPickImageInitial());
        }
      });
    });

    on<ChatPickImageSetToInitialEvent>((event, emit) {
      emit(ChatPickImageInitial());
    });

  }
}
