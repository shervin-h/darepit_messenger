part of 'chat_item_settings_bloc.dart';

@immutable
abstract class ChatItemSettingsEvent {}

class ChangedChatItemSettingsEvent extends ChatItemSettingsEvent {
  final double? fontSize;
  final String? bubbleColor;
  ChangedChatItemSettingsEvent({this.fontSize, this.bubbleColor});
}
