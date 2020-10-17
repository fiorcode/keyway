import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'kw.db'),
        onCreate: (db, version) async {
      await db.execute(createAlphaTable);
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

  static Future<List<Map<String, dynamic>>> getByValue(
      String table, String col, String val) async {
    final db = await DBHelper.database();
    return db.query(table, where: '$col = ?', whereArgs: [val]);
  }

  static Future<void> removeDB() async {
    final dbPath = await sql.getDatabasesPath();
    File('$dbPath/kw.db').delete();
  }

  static Future checkRepeated(Map<String, Object> data) async {
    final db = await DBHelper.database();
    return await db.update(
      'alpha',
      {'repeated': 'y'},
      where: 'password = ?',
      whereArgs: [data['password']],
    );
  }

  static Future deleteRepeated(Map<String, Object> data) async {
    final db = await DBHelper.database();
    await delete('alpha', data['id']);
    List<Map<String, dynamic>> _list =
        await getByValue('alpha', 'password', data['password']);
    if (_list.length < 2) {
      return await db.update(
        'alpha',
        {'repeated': 'n'},
        where: 'password = ?',
        whereArgs: [data['password']],
      );
    }
  }

  static const createUserDataTable = '''CREATE TABLE user_data(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    surname TEXT,
    enc_mk TEXT)''';

  static const createAlphaTable = '''CREATE TABLE alpha(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    password TEXT,
    pin TEXT,
    ip TEXT,
    date TEXT,
    date_short TEXT,
    color INTEGER,
    repeated TEXT,
    expired TEXT)''';
}
