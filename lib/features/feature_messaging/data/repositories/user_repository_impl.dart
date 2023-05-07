import 'package:flusher/features/feature_messaging/domain/entities/chatter_entity.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../sources/local/app_user_provider.dart';


class UserRepositoryImpl extends UserRepository {
  @override
  Future<UserEntity?> fetchUserData({String? email}) {
    return AppUserProvider().getAppUserData();
  }

  @override
  Future<bool> insertUser({required UserEntity userEntity}) {
    return AppUserProvider().insertUser(userEntity);
  }

  @override
  Future<bool> updateUser({required UserEntity userEntity}) {
    return AppUserProvider().updateUser(userEntity);
  }

  @override
  Future<bool> updateUserData({required Map<String, dynamic> userData}) {
    return AppUserProvider().updateUserData(userData);
  }

  @override
  Future<bool> logoutUser({required String email, required int logout}) {
    return AppUserProvider().logoutUser(email, logout);
  }

  @override
  Future<bool> updateUserProfileImage({required String email, required String profileImage}) {
    return AppUserProvider().updateProfileImage(email, profileImage);
  }

  @override
  Future<bool> updateWallpaper({required String email, required String wallpaper}) {
    return AppUserProvider().updateWallpaper(email, wallpaper);
  }

  @override
  Future<bool> cacheChatterInfo({required String email, required ChatterEntity chatterEntity}) {
    return AppUserProvider().cacheChatterInfo(email, chatterEntity);
  }

}