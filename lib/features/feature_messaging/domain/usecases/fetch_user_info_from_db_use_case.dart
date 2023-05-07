import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../locator.dart';
import '../repositories/user_repository.dart';

class FetchUserInfoFromDbUseCase extends NoParamUseCase<UserEntity> {

  final userRepository = getIt<UserRepository>();
  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<UserEntity>> call() async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
        final cachedUser = await userRepository.fetchUserData(email: currentUser.email!);
        if (cachedUser != null) {
          AppSettings.initializationFromUserEntity(cachedUser);
          return DataSuccess(cachedUser);
        } else {
          return DataFailed('کاربری در پایگاه داده وجود ندارد!');
        }
      } else {
        return DataFailed('خطا در شناسایی کاربر!');
      }
    } on DatabaseException catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا هنگام واکشی اطلاعات کاربر!');
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }

}