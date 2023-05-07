import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRoomsUseCase extends OneParamUseCase<List<RoomEntity>, String> {

  final supabaseClient = Supabase.instance.client;

  @override
  Future<DataState<List<RoomEntity>>> call(String param) async {
    // param as `search term`
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        /// Finds all rows whose value in the stated column matches the supplied pattern (case sensitive).
        final List roomsData = await supabaseClient
            .from('rooms')
            .select('*')
            .like('name', '%$param%')
            .order('created_at')
            .limit(20);

        if (roomsData.isNotEmpty) {
          final List<RoomEntity> rooms = [];
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
          return DataSuccess(rooms);
        } else {
          return DataSuccess([]);
        }
      } else {
        return DataFailed('لطفاً اتصال به اینترنت را بررسی نمایید!');
      }
    } on PostgrestException catch(e) {
      debugPrint(e.message);
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }

}