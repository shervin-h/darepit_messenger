import 'package:flusher/config/app_settings.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/usecases/use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';


class GetUserFromDbUseCase extends NoParamUseCase<Map<String, dynamic>> {

  final userRepository = getIt<UserRepository>();

  @override
  Future<DataState<Map<String, dynamic>>> call() async {
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        final supabaseAuth = Supabase.instance.client.auth;
        UserEntity? userEntity = await userRepository.fetchUserData();
        if (userEntity != null &&
            userEntity.email != null &&
            userEntity.password != null &&
            userEntity.logout != null &&
            userEntity.logout! == 1) {
          AppSettings.initializationOrUpdateFromJson(userEntity.toJsonDb());

          /// User exists in db and logout is true => go to `LoginScreen`
          // if (supabaseAuth.currentUser != null && supabaseAuth.currentUser!.email != null) {
          //   return DataSuccess({'user': userEntity /*supabaseAuth.currentUser*/, 'logout': true, 'profile_image': userEntity.profileImage ?? ''});
          // } else {
          final authResponse = await supabaseAuth.signInWithPassword(
            email: userEntity.email,
            password: userEntity.password!,
          );
          if (authResponse.session != null && authResponse.session!.user.email != null) {
            return DataSuccess({'user': userEntity /*authResponse.session!.user*/, 'logout': true, 'profile_image': userEntity.profileImage ?? ''});
          }
          // }

          return DataFailed('خطا هنگام احراز هویت کاربر!');

        } else if (userEntity != null &&
            userEntity.email != null &&
            userEntity.password != null &&
            userEntity.logout != null &&
            userEntity.logout! == 0) {
          AppSettings.initializationOrUpdateFromJson(userEntity.toJsonDb());

          /// User exists in db and logout is false => go to `RoomsScreen`
          // if (supabaseAuth.currentUser != null && supabaseAuth.currentUser!.email != null) {
          //   return DataSuccess({'user': userEntity /*supabaseAuth.currentUser*/, 'logout': false, 'profile_image': userEntity.profileImage ?? ''});
          // } else {
          final authResponse = await supabaseAuth.signInWithPassword(
            email: userEntity.email,
            password: userEntity.password!,
          );
          if (authResponse.session != null && authResponse.session!.user.email != null) {
            return DataSuccess({'user': userEntity /*authResponse.session!.user*/, 'logout': false, 'profile_image': userEntity.profileImage ?? ''});
          }
          // }

          return DataFailed('خطا هنگام احراز هویت کاربر!');

        } else {
          /// User is not in db may be is first use => go to `RegisterScreen`
          return DataFailed('این کاربر در پایگاه داده وجود ندارد شاید اولین استفاده است!');
        }
      } else {
        return DataFailed('عدم برقراری ارتباط با اینترنت!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا هنگام واکشی اطلاعات کاربر از پایگاه داده!');
    }
  }
}