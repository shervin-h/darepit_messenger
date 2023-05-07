import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FetchUserRoomsUseCase extends OneParamUseCase<List<RoomEntity>, String?> {

  final supabase = Supabase.instance.client;

  @override
  Future<DataState<List<RoomEntity>>> call(String? param) async {
    // param: email
    try {
      if (param != null && param.trim().isNotEmpty) {
        final isConnected = await IsOnlineUseCase()();
        if (isConnected is DataSuccess) {
          /// If you want to filter a table based on a child table's values you can use the !inner() function.
          /// For example, if you wanted to select all rows in a room table
          /// which belong to a user with the email "shervin.hz07@gmail.com":
          final List roomsData = await supabase
              .from('rooms')
              .select('''*, users!inner(*)''')
              .eq('users.email', param)
              .order('updated_at');

          List<RoomEntity> rooms = [];
          if (roomsData.isNotEmpty) {
            for (var room in roomsData) {
              rooms.add(
                RoomEntity(
                  roomId: room['id'],
                  userId: room['user_id'],
                  name: room['name'],
                  description: room['description'],
                  roomImage: room['room_image'],
                  isPrivate: room['is_private'],
                  privateKey: room['private_key'],
                  createdAt: room['created_at'],
                  updatedAt: room['updated_at']
                ),
              );
            }
          }

          return DataSuccess(rooms);
        } else {
          return DataFailed('عدم برقراری ارتباط با سرور! لطفاً اتصال خود را چک کنید...');
        }
      } else {
        return DataSuccess([]);
      }
    } on PostgrestException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص !');
    }
  }

}