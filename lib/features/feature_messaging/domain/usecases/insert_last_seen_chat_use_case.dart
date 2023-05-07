import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertLastSeenChatUseCase extends TwoParamsUseCase<bool, int, int>{
  
  final supabaseClient = Supabase.instance.client;
  
  @override
  Future<DataState<bool>> call(int param1, int param2) async {
    // param1: room_id, param2: chat_id
    try {
      final currentUser = supabaseClient.auth.currentUser;
      int userId = AppSettings.userId;
      if (userId == -1 || userId == 0) {
        if (currentUser != null && currentUser.email != null && currentUser.email!.isNotEmpty) {
          final List userData = await supabaseClient.from('users').select('id').eq('email', currentUser.email!);
          userId = userData.first['id'];
          AppSettings.userId = userId;
        } else {
          return DataFailed('خطا در شناسایی کاربر!');
        }
      }
      final List lastSeenData = await supabaseClient.from('user_room').select('*').eq('user_id', userId).eq('room_id', param1);
      if (lastSeenData.isNotEmpty) {
        await supabaseClient.from('user_room').update({
          'last_seen_chat': param2,
          'updated_at': DateTime.now().toIso8601String(),
        }).match({'user_id': userId, 'room_id': param1});
      } else {
        await supabaseClient.from('user_room').insert({
          'user_id': userId,
          'room_id': param1,
          'last_seen_chat': param2,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      return DataSuccess(true);
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on PostgrestException catch(e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }
 
  
}