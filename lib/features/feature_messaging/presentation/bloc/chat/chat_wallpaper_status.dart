
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';

abstract class ChatWallpaperStatus {}

class ChatWallpaperInitialStatus extends ChatWallpaperStatus{}

class ChatWallpaperLoadingStatus extends ChatWallpaperStatus {}

class ChatWallpaperCompletedStatus extends ChatWallpaperStatus {
  final UserEntity userEntity;
  final bool fromAsset;
  ChatWallpaperCompletedStatus({required this.userEntity, required this.fromAsset});
}

class ChatWallpaperErrorStatus extends ChatWallpaperStatus {
  final String errorMessage;
  ChatWallpaperErrorStatus(this.errorMessage);
}