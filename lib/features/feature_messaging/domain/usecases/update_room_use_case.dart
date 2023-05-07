import 'package:flusher/config/app_settings.dart';
import 'package:flusher/core/params/update_room_params.dart';
import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/room_entity.dart';

class UpdateRoomUseCase extends OneParamUseCase<List<RoomEntity>, UpdateRoomParams> {
  @override
  Future<DataState<List<RoomEntity>>> call(UpdateRoomParams param) async {
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
          }
          final result = await supabaseClient
              .from('rooms')
              .update(
                {
                  'name': param.name,
                  'description': param.description,
                  'room_image': param.image,
                  'updated_at': param.updatedAt,
                }
              ).match({'id': param.roomId,'user_id': userId});

          final List roomsData = await supabaseClient
              .from('rooms')
              .select('''*, users!inner(*)''')
              .eq('users.email', currentUser.email)
              .order('updated_at');

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
                  updatedAt: item['updated_at'],
                ),
              );
            }
          }

          return DataSuccess(rooms);
        } else {
          return DataFailed('خطا هنگام شناسایی کاربر!');
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
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }

}