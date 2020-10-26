import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String userDataTable = "user_data";
  static const String itemsTable = "items";
  static const String oldItemsTable = "old_items";
  static const String deletedItemsTable = "deleted_items";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'kw.db'),
        onCreate: (db, version) async {
      await db.execute(createItemsTable);
      await db.execute(createUserDataTable);
      await db.execute(createOldItemsTable);
      await db.execute(createDeletedItemsTable);
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

  static Future<List<Map<String, dynamic>>> getItemById(int id) async {
    final db = await DBHelper.database();
    return db.query(itemsTable, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getByValue(
    String table,
    String col,
    String val,
  ) async {
    final db = await DBHelper.database();
    return db.query(table, where: '$col = ?', whereArgs: [val]);
  }

  static Future checkRepeated(Map<String, Object> data) async {
    final db = await DBHelper.database();
    return await db.update(
      itemsTable,
      {'repeated': 'y'},
      where: 'password = ?',
      whereArgs: [data['password']],
    );
  }

  static Future deleteRepeated(Map<String, Object> data) async {
    final db = await DBHelper.database();
    await delete(itemsTable, data['id']);
    List<Map<String, dynamic>> _list =
        await getByValue(itemsTable, 'password', data['password']);
    if (_list.length < 2) {
      return await db.update(
        itemsTable,
        {'repeated': 'n'},
        where: 'password = ?',
        whereArgs: [data['password']],
      );
    }
  }

  static Future<void> removeDB() async {
    final dbPath = await sql.getDatabasesPath();
    File('$dbPath/kw.db').delete();
  }

  static const createUserDataTable = '''CREATE TABLE $userDataTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    surname TEXT,
    enc_mk TEXT)''';

  static const createItemsTable = '''CREATE TABLE $itemsTable(
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

  static const createOldItemsTable = '''CREATE TABLE $oldItemsTable(
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
    expired TEXT,
    item_id INTEGER)''';

  static const createDeletedItemsTable = '''CREATE TABLE $deletedItemsTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    password TEXT,
    pin TEXT,
    ip TEXT,
    date TEXT,
    date_short TEXT,
    date_deleted TEXT,
    color INTEGER,
    repeated TEXT,
    expired TEXT,
    item_id INTEGER)''';
}
