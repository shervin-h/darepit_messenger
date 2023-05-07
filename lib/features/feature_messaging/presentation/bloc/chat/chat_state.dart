part of 'chat_bloc.dart';

@immutable
class ChatState extends Equatable {
  EnterTheChatRoomStatus enterTheChatRoomStatus;
  ChatWallpaperStatus chatWallpaperStatus;
  SendMessageStatus sendMessageStatus;
  DeleteMessageStatus deleteMessageStatus;

  ChatState({
    required this.enterTheChatRoomStatus,
    required this.chatWallpaperStatus,
    required this.sendMessageStatus,
    required this.deleteMessageStatus,
  });

  ChatState copyWith({
    EnterTheChatRoomStatus? newEnterTheChatRoomStatus,
    ChatWallpaperStatus? newChatWallpaperStatus,
    SendMessageStatus? newSendMessageStatus,
    DeleteMessageStatus? newDeleteMessageStatus,
  }) {
    return ChatState(
      enterTheChatRoomStatus: newEnterTheChatRoomStatus ?? enterTheChatRoomStatus,
      chatWallpaperStatus: newChatWallpaperStatus ?? chatWallpaperStatus,
      sendMessageStatus: newSendMessageStatus ?? sendMessageStatus,
      deleteMessageStatus: newDeleteMessageStatus ?? deleteMessageStatus,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [enterTheChatRoomStatus, chatWallpaperStatus, sendMessageStatus, deleteMessageStatus];
}

