import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/change_chat_item_settings_use_case.dart';
import 'package:meta/meta.dart';

part 'chat_item_settings_event.dart';
part 'chat_item_settings_state.dart';

class ChatItemSettingsBloc extends Bloc<ChatItemSettingsEvent, ChatItemSettingsState> {
  ChatItemSettingsBloc() : super(ChatItemSettingsInitial()) {
    on<ChatItemSettingsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ChangedChatItemSettingsEvent>((event, emit) async {
      emit(ChatItemSettingsLoadingState());
      await ChangeChatItemSettingsUseCase()(event.fontSize, event.bubbleColor).then((DataState<Map<String, dynamic>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(ChatItemSettingsCompletedState(dataState.data!['font_size'], dataState.data!['bubble_color']));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(ChatItemSettingsErrorState());
        } else {
          emit(ChatItemSettingsInitial());
        }
      });
    });
  }
}
