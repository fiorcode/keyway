import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String userDataTable = "user_data";
  static const String alphaTable = "alpha";
  static const String oldAlphaTable = "old_alpha";
  static const String deletedAlphaTable = "deleted_alpha";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'kw.db'),
      onCreate: (db, version) async {
        await db.execute(createAlphaTable);
        await db.execute(createUserDataTable);
        await db.execute(createOldAlphaTable);
        await db.execute(createDeletedAlphaTable);
      },
      version: 1,
    );
  }

  static Future<String> dbPath() async => await sql.getDatabasesPath();

  static Future<int> dbSize() async {
    final _dbPath = await sql.getDatabasesPath();
    return File('$_dbPath/kw.db').length();
  }

  static Future<DateTime> dbLastModified() async {
    final _dbPath = await sql.getDatabasesPath();
    return File('$_dbPath/kw.db').lastModified();
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async =>
      (await DBHelper.database()).query(table);

  static Future<void> insert(String table, Map<String, Object> data) async =>
      (await DBHelper.database()).insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );

  static Future<int> update(String table, Map<String, Object> data) async =>
      (await DBHelper.database()).update(
        table,
        data,
        where: 'id = ?',
        whereArgs: [data['id']],
      );

  static Future<void> delete(String table, int id) async =>
      (await DBHelper.database()).delete(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

  static Future<List<Map<String, dynamic>>> getById(
          String table, int id) async =>
      (await DBHelper.database()).query(
        table,
        where: 'id = ?',
        whereArgs: [id],
      );

  static Future<List<Map<String, dynamic>>> getByValue(
          String table, String col, dynamic value) async =>
      (await DBHelper.database()).query(
        table,
        where: '$col = ?',
        whereArgs: [value],
      );

  static Future<List<Map<String, dynamic>>> getUsernames() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
        $alphaTable.username
        FROM $alphaTable
        GROUP BY $alphaTable.username''');

  static Future<int> setPassStatus(
          String table, String pass, String status) async =>
      (await DBHelper.database()).update(
        table,
        {'pass_status': status},
        where: 'password = ?',
        whereArgs: [pass],
      );

  static Future<int> setPinStatus(
          String table, String pin, String status) async =>
      (await DBHelper.database()).update(
        table,
        {'pin_status': status},
        where: 'pin = ?',
        whereArgs: [pin],
      );

  static Future<void> setPassRepeted(String p) async =>
      (await DBHelper.database()).update(
        alphaTable,
        {'pass_status': 'REPEATED'},
        where: 'password = ? pass_status = ?',
        whereArgs: [p, ''],
      );

  static Future<List<Map<String, dynamic>>> getPassRepeted(String p) async =>
      (await DBHelper.database()).query(
        alphaTable,
        where: 'password = ?, pass_status = ?',
        whereArgs: [p, ''],
      );

  static Future<void> setPinRepeted(String p) async =>
      (await DBHelper.database()).update(
        alphaTable,
        {'pin_status': 'REPEATED'},
        where: 'pin = ?, pin_status = ?',
        whereArgs: [p, ''],
      );

  static Future<List<Map<String, dynamic>>> getAlphaWithOlds() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
        $alphaTable.id, $alphaTable.title, $alphaTable.username, 
        $alphaTable.password, $alphaTable.pin, $alphaTable.ip,
        $alphaTable.long_text, $alphaTable.date, $alphaTable.date_short, 
        $alphaTable.color, $alphaTable.color_letter, $alphaTable.pass_status,
        $alphaTable.pin_status, $alphaTable.pass_level, $alphaTable.expired, $alphaTable.expired_lapse 
        FROM $alphaTable 
        JOIN $oldAlphaTable ON $alphaTable.id = $oldAlphaTable.item_id 
        GROUP BY $alphaTable.id''');

  static Future<List<Map<String, dynamic>>> getDeletedAlphaWithOlds() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
        $deletedAlphaTable.id, $deletedAlphaTable.title, $deletedAlphaTable.username, 
        $deletedAlphaTable.password, $deletedAlphaTable.pin, $deletedAlphaTable.ip,
        $deletedAlphaTable.long_text, $deletedAlphaTable.date, $deletedAlphaTable.date_short, 
        $deletedAlphaTable.date_deleted, $deletedAlphaTable.color, $deletedAlphaTable.color_letter, 
        $deletedAlphaTable.pass_status, $deletedAlphaTable.pin_status, $deletedAlphaTable.pass_level,
        $deletedAlphaTable.expired, $deletedAlphaTable.expired_lapse, $deletedAlphaTable.item_id 
        FROM $deletedAlphaTable 
        JOIN $oldAlphaTable ON $deletedAlphaTable.item_id = $oldAlphaTable.item_id 
        GROUP BY $deletedAlphaTable.id''');

  static Future<bool> removeDB() async {
    try {
      final _dbPath = await sql.getDatabasesPath();
      sql.deleteDatabase(_dbPath);
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

  static const createAlphaTable = '''CREATE TABLE $alphaTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    password TEXT,
    pin TEXT,
    ip TEXT,
    long_text TEXT,
    date TEXT,
    date_short TEXT,
    color INTEGER,
    color_letter INTEGER,
    pass_status TEXT,
    pin_status TEXT,
    pass_level TEXT,
    expired TEXT,
    expired_lapse TEXT)''';

  static const createOldAlphaTable = '''CREATE TABLE $oldAlphaTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    password TEXT,
    pin TEXT,
    ip TEXT,
    long_text TEXT,
    date TEXT,
    date_short TEXT,
    color INTEGER,
    color_letter INTEGER,
    pass_status TEXT,
    pin_status TEXT,
    pass_level TEXT,
    expired TEXT,
    expired_lapse TEXT,
    item_id INTEGER)''';

  static const createDeletedAlphaTable = '''CREATE TABLE $deletedAlphaTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    password TEXT,
    pin TEXT,
    ip TEXT,
    long_text TEXT,
    date TEXT,
    date_short TEXT,
    date_deleted TEXT,
    color INTEGER,
    color_letter INTEGER,
    pass_status TEXT,
    pin_status TEXT,
    pass_level TEXT,
    expired TEXT,
    expired_lapse TEXT,
    item_id INTEGER)''';
}
