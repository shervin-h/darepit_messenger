import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';

class AppSettings {
  static double fontSize = 14.0;
  static String bubbleColor = 'white';
  static int userId = -1;
  static String email = '';
  static String password = '';
  static String wallpaper = '';
  static String assetWallpaperName = '';  // wallpaper_1.jpg
  static String username = '';
  static int logout = 1;
  static String profileImage = '';
  static String room = '';
  static String profileImagePublicUrl = '';

  static void initializationFromUserEntity(UserEntity userEntity) {
    fontSize = userEntity.fontSize?.toDouble() ?? 14.0;
    bubbleColor = userEntity.bubbleColor ?? 'white';
    userId = userEntity.userId ?? -1;
    email = userEntity.email ?? '';
    password = userEntity.password ?? '';
    wallpaper = userEntity.wallpaper ?? '';
    assetWallpaperName = userEntity.assetWallpaper ?? '';
    username = userEntity.username ?? '';
    logout = userEntity.logout ?? 1;
    profileImage = userEntity.profileImage ?? '';
    room = userEntity.room ?? '';
    profileImagePublicUrl = userEntity.profileImagePublicUrl ?? '';
  }

  static void initializationOrUpdateFromJson(Map<String, dynamic> json) {
    if (json.containsKey('user_id') && json['user_id'] is int) {
      userId = json['user_id'] ?? -1;
    }
    if (json.containsKey('email') && json['email'] is String) {
      email = json['email'] ?? '';
    }
    if (json.containsKey('username') && json['username'] is String) {
      username = json['username'] ?? '';
    }
    if (json.containsKey('password') && json['password'] is String) {
      password = json['password'] ?? '';
    }
    if (json.containsKey('room') && json['room'] is String) {
      room = json['room'] ?? '';
    }
    if (json.containsKey('logout') && json['logout'] is int) {
      logout = json['logout'] ?? 1;
    }
    if (json.containsKey('profile_image') && json['profile_image'] is String) {
      profileImage = json['profile_image'] ?? '';
    }
    if (json.containsKey('profile_image_public_url') && json['profile_image_public_url'] is String) {
      profileImagePublicUrl = json['profile_image_public_url'] ?? '';
    }
    if (json.containsKey('wallpaper') && json['wallpaper'] is String) {
      wallpaper = json['wallpaper'] ?? '';
    }
    if (json.containsKey('asset_wallpaper') && json['asset_wallpaper'] is String) {
      assetWallpaperName = json['asset_wallpaper'] ?? '';
    }
    if (json.containsKey('font_size') && json['font_size'] is int) {
      fontSize = json['font_size'].toDouble() ?? 14.0;
    }
    if (json.containsKey('bubble_color') && json['bubble_color'] is String) {
      bubbleColor = json['bubble_color'] ?? 'white';
    }
  }
}