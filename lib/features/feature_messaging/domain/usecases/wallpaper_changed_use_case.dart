import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/core/utils/helper.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/app_settings.dart';


class WallpaperChangedUseCase extends NoParamUseCase<String> {

  final userRepository = getIt<UserRepository>();
  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<String>> call() async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
        String? encoded = await pickImage(source: ImageSource.gallery, quality: 100, maxHeight: 1920, maxWidth: 1080);
        if (encoded != null) {
          final resultDb = await userRepository.updateWallpaper(email: currentUser.email!, wallpaper: encoded);
          if (resultDb) {
            AppSettings.wallpaper = encoded;
            return DataSuccess(encoded);
          } else {
            return DataFailed('تصویر انتخابی ذخیره نشد!');
          }
        } else {
          return DataFailed('خطا هنگام برداشتن کاغذ دیواری!');
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