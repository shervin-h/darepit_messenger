import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoesTheUserHaveAccessToDeleteRoom extends OneParamUseCase<Map<String, dynamic>, int> {
  @override
  Future<DataState<Map<String, dynamic>>> call(int param) async {
    // param: room_id
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        final supabaseClient = Supabase.instance.client;
        final currentUser = supabaseClient.auth.currentUser;
        if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {

          int userId = AppSettings.userId;
          if (userId == -1) {
            final List userData = await supabaseClient.from('users').select('id').eq('email', currentUser.email!);
            userId = userData.first['id'];
            AppSettings.userId = userId;
          }

          final List roomData = await supabaseClient.from('rooms').select('user_id').eq('id', param);
          int roomUserId = roomData.first['user_id'];

          if (userId == roomUserId) {
            return DataSuccess({'have_access': true, 'user_id': userId, 'email': currentUser.email!});
          } else {
            return DataFailed('دسترسی حذف اتاق را ندارید!');
          }

        } else {
          return DataFailed('خطا در شناسایی کاربر!');
        }
      } else {
        return DataFailed('عدم برقراری اتصال!');
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