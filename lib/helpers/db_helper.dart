import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const createUserDataTable = '''CREATE TABLE user_data(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    surname TEXT,
    enc_mk TEXT)''';

  static const createAlphaItemTable = '''CREATE TABLE alpha(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    password TEXT,
    pin TEXT,
    ip TEXT,
    date TEXT)''';

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'kw.db'),
        onCreate: (db, version) async {
      await db.execute(createAlphaItemTable);
      await db.execute(createUserDataTable);
    }, version: 1);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    return await db
        .update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  static Future<void> delete(String table, int id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> restoreDB(File db) async {
    final dbPath = await sql.getDatabasesPath();
    File('$dbPath/kw.db').writeAsStringSync(db.readAsStringSync());
  }

  static Future<void> removeDB() async {
    final dbPath = await sql.getDatabasesPath();
    File('$dbPath/kw.db').delete();
  }
}
