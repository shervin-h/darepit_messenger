import 'package:flusher/core/resources/data_state.dart';
import 'package:flusher/core/usecases/use_case.dart';
import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/does_the_user_have_access_to_delete_room.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/fetch_user_rooms_use_case.dart';
import 'package:flusher/features/feature_messaging/domain/usecases/is_online_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteRoomUseCase extends OneParamUseCase<List<RoomEntity>, RoomEntity> {
  @override
  Future<DataState<List<RoomEntity>>> call(RoomEntity param) async {
    try {
      final isConnected = await IsOnlineUseCase()();
      if (isConnected is DataSuccess) {
        final accessResult = await DoesTheUserHaveAccessToDeleteRoom()(param.roomId);
        if (accessResult is DataSuccess && accessResult.data != null) {
          final supabaseClient = Supabase.instance.client;

          /// delete() should always be combined with Filters to target the item(s) you wish to delete.
          final result = await supabaseClient
              .from('rooms')
              .delete()
              .match({'id': param.roomId, 'user_id': accessResult.data!['user_id']});

          final dataState = await FetchUserRoomsUseCase()(accessResult.data!['email']);
          if (dataState is DataSuccess && dataState.data != null) {
            return DataSuccess(dataState.data!);
          }
          return DataSuccess([]);
        } else {
          return DataFailed('دسترسی حذف اتاق را ندارید!');
        }
      } else {
        return DataFailed('ارتباط با سرور برقرار نیست! لطفاً اتصال را چک کنید ...');
      }
    } on PostgrestException catch (e) {
      debugPrint(e.toString());
      return DataFailed(e.message);
    } catch (e) {
      debugPrint(e.toString());
      return DataFailed('خطای نامشخص!');
    }
  }

}