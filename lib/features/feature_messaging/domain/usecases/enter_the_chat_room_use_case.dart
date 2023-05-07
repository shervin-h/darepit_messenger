import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnterTheChatRoomUseCase extends OneParamUseCase<User, String> {

  final supabase = Supabase.instance.client;
  final userRepository = getIt<UserRepository>();

  @override
  Future<DataState<User>> call(String param) async { // param: room
    try {
      User? user = supabase.auth.currentUser;
      if (user != null) {
        UserEntity? cachedUser = await userRepository.fetchUserData();
        if (cachedUser != null) {
          final dbResult = await userRepository.updateUserData(userData: {'room': param});
          if (dbResult) {
            AppSettings.room = param;
            // PostgrestFilterBuilder data = await supabase.from('room').select().match({'name': param});
            return DataSuccess(user);
          } else {
            return DataFailed('اطلاعات کاربر فعلی به روز نشد!');
          }
        } else {
          return DataFailed('خطا هنگام واکشی اطلاعات کاربر!');
        }
      } else {
        return DataFailed('خطا در شناسایی کاربر!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا!');
    }
  }



}