import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/repositories/user_repository.dart';
import 'package:flusher/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SignOutSupabaseUseCase extends NoParamUseCase<bool> {

  final userRepository = getIt<UserRepository>();

  @override
  Future<DataState<bool>> call() async {
    try {
      final supabaseClient = Supabase.instance.client;
      final currentUser = supabaseClient.auth.currentUser;

      if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {

        final resultDb = await userRepository.logoutUser(email: currentUser.email!, logout: 1);
        if (resultDb) {
          await supabaseClient.auth.signOut();
          AppSettings.logout = 1;
          return DataSuccess(true);
        } else {
          return DataFailed('خطا هنگام خروج!');
        }

      } else {
        return DataFailed('خطا در شناسایی کاربر!');
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