import 'package:flutter/cupertino.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/app_settings.dart';

class ChangeChatWallpaperUseCase extends OneParamUseCase<Map<String, dynamic>, String> {

  final userRepository = getIt<UserRepository>();
  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<Map<String, dynamic>>> call(String? param) async {
    // param: assetWallpaper
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
        UserEntity? cachedUser = await userRepository.fetchUserData(email: currentUser.email!);
        if (cachedUser != null) {
          if (param != null) {
            cachedUser.assetWallpaper = param;
            cachedUser.wallpaper = '';
          }
          AppSettings.initializationFromUserEntity(cachedUser);
          final resultDb = await userRepository.updateUser(userEntity: cachedUser);
          if (resultDb) {
            return DataSuccess(
              {
                'user_entity': cachedUser,
                'from_asset': (cachedUser.wallpaper != null && cachedUser.wallpaper!.isNotEmpty) ? false : true,
              },
            );
          } else {
            return DataFailed('خطا در به روز رسانی اطلاعات کاغذ دیواری در پایگاه داده !');
          }
        } else {
          return DataFailed('اطلاعاتی در دسترس نیست !');
        }
      } else {
        return DataFailed('خطا در شناسایی کاربر!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا در لود کردن کاغذ دیواری از پایگاه داده !');
    }
  }
}