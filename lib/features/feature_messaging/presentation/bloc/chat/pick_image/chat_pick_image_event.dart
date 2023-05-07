part of 'chat_pick_image_bloc.dart';

@immutable
abstract class ChatPickImageEvent {}

class ChatPickImageStartedEvent extends ChatPickImageEvent {}

class ChatPickImageSetToInitialEvent extends ChatPickImageEvent {}
