import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetCountUnSeenMessagesUseCase extends OneParamUseCase<int, int> {

  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<int>> call(int param) async {
    // type: int -> count of unseen messages
    // arguments: int -> param: room_id
    try {
      int userId = AppSettings.userId;
      if (userId == -1 || userId == 0) {
        final currentUser = supabaseClient.auth.currentUser;
        if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
          final List userData = await supabaseClient.from('users').select('id').eq('email', currentUser.email!);
          userId = userData.first['id'];
          AppSettings.userId = userId;
        } else {
          return DataFailed('خطا در شناسایی کاربر!');
        }
      }

      final List userRoomData = await supabaseClient.from('user_room').select('last_seen_chat').eq('room_id', param).eq('user_id', userId);
      if (userRoomData.isNotEmpty) {
        int lastSeenId = userRoomData.first['last_seen_chat'];
        final List unseenChats = await supabaseClient.from('chats').select('id').eq('room_id', param).gt('id', lastSeenId);
        return DataSuccess(unseenChats.length);
      }

      return DataSuccess(0);
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