import 'package:flusher/core/params/add_room_params.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddRoomUseCase extends OneParamUseCase<List<RoomEntity>, AddRoomParams> {

  SupabaseClient supabaseClient = Supabase.instance.client;
  @override
  Future<DataState<List<RoomEntity>>> call(AddRoomParams param) async {
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        User? user = supabaseClient.auth.currentUser;
        if (user != null && user.email != null && user.email!.isNotEmpty) {
          final List userData = await supabaseClient
              .from('users')
              .select('id')
              .eq('email', user.email!);

          int userId = userData.first['id'];

          await supabaseClient.from('rooms').insert(
              {
                'created_at': param.createdAt,
                'updated_at': param.updatedAt,
                'name': param.name,
                'description': param.description,
                'room_image': param.image,
                'user_id': userId,
                'is_private': param.isPrivate,
                'private_key': param.privateKey ?? '',
              }
          );

          final List roomsData = await supabaseClient
              .from('rooms')
              .select('''*, users!inner(*)''')
              .eq('users.email', user.email);

          List<RoomEntity> rooms = [];
          if (roomsData.isNotEmpty) {
            for (var item in roomsData) {
              rooms.add(
                RoomEntity(
                  roomId: item['id'],
                  userId: item['user_id'],
                  name: item['name'],
                  description: item['description'],
                  roomImage: item['room_image'],
                  isPrivate: item['is_private'],
                  privateKey: item['private_key'],
                  createdAt: item['created_at'],
                  updatedAt: item['updated_at']
                ),
              );
            }
          }

          return DataSuccess(rooms);
        } else {
          return DataFailed('خطا در شناسایی کاربر !');
        }
      } else {
        return DataFailed('عدم برقراری ارتباط با اینترنت! لطفاً بررسی کنید...');
      }
    } on AuthException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } on PostgrestException catch (e){
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص !');
    }
  }

}