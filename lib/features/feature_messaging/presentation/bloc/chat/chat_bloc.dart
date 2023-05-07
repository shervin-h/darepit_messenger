import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/delete_chat_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/wallpaper_changed_use_case.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/enter_the_chat_room_status.dart';
import 'package:flusher/features/feature_messaging/presentation/bloc/chat/send_message_status.dart';
import 'package:meta/meta.dart';

import '../../../../../core/params/chat_params.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/change_chat_wallpaper_use_case.dart';
import '../../../domain/usecases/send_chat_use_case.dart';
import 'chat_wallpaper_status.dart';
import 'delete_message_status.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(
    ChatState(
      enterTheChatRoomStatus: EnterTheChatRoomInitialStatus(),
      chatWallpaperStatus: ChatWallpaperInitialStatus(),
      sendMessageStatus: SendMessageInitialStatus(),
      deleteMessageStatus: DeleteMessageInitialStatus(),
    ),
  ) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<EnterTheChatRoomEvent>((event, emit) {
      emit(state.copyWith(newEnterTheChatRoomStatus: EnterTheChatRoomCompletedStatus(roomData: event.roomEntity, userEntity: event.userEntity)));
    });

    on<ExitTheChatRoomEvent>((event, emit) {
      emit(state.copyWith(newEnterTheChatRoomStatus: EnterTheChatRoomInitialStatus()));
    });

    on<LoadChatWallpaperEvent>((event, emit) async {
      emit(state.copyWith(newChatWallpaperStatus: ChatWallpaperLoadingStatus()));
      await ChangeChatWallpaperUseCase()(event.assetWallpaper).then((DataState<Map<String, dynamic>> dataState) {
        if (dataState is DataSuccess && dataState.data != null) {
          emit(state.copyWith(newChatWallpaperStatus: ChatWallpaperCompletedStatus(
            userEntity: dataState.data!['user_entity'],
            fromAsset: dataState.data!['from_asset'],
          )));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(state.copyWith(newChatWallpaperStatus: ChatWallpaperErrorStatus(dataState.error!)));
        } else {
          emit(state.copyWith(newChatWallpaperStatus: ChatWallpaperInitialStatus()));
        }
      });
    });

    on<SendMessageEvent>((event, emit) async {
      emit(state.copyWith(newSendMessageStatus: SendMessageLoadingStatus()));
      await SendChatUseCase()(event.chatParams).then((DataState<bool> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newSendMessageStatus: SendMessageCompletedStatus()));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(state.copyWith(newSendMessageStatus: SendMessageErrorStatus(dataState.error!)));
        } else {
          emit(state.copyWith(newSendMessageStatus: SendMessageInitialStatus()));
        }
      });
    });

    on<SendMessageInitialEvent>((event, emit) {
      emit(state.copyWith(newSendMessageStatus: SendMessageInitialStatus()));
    });

    on<DeleteMessageEvent>((event, emit) async {
      emit(state.copyWith(newDeleteMessageStatus: DeleteMessageLoadingStatus()));
      await DeleteChatUseCase()(event.chatId, event.userId).then((DataState<bool> dataState) {
        if (dataState is DataSuccess) {
          emit(state.copyWith(newDeleteMessageStatus: DeleteMessageCompletedStatus()));
        } else if (dataState is DataFailed && dataState.error != null) {
          emit(state.copyWith(newDeleteMessageStatus: DeleteMessageErrorStatus(dataState.error!)));
        } else {
          emit(state.copyWith(newDeleteMessageStatus: DeleteMessageInitialStatus()));
        }
      });
    });

  }
}
