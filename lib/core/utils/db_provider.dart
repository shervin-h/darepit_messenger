import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart' as sync;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  DbProvider.internal();
  static final DbProvider _instance = DbProvider.internal();
  factory DbProvider() => _instance;

  final _lock = sync.Lock();

  static Database? _db;

  Future<Database> get db async {
    return _db ?? await initDb();
  }


  initDb() async {
    String path = await _preparingDbPath("flusher.db");
    await _lock.synchronized(() async {
      // Check again once entering the synchronized block
      _db ??= await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    });

    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    Batch batch = db.batch();

    batch.execute('''
      CREATE TABLE IF NOT EXISTS app_user(
        [id] INTEGER PRIMARY KEY AUTOINCREMENT, 
        [user_id] INTEGER NOT NULL UNIQUE,
        [email] VARCHAR(50) NOT NULL UNIQUE,
        [username] VARCHAR(50) NOT NULL DEFAULT '',
        [password] VARCHAR(50) NOT NULL DEFAULT '',
        [room] VARCHAR(50) NOT NULL DEFAULT '',
        [logout] BOOLEAN NOT NULL DEFAULT 1,
        [profile_image] TEXT NOT NULL DEFAULT '',
        [profile_image_public_url] TEXT NOT NULL DEFAULT '',
        [wallpaper] TEXT NOT NULL DEFAULT '',
        [asset_wallpaper] VARCHAR(20) NOT NULL DEFAULT '',
        [font_size] INTEGER NO NULL DEFAULT 14,
        [bubble_color] VARCHAR(20) NOT NULL DEFAULT 'white',
        [created_at] DATETIME NOT NULL DEFAULT current_timestamp,
        [updated_at] DATETIME NOT NULL DEFAULT current_timestamp
      )''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS app_config (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        is_dark BOOLEAN NOT NULL DEFAULT 0,
        language VARCHAR(2) NOT NULL DEFAULT 'fa'
      )
    ''');


    batch.execute('''
      CREATE TABLE IF NOT EXISTS visited_rooms(
        [id] INTEGER PRIMARY KEY AUTOINCREMENT, 
        [room_id] INTEGER NOT NULL UNIQUE,
        [user_id] INTEGER NOT NULL UNIQUE,
        [name] VARCHAR(100) NOT NULL DEFAULT '',
        [description] TEXT NOT NULL DEFAULT '',
        [room_image] TEXT NOT NULL DEFAULT '',
        [is_private] BOOLEAN NOT NULL DEFAULT 0,
        [private_key] TEXT NOT NULL DEFAULT '',
        [created_at] DATETIME NOT NULL DEFAULT current_timestamp,
        [updated_at] DATETIME NOT NULL DEFAULT current_timestamp
      )''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS users(
        [id] INTEGER PRIMARY KEY AUTOINCREMENT, 
        [user_id] INTEGER NOT NULL UNIQUE,
        [email] INTEGER NOT NULL UNIQUE,
        [username] VARCHAR(50) NOT NULL DEFAULT '',
        [profile_image] TEXT NOT NULL DEFAULT '',
        [profile_image_public_url] TEXT NOT NULL DEFAULT '',
        [created_at] DATETIME NOT NULL DEFAULT current_timestamp,
        [updated_at] DATETIME NOT NULL DEFAULT current_timestamp
      )''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS rooms(
        [id] INTEGER PRIMARY KEY AUTOINCREMENT, 
        [room_id] INTEGER NOT NULL UNIQUE,
        [user_id] INTEGER NOT NULL UNIQUE,
        [name] VARCHAR(100) NOT NULL DEFAULT '',
        [description] TEXT NOT NULL DEFAULT '',
        [room_image] TEXT NOT NULL DEFAULT '',
        [is_private] BOOLEAN NOT NULL DEFAULT 0,
        [private_key] TEXT NOT NULL DEFAULT '',
        [created_at] DATETIME NOT NULL DEFAULT current_timestamp,
        [updated_at] DATETIME NOT NULL DEFAULT current_timestamp
      )''');

    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {}

  Future<String> _preparingDbPath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    if (!(await Directory(dirname(path)).exists())) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    return path;
  }
}
