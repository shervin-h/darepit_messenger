import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/params/chat_params.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SendChatUseCase extends OneParamUseCase<bool, ChatParams> {

  SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<DataState<bool>> call(ChatParams param) async {
    try {
      if ((await IsOnlineUseCase()()) is DataSuccess) {
        User? user = supabase.auth.currentUser;
        if (user != null && user.email != null && user.email!.isNotEmpty) {

          int userId = AppSettings.userId;
          if (userId == -1 || userId == 0) {
            final List supabaseUser = await supabase.from('users').select('id').eq('email', user.email!);
            userId = supabaseUser.first['id'];
            AppSettings.userId = userId;
          }

          String publicUrl = '';
          if (param.file != null) {
            String fileName = '${user.email!}_${DateTime.now().millisecondsSinceEpoch.toString()}_asset_image.jpg';
            final String path = await supabase.storage.from('assets').upload(
              'images/$fileName',
              param.file!,
              fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
            );
            debugPrint('Uploaded chat image path: $path');

            publicUrl = supabase.storage.from('assets').getPublicUrl('images/$fileName');
            debugPrint('Chat image public url: $publicUrl');
          }

          await supabase.from('chats').insert(
            {
              'created_at': DateTime.now().toIso8601String(),
              'room_id': param.roomId,
              'username': AppSettings.username.isNotEmpty ? AppSettings.username : user.email!.split('@').first,
              'sender': user.email!,
              'text': param.body,
              'user_id': userId,
              'contain_asset': param.file != null ? true : false,
              'asset_url': publicUrl,
            },
          );
          return DataSuccess(true);
        } else {
          return DataFailed('خطا در شناسایی کاربر !');
        }
      } else {
        return DataFailed('عدم برقراری ارتباط با اینترنت!');
      }

    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on PostgrestException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on StorageException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص !');
    }
  }

}