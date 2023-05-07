import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateUserUseCase extends OneParamUseCase<UserEntity, UserEntity> {
  
  final userRepository = getIt<UserRepository>();
  final supabaseClient = Supabase.instance.client;
  
  @override
  Future<DataState<UserEntity>> call(UserEntity param) async {
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        final currentUser = supabaseClient.auth.currentUser;
        if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
          UserEntity? cachedUser = await userRepository.fetchUserData(email: currentUser.email!);
          if (cachedUser != null) {
            final resultDb = await userRepository.updateUser(userEntity: param);
            if (resultDb) {
              await supabaseClient
                  .from('users')
                  .update({
                    'email': param.email,
                    'username': param.username,
                    'user_image': param.profileImage,
                    'updated_at': DateTime.now().toIso8601String(),
                  })
                  .match({'id': param.userId, 'email': param.email});

              final UserResponse res = await supabaseClient.auth.updateUser(
                UserAttributes(
                  email: param.email,
                  password: param.password,
                ),
              );
              final User? updatedUser = res.user;
              if (updatedUser != null) {
                AppSettings.initializationFromUserEntity(param);
                return DataSuccess(param);
              } else {
                return DataFailed('خطا هنگام به روز رسانی اطلاعات کاربر نزد سرور!');
              }
            } else {
              return DataFailed('اطلاعات کاربر به روز نشد!');
            }
          } else {
            return DataFailed('کاربری در پایگاه داده وجود ندارد!');
          }
        } else {
          return DataFailed('خطا در شناسایی کاربر!');
        }
      } else {
        return DataFailed('عدم برقرای ارتباط با سرور!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on PostgrestException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }
  
}