import 'package:flusher/features/feature_messaging/domain/entities/chatter_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flusher/features/feature_messaging/domain/entities/user_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../core/utils/db_helper.dart';
import '../../../../../core/utils/db_provider.dart';




class AppUserProvider {
  static const String tableName = 'app_user';

  Future<UserEntity?> getAppUserData() async {
    try {
      DbHelper dbHelper = DbHelper();
      List<Map<String, dynamic>>? items = await dbHelper.getAllItem(tableName: tableName, distinct: false, limit: 1);
      if (items != null) {
        return UserEntity.fromJsonDb(items.first);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool> insertUser(UserEntity user, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.insert(tableName, user.toJsonDb(), conflictAlgorithm: conflictAlgorithm);
      List<Object?>  result = await batch.commit();
      return result.isNotEmpty ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateUser(UserEntity user, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, user.toJsonDb(), conflictAlgorithm: conflictAlgorithm, where: 'email = ?', whereArgs: [user.email]);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateUserData(Map<String, dynamic> data, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, data, conflictAlgorithm: conflictAlgorithm, where: 'email = ?', whereArgs: [data['email']]);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future rawUpdateLogoutUser(String email, int logout, {ConflictAlgorithm? conflictAlgorithm}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      int count = await dbClient.rawUpdate('UPDATE app_user SET logout = ? WHERE email = ?', [logout, email]);
      if (count > 0) {
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> logoutUser(String email, int logout, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, {'logout': logout}, where: 'email = ?', whereArgs: [email], conflictAlgorithm: conflictAlgorithm);
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateProfileImage(String email, String profileImage, {conflictAlgorithm = ConflictAlgorithm.replace}) async {
    try {
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, {'profile_image': profileImage}, where: 'email = ?', whereArgs: [email], conflictAlgorithm: conflictAlgorithm);
      List<Object?> result = await batch.commit();
      return result.isNotEmpty ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> updateWallpaper(String email, String wallpaper, {ConflictAlgorithm? conflictAlgorithm}) async {
    try {
      DbProvider dbProvider = DbProvider();
      Database dbClient = await dbProvider.db;
      Batch batch = dbClient.batch();
      batch.update(tableName, {'wallpaper': wallpaper}, where: 'email = ?', whereArgs: [email], conflictAlgorithm: conflictAlgorithm);
      List<Object?> result = await batch.commit();
      return result.isNotEmpty ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  /// Caching Another chatter's information -> users
  Future<bool> cacheChatterInfo(String email, ChatterEntity chatterEntity, {ConflictAlgorithm? conflictAlgorithm}) async {
    const String tableName = 'users';
    try {
      DbHelper dbHelper = DbHelper();
      DbProvider sql = DbProvider();
      Database dbClient = await sql.db;
      Batch batch = dbClient.batch();
      List<Map<String, dynamic>>? items = await dbHelper.getAllItem(
        tableName: tableName,
        where: 'email = $email',
        distinct: false,
        limit: 1,
      );
      if (items != null) {
        batch.update(tableName, chatterEntity.toJsonDb(), where: 'email = ?', whereArgs: [email] /*[chatterEntity.email]*/, conflictAlgorithm: conflictAlgorithm);
      } else {
        batch.insert(tableName, chatterEntity.toJsonDb(), conflictAlgorithm: conflictAlgorithm);
      }
      List<Object?> result = await batch.commit();
      return (result.isNotEmpty) ? true : false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> deleteTables() async {
    List<String> tables = ['app_user', 'app_config', 'visited_rooms', 'chatters_info'];
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