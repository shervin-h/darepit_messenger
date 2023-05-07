part of 'chat_item_settings_bloc.dart';

@immutable
abstract class ChatItemSettingsState {}

class ChatItemSettingsInitial extends ChatItemSettingsState {}

class ChatItemSettingsLoadingState extends ChatItemSettingsState {}

class ChatItemSettingsCompletedState extends ChatItemSettingsState {
  final double fontSize;
  final String bubbleColor;
  ChatItemSettingsCompletedState(this.fontSize, this.bubbleColor);
}

class ChatItemSettingsErrorState extends ChatItemSettingsState {}
