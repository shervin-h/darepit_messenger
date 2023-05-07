import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/app_settings.dart';

class ChangeChatItemSettingsUseCase extends TwoParamsUseCase<Map<String, dynamic>, double?, String?>{

  final userRepository = getIt<UserRepository>();
  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<Map<String, dynamic>>> call(double? param1, String? param2) async {
    // param1: fontSize - param2: Color
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
        final cachedUser = await userRepository.fetchUserData(email: currentUser.email!);
        if (cachedUser != null) {
          if (param1 != null) {
            cachedUser.fontSize = param1.toInt();
          }

          if (param2 != null) {
            cachedUser.bubbleColor = param2;
          }

          AppSettings.initializationFromUserEntity(cachedUser);

          final resultDb = await userRepository.updateUser(userEntity: cachedUser);
          if (resultDb) {
            return DataSuccess({'font_size': cachedUser.fontSize, 'bubble_color': cachedUser.bubbleColor});
          } else {
            return DataFailed('خطا! تنظیمات ذخیره نشد!');
          }
        } else {
          return DataFailed('کاربری ذخیره نشده است!');
        }
      } else {
        return DataFailed('خطا در شناسایی کاربر فعلی!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }
}