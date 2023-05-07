import 'package:flusher/features/feature_messaging/domain/entities/chatter_entity.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> fetchUserData({String? email});
  Future<bool> insertUser({required UserEntity userEntity});
  Future<bool> updateUser({required UserEntity userEntity});
  Future<bool> updateUserData({required Map<String, dynamic> userData});
  Future<bool> logoutUser({required String email, required int logout});
  Future<bool> updateUserProfileImage({required String email, required String profileImage});
  Future<bool> updateWallpaper({required String email, required String wallpaper});
  Future<bool> cacheChatterInfo({required String email, required ChatterEntity chatterEntity});
}