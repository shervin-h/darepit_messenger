import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';

abstract class EnterTheChatRoomStatus {}

class EnterTheChatRoomInitialStatus extends EnterTheChatRoomStatus {}

class EnterTheChatRoomCompletedStatus extends EnterTheChatRoomStatus {
  final Object roomData;
  final UserEntity userEntity;
  EnterTheChatRoomCompletedStatus({required this.roomData, required this.userEntity});
}