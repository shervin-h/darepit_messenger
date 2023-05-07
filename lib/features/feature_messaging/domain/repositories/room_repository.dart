import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';

import '../../../../core/resources/data_state.dart';

abstract class RoomRepository {
  Future<List<RoomEntity>> fetchAllVisitedRooms();
  Future<RoomEntity?> fetchVisitedRoom({required int roomId});
  Future<bool> insertVisitedRoom({required RoomEntity roomEntity});
  Future<bool> updateVisitedRoom({required RoomEntity roomEntity});
  Future<bool> updateVisitedRoomData({required Map<String, dynamic> roomData});
  Future<bool> deleteVisitedRoom({required int roomId});
}