import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetUserProfileImagePublicUrl extends OneParamUseCase<String, String> {

  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<String>> call(String param) async {
    // param: String -> email
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        final List userData = await supabaseClient.from('users').select('user_image').eq('email', param);
        if (userData.isNotEmpty) {
          String publicUrl = userData.first['user_image'];
          return DataSuccess(publicUrl);
        }
        return DataFailed('خطا در واکشی عکس پروفایل!');
      } else {
        return DataFailed('خطا عدم برقراری ارتباط!');
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطا در بازیابی عکس پروفایل!');
    }
  }

}