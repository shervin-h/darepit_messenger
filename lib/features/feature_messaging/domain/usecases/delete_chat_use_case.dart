import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteChatUseCase extends TwoParamsUseCase<bool, int, int> {
  @override
  Future<DataState<bool>> call(int param1, int param2) async {
    // param1: chat_id, param2: user_id
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        final supabaseClient = Supabase.instance.client;
        final supabaseUser = supabaseClient.auth.currentUser;
        if (supabaseUser != null && supabaseUser.email != null && supabaseUser.email!.isNotEmpty) {
          int userId = AppSettings.userId;
          if (userId == -1 || userId == 0) {
            final List userData = await supabaseClient.from('users').select('id').eq('email', supabaseUser.email!);
            userId = userData.first['id'];
            AppSettings.userId = userId;
          }

          if (userId == param2) {

            final List chatData = await supabaseClient.from('chats')
                .select('contain_asset, asset_url')
                .eq('id', param1)
                .eq('user_id', userId);

            if (chatData.isNotEmpty &&
                chatData.first['contain_asset'] &&
                chatData.first['asset_url'] is String &&
                (chatData.first['asset_url'] as String).isNotEmpty) {

              String assetName = (chatData.first['asset_url'] as String).split('/').last;

              final List<FileObject> object = await supabaseClient
                  .storage
                  .from('assets')
                  .remove(['images/$assetName']);

            }

            /// delete() should always be combined with Filters to target the item(s) you wish to delete.
            final result = await supabaseClient
                .from('chats')
                .delete()
                .match({'id': param1, 'user_id': userId});

            return DataSuccess(true);
          } else {
            return DataFailed('پیام شما نیست. دسترسی حذف آن را ندارید!');
          }
        } else {
          return DataFailed('خطا در شناسایی کاربر!');
        }
      } else {
        return DataFailed('عدم دسترسی به اینترنت! لطفاً اتصال را چک کنید!');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on PostgrestException catch (e) {
      debugPrint(e.message);
      return DataFailed('در حال حاضر امکان حذف پیام وجود ندارد!');
    } on StorageException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }

}