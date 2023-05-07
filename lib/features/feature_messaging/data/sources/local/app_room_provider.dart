import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/utils/db_helper.dart';
import '../../../../../core/utils/db_provider.dart';
import '../../../domain/entities/room_entity.dart';

class AppRoomProvider {
  static const String tableName = 'visited_rooms';

  Future<List<RoomEntity>> fetchAllVisitedRooms() async {
    List<RoomEntity> rooms = [];
    try {
      DbHelper dbHelper = DbHelper();
      List<Map<String, dynamic>>? items = await dbHelper.getAllItem(tableName: tableName, distinct: false, limit: 0);
      if (items != null) {
        for (var item in items) {
          rooms.add(RoomEntity.fromJsonDb(item));
        }
        return rooms;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return rooms;
  }

  Future<RoomEntity?> fetchVisitedRoom(int roomId) async {
    try {
      DbHelper dbHelper = DbHelper();
      List<Map<String, dynamic>>? items = await dbHelper.getAllItem(tableName: tableName, where: 'room_id = $roomId', distinct: false, limit: 1);
      if (items != null) {
        return RoomEntity.fromJsonDb(items.first);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> insertVisitedRoom(RoomEntity room, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.insert(tableName, room.toJsonDb(), conflictAlgorithm: conflictAlgorithm);
      List<Object?>  result = await batch.commit();
      return result.isNotEmpty ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateVisitedRoom(RoomEntity room, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, room.toJsonDb(), conflictAlgorithm: conflictAlgorithm, where: 'room_id = ?', whereArgs: [room.roomId]);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateVisitedRoomData(Map<String, dynamic> data, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, data, conflictAlgorithm: conflictAlgorithm, where: 'room_id = ?', whereArgs: [data['room_id']]);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> deleteVisitedRoom(int roomId) async {
    try {
      Database dbClient = await DbProvider().db;
      Batch batch = dbClient.batch();
      batch.delete(tableName, where: 'room_id = ?', whereArgs: [roomId]);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> deleteVisitedRoomsTable() async {
    try {
      Database dbClient = await DbProvider().db;
      Batch batch = dbClient.batch();
      batch.delete(tableName);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> deleteTables() async {
    List<String> tables = ['app_user', 'app_config', 'visited_rooms'];
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      for (String tableName in tables) {
        batch.delete(tableName);
      }
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}