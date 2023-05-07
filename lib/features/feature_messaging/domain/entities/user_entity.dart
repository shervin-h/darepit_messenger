import 'dart:math';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  late int userId;
  String? email;
  String? password;
  String? username;
  String? room;
  int? logout;
  String? profileImage;
  String? profileImagePublicUrl;
  String? wallpaper;
  String? assetWallpaper;
  int? fontSize;
  String? bubbleColor;
  String? createdAt;
  String? updatedAt;

  UserEntity({
    required this.email,
    required this.password,
    required this.userId,
    this.username = '',
    this.room = '',
    this.logout = 0,
    this.profileImage = '',
    this.profileImagePublicUrl = '',
    this.wallpaper = '',
    this.assetWallpaper = 'wallpaper_1.jpg',
    this.fontSize = 14,
    this.bubbleColor = 'white',
    this.createdAt,
    this.updatedAt,
  });

  /// the key of json param must be same with `app_user` table column titles
  UserEntity.fromJsonDb(Map<String, dynamic> json) {
    userId = json['user_id'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    room = json['room'];
    logout = json['logout'];
    profileImage = json['profile_image'];
    profileImagePublicUrl = json['profile_image_public_url'];
    wallpaper = json['wallpaper'];
    assetWallpaper = json['asset_wallpaper'];
    fontSize = json['font_size'];
    bubbleColor = json['bubble_color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  /// the key of Map data must be equal to `app_user` table column titles
  Map<String, dynamic> toJsonDb() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['email'] = email;
    data['username'] = username ?? '';
    data['password'] = password ?? '';
    data['room'] = room ?? '';
    data['logout'] = logout ?? 0;
    data['profile_image'] = profileImage ?? '';
    data['profile_image_public_url'] = profileImagePublicUrl ?? '';
    data['wallpaper'] = wallpaper ?? '';
    data['asset_wallpaper'] = assetWallpaper ?? '';
    data['font_size'] = fontSize ?? 14;
    data['bubble_color'] = bubbleColor ?? 'white';
    data['created_at'] = createdAt ?? DateTime.now().toIso8601String();
    data['updated_at'] = updatedAt ?? DateTime.now().toIso8601String();
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    userId,
    email,
    password,
    username,
    profileImage,
    profileImagePublicUrl,
    wallpaper,
    assetWallpaper,
    logout,
    fontSize,
    bubbleColor,
    createdAt,
    updatedAt,
  ];
}