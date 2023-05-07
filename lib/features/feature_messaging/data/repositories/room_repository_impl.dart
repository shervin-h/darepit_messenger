import 'package:flusher/features/feature_messaging/data/sources/local/app_room_provider.dart';

import 'package:flusher/features/feature_messaging/domain/entities/room_entity.dart';

import '../../domain/repositories/room_repository.dart';

class RoomRepositoryImpl extends RoomRepository {
  @override
  Future<bool> deleteVisitedRoom({required int roomId}) {
    return AppRoomProvider().deleteVisitedRoom(roomId);
  }

  @override
  Future<bool> insertVisitedRoom({required RoomEntity roomEntity}) {
    return AppRoomProvider().insertVisitedRoom(roomEntity);
  }

  @override
  Future<bool> updateVisitedRoom({required RoomEntity roomEntity}) {
    return AppRoomProvider().updateVisitedRoom(roomEntity);
  }

  @override
  Future<bool> updateVisitedRoomData({required Map<String, dynamic> roomData}) {
    return AppRoomProvider().updateVisitedRoomData(roomData);
  }

  @override
  Future<List<RoomEntity>> fetchAllVisitedRooms() {
    return AppRoomProvider().fetchAllVisitedRooms();
  }

  @override
  Future<RoomEntity?> fetchVisitedRoom({required int roomId}) {
    return AppRoomProvider().fetchVisitedRoom(roomId);
  }

}