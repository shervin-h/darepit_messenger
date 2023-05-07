import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';

class DbHelper {
  Future<int> getRowNumber({required String tableName}) async {
    DbProvider dbProvider = DbProvider();
    var dbClient = await dbProvider.db;
    String query = 'COUNT(*)';

    List result = [];
    await dbClient.transaction((txn) async {
      result = await txn.rawQuery(query);
    });

    if (result.isNotEmpty) {
      return result.length;
    }
    return 0;
  }

  Future<List<Map<String, dynamic>>?> getAllItem({
    required String tableName,
    required bool distinct,
    required int limit,
    String? fields,
    String? where,
    String? order,
    String? groupBy,
    String? having,
  }) async {
    DbProvider sql = DbProvider();
    Database dbClient = await sql.db;
    List<Map<String, dynamic>>? result = [];
    String query = "SELECT ${distinct ? "DISTINCT" : ""} ${fields ?? "*"} FROM $tableName ${where == null ? "" : " WHERE $where"} ${groupBy == null ? "" : "GROUP BY $groupBy"} ${having == null ? "" : "HAVING $having"} ${order == null ? "" : "ORDER BY $order"} ${limit == 0 ? "" : "LIMIT $limit"}";
    await dbClient.transaction((txn) async {
      result = await txn.rawQuery(query);
    });
    return (result != null && result!.isNotEmpty) ? result : null;
  }

  Future<int?> getCount(String tableName) async {
    DbProvider sql = DbProvider();
    var dbClient = await sql.db;
    return Sqflite.firstIntValue(await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }
}
