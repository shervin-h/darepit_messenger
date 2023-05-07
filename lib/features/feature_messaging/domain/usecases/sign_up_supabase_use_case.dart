import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/app_settings.dart';
import '../entities/user_entity.dart';

class SignUpSupabaseUseCase extends TwoParamsUseCase<User, String, String> {
  final SupabaseClient supabase = Supabase.instance.client;
  final userRepository = getIt<UserRepository>();

  @override
  Future<DataState<User>> call(String param1, String param2) async {
    // param1: email , param2: password
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        AuthResponse authResponse = await supabase.auth.signUp(email: param1, password: param2);
        if (authResponse.session != null && authResponse.session!.user.email != null) {
          final user = authResponse.session!.user;
          await supabase.from('users').insert(
              {
                'created_at': DateTime.now().toIso8601String(),
                'email': user.email ?? param1,
                'username': param1.split('@').first,
                'user_image': '',
              }
          );

          final List supabaseUser = await supabase.from('users').select('id').eq('email', user.email!);
          int userId = supabaseUser.first['id'];

          final userEntity = UserEntity(
            userId: userId,
            email: user.email,
            password: param2,
            logout: 0,
            username: param1.split('@').first,
          );
          AppSettings.initializationFromUserEntity(userEntity);

          final UserEntity? cachedUser = await userRepository.fetchUserData(email: param1);

          if (cachedUser != null) {
            await userRepository.updateUserData(
                userData: {'user_id': userId, 'email': user.email ?? param1, 'password': param2, 'logout': 0, 'username': param1.split('@').first});
          } else {
            await userRepository.insertUser(userEntity: userEntity);
          }
          return DataSuccess(authResponse.session!.user);
        } else {
          return DataFailed('کاربر جدید ثبت نشد!');
        }
      } else {
        return DataFailed('عدم دسترسی به اینترنت!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on PostgrestException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    }
    catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }
}
