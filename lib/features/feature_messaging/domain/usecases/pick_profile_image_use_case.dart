import 'dart:convert';
import 'dart:io';

import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/core/utils/work_with_files.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/helper.dart';
import '../../../../locator.dart';
import '../repositories/user_repository.dart';

class PickProfileImageUseCase extends NoParamUseCase<String>{

  final userRepository = getIt<UserRepository>();
  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<String>> call() async {
    try {
      String? encoded = await pickImage(preferredCameraDevice: CameraDevice.front, maxWidth: 250, maxHeight: 250, quality: 50);
      User? currentUser = supabaseClient.auth.currentUser;
      if (encoded != null && currentUser != null && currentUser.email != null) {
        final resultDb = await userRepository.updateUserProfileImage(email: currentUser.email!, profileImage: encoded);
        AppSettings.profileImage = encoded;

        if ((await IsOnlineUseCase()()) is DataSuccess) {
          //TODO: send user profile encoded image to storage of supabase
          String fileName = '${currentUser.email!}_${DateTime.now().millisecondsSinceEpoch.toString()}_avatar.jpg';
          writeUint8ListBytes(
            bytes: base64Decode(encoded),
            fileNameWithExtension: fileName,
            fileDirectory: FileDirectoryIosAndroid.documents,
          ).then((File? avatarFile) {
            if (avatarFile != null) {
              supabaseClient.storage.from('avatars').upload(
                'public/$fileName',
                avatarFile,
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              ).then((String path) async {
                debugPrint('Uploaded profile image path: $path');

                final String publicUrl = supabaseClient.storage.from('avatars').getPublicUrl('public/$fileName');
                debugPrint('Profile image public url: $publicUrl');

                await supabaseClient.from('users')
                    .update({'user_image': publicUrl})
                    .match({'id': AppSettings.userId,'email': currentUser.email});

                await userRepository.updateUserData(userData: {'profile_image_public_url': publicUrl});
              });
            }
          });
        }

        if (resultDb) {
          return DataSuccess(encoded);
        } else {
          return DataFailed('هنگام ذخیره عکس خطا به وجود آمد!');
        }
      } else {
        return DataFailed('خطا در شناسایی کاربر جاری!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on StorageException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص هنگام برداشتن عکس!');
    }
  }

}