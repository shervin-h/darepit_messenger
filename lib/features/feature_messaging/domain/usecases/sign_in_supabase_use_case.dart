import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/app_settings.dart';

class SignInSupabaseUseCase extends TwoParamsUseCase<User, String, String> {
  final supabase = Supabase.instance.client;
  final userRepository = getIt<UserRepository>();

  @override
  Future<DataState<User>> call(String param1, String param2) async {
    // param1: email, param2: password
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        AuthResponse authResponse = await supabase.auth.signInWithPassword(email: param1, password: param2);
        if (authResponse.session != null && authResponse.session!.user.email != null) {
          User user = authResponse.session!.user;

          final List supabaseUser = await supabase.from('users').select('id').eq('email', user.email!);
          int userId = supabaseUser.first['id'];

          final userEntity = UserEntity(
            userId: userId,
            email: user.email,
            password: param2,
            username: AppSettings.username.isNotEmpty ? AppSettings.username : user.email!.split('@').first,
            logout: 0,
          );


          UserEntity? cachedUser = await userRepository.fetchUserData(email: param1);

          if (cachedUser != null) {
            await userRepository.updateUserData(
              userData: {
                'user_id': userId,
                'email': user.email,
                'password': param2,
                'username': AppSettings.username.isNotEmpty ? AppSettings.username : user.email!.split('@').first,
                'logout': 0,
              },
            );
            AppSettings.initializationOrUpdateFromJson(
              {
                'user_id': userId,
                'email': user.email,
                'password': param2,
                'username': AppSettings.username.isNotEmpty ? AppSettings.username : user.email!.split('@').first,
                'logout': 0,
              },
            );
          } else {
            await userRepository.insertUser(userEntity: userEntity);
            AppSettings.initializationFromUserEntity(userEntity);
          }
          return DataSuccess(authResponse.session!.user);
        } else {
          return DataFailed('ورود ناموفق!');
        }
      } else {
        return DataFailed('عدم اتصال به اینترنت!');
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
