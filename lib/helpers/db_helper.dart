import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String userDataTable = "user_data";
  static const String itemsTable = "items";
  static const String oldsTable = "old_items";
  static const String deletedTable = "deleted_items";

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

  static Future<String> dbPath() async => await sql.getDatabasesPath();

  static Future<int> dbSize() async {
    final _dbPath = await sql.getDatabasesPath();
    File _localFile = File('$_dbPath/kw.db');
    return _localFile.length();
  }

  static Future<DateTime> dbLastModified() async {
    final _dbPath = await sql.getDatabasesPath();
    File _localFile = File('$_dbPath/kw.db');
    return _localFile.lastModified();
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
      String table, String col, dynamic v) async {
    final db = await DBHelper.database();
    return db.query(table, where: '$col = ?', whereArgs: [v]);
  }

  static Future<List<Map<String, dynamic>>> getUsernames() async {
    final db = await DBHelper.database();
    return await db.rawQuery('''SELECT 
        $itemsTable.username
        FROM $itemsTable
        GROUP BY $itemsTable.username''');
  }

  static Future<int> setItemRepeated(String column, String value) async {
    final db = await DBHelper.database();
    return await db.update(
      itemsTable,
      {'repeated': 'y'},
      where: '$column = ?',
      whereArgs: [value],
    );
  }

  static Future<void> refreshRepetedPassword(String p) async {
    final db = await DBHelper.database();
    return await db.update(
      itemsTable,
      {'repeated': 'n'},
      where: 'password = ?',
      whereArgs: [p],
    );
  }

  static Future<List<Map<String, dynamic>>> getItemsWithHistory() async {
    final db = await DBHelper.database();
    return await db.rawQuery('''SELECT 
        $itemsTable.id, $itemsTable.title, $itemsTable.username, 
        $itemsTable.password, $itemsTable.pin, $itemsTable.ip, 
        $itemsTable.date, $itemsTable.date_short, $itemsTable.color, 
        $itemsTable.repeated, $itemsTable.strong, $itemsTable.expired 
        FROM $itemsTable 
        JOIN $oldsTable ON $itemsTable.id = $oldsTable.item_id 
        GROUP BY $itemsTable.id''');
  }

  static Future<List<Map<String, dynamic>>> getDeletedItemsWithHistory() async {
    final db = await DBHelper.database();
    return await db.rawQuery('''SELECT 
        $deletedTable.id, $deletedTable.title, $deletedTable.username, 
        $deletedTable.password, $deletedTable.pin, $deletedTable.ip, 
        $deletedTable.date, $deletedTable.date_short, $deletedTable.color, 
        $deletedTable.repeated, $deletedTable.strong, $deletedTable.expired, $deletedTable.item_id 
        FROM $deletedTable 
        JOIN $oldsTable ON $deletedTable.item_id = $oldsTable.item_id 
        GROUP BY $deletedTable.id''');
  }

  static Future<bool> removeDB() async {
    try {
      // database().then((db) => db.close());
      final _dbPath = await sql.getDatabasesPath();
      sql.deleteDatabase(_dbPath);
      //File('$_dbPath/kw.db').delete();
      SharedPreferences _pref = await SharedPreferences.getInstance();
      return await _pref.clear();
    } catch (e) {
      throw e;
    }
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
    strong TEXT,
    expired TEXT)''';

  static const createOldItemsTable = '''CREATE TABLE $oldsTable(
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
    strong TEXT,
    expired TEXT,
    item_id INTEGER)''';

  static const createDeletedItemsTable = '''CREATE TABLE $deletedTable(
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
    strong TEXT,
    expired TEXT,
    item_id INTEGER)''';
}
