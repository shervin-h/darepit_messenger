part of 'chat_pick_image_bloc.dart';

@immutable
abstract class ChatPickImageState {}

class ChatPickImageInitial extends ChatPickImageState {}

class ChatPickImageLoadingState extends ChatPickImageState {}

class ChatPickImageCompletedState extends ChatPickImageState {
  final File imageFile;
  ChatPickImageCompletedState(this.imageFile);
}

class ChatPickImageErrorState extends ChatPickImageState {
  final String errorMessage;
  ChatPickImageErrorState(this.errorMessage);
}
