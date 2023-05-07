import 'dart:io';

class ChatParams {
  String body;
  int roomId;
  File? file;
  ChatParams({required this.body, required this.roomId, this.file});
}