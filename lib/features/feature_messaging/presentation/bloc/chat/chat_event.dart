part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class EnterTheChatRoomEvent extends ChatEvent {
  final RoomEntity roomEntity;
  final UserEntity userEntity;
  EnterTheChatRoomEvent({required this.roomEntity, required this.userEntity});
}

class ExitTheChatRoomEvent extends ChatEvent {}

class LoadChatWallpaperEvent extends ChatEvent {
  final String? assetWallpaper;
  LoadChatWallpaperEvent([this.assetWallpaper]);
}

class SendMessageEvent extends ChatEvent {
  final ChatParams chatParams;
  SendMessageEvent(this.chatParams);
}

class SendMessageInitialEvent extends ChatEvent {}

class DeleteMessageEvent extends ChatEvent {
  final int chatId;
  final int userId;
  DeleteMessageEvent(this.chatId, this.userId);
}
