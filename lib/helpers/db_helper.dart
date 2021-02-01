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
    return await File('$_dbPath/kw.db').length();
  }

  static Future<DateTime> dbLastModified() async {
    final _dbPath = await sql.getDatabasesPath();
    return File('$_dbPath/kw.db').lastModified();
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async =>
      (await DBHelper.database()).query(table);

  static Future<int> insert(String table, Map<String, Object> data) async =>
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
        $alphaTable.username, $alphaTable.username_iv
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

  static Future<int> setPassRepeted(String table, String passwordHash) async =>
      await (await DBHelper.database()).rawUpdate(
        '''UPDATE 
        $table
        SET pass_status = ?
        WHERE password_hash = ? 
        AND pass_status = ?''',
        ['REPEATED', '$passwordHash', ''],
      );

  static Future<int> setPinRepeted(String table, String pinHash) async =>
      await (await DBHelper.database()).rawUpdate(
        '''UPDATE 
        $table
        SET pin_status = ?
        WHERE pin_hash = ? 
        AND pin_status = ?''',
        ['REPEATED', '$pinHash', ''],
      );

  static Future<List<Map<String, dynamic>>> repeatedAlpha(String p) async =>
      (await DBHelper.database()).rawQuery(
        '''SELECT *
        FROM $alphaTable
        WHERE password = ?
        AND pass_status = ?''',
        ['$p', 'REPEATED'],
      );

  static Future<List<Map<String, dynamic>>> getAlphaWithOlds() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
      $alphaTable.id, $alphaTable.title,
      $alphaTable.username, $alphaTable.username_iv, $alphaTable.username_hash,
      $alphaTable.password, $alphaTable.password_iv, $alphaTable.password_hash,
      $alphaTable.password_date, $alphaTable.password_lapse,
      $alphaTable.password_status, $alphaTable.password_level,
      $alphaTable.pin, $alphaTable.pin_iv, $alphaTable.pin_hash, 
      $alphaTable.pin_date, $alphaTable.pin_lapse, $alphaTable.pin_status,
      $alphaTable.ip, $alphaTable.ip_iv, $alphaTable.ip_hash, 
      $alphaTable.long_text, $alphaTable.long_text_iv, $alphaTable.long_text_hash,
      $alphaTable.date, $alphaTable.date_short, $alphaTable.color, $alphaTable.color_letter
      FROM $alphaTable
      JOIN $oldAlphaTable ON $alphaTable.id = $oldAlphaTable.item_id
      GROUP BY $alphaTable.id''');

//LEFT JOIN??
  static Future<List<Map<String, dynamic>>> getDeletedAlphaWithOlds() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
        $deletedAlphaTable.id, $deletedAlphaTable.title,
        $deletedAlphaTable.username, $deletedAlphaTable.username_iv, $deletedAlphaTable.username_hash,
        $deletedAlphaTable.password, $deletedAlphaTable.password_iv, $deletedAlphaTable.password_hash,
        $deletedAlphaTable.password_date, $deletedAlphaTable.password_lapse, 
        $deletedAlphaTable.password_status, $deletedAlphaTable.password_level,
        $deletedAlphaTable.pin, $deletedAlphaTable.pin_iv, $deletedAlphaTable.pin_hash, 
        $deletedAlphaTable.pin_date, $deletedAlphaTable.pin_lapse, $deletedAlphaTable.pin_status,
        $deletedAlphaTable.ip, $deletedAlphaTable.ip_iv, $deletedAlphaTable.ip_hash,
        $deletedAlphaTable.long_text, $deletedAlphaTable.long_text_iv, $deletedAlphaTable.long_text_hash,
        $deletedAlphaTable.date, $deletedAlphaTable.date_short, $deletedAlphaTable.date_deleted, 
        $deletedAlphaTable.color, $deletedAlphaTable.color_letter, $deletedAlphaTable.item_id         
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
    encrypted_mk TEXT,
    mk_iv)''';

  static const createAlphaTable = '''CREATE TABLE $alphaTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    username TEXT,
    username_iv TEXT,
    username_hash TEXT,
    password TEXT,
    password_iv TEXT,
    password_hash TEXT,
    password_date TEXT,
    password_lapse TEXT,
    password_status TEXT,
    password_level TEXT,
    pin TEXT,
    pin_iv TEXT,
    pin_hash TEXT,
    pin_date TEXT,
    pin_lapse TEXT,
    pin_status TEXT,
    ip TEXT,
    ip_iv TEXT,
    ip_hash TEXT,
    long_text TEXT,
    long_text_iv TEXT,
    long_text_hash TEXT,
    date TEXT,
    date_short TEXT,
    color INTEGER,
    color_letter INTEGER)''';

  static const createOldAlphaTable = '''CREATE TABLE $oldAlphaTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    title_change TEXT,
    username TEXT,
    username_iv TEXT,
    username_hash TEXT,
    username_change TEXT,
    password TEXT,
    password_iv TEXT,
    password_hash TEXT,
    password_date TEXT,
    password_lapse TEXT,
    password_status TEXT,
    password_level TEXT,
    password_change TEXT,
    pin TEXT,
    pin_iv TEXT,
    pin_hash TEXT,
    pin_date TEXT,
    pin_lapse TEXT,
    pin_status TEXT,
    pin_change TEXT,
    ip TEXT,
    ip_iv TEXT,
    ip_hash TEXT,
    ip_change TEXT,
    long_text TEXT,
    long_text_iv TEXT,
    long_text_hash TEXT,
    long_text_change TEXT,
    date TEXT,
    date_short TEXT,
    color INTEGER,
    color_letter INTEGER,
    item_id INTEGER)''';

  static const createDeletedAlphaTable = '''CREATE TABLE $deletedAlphaTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,    
    username TEXT,
    username_iv TEXT,
    username_hash TEXT,
    password TEXT,
    password_iv TEXT,
    password_hash TEXT,
    password_date TEXT,
    password_lapse TEXT,
    password_status TEXT,
    password_level TEXT,
    pin TEXT,
    pin_iv TEXT,
    pin_hash TEXT,
    pin_date TEXT,
    pin_lapse TEXT,
    pin_status TEXT,
    ip TEXT,
    ip_iv TEXT,
    ip_hash TEXT,
    long_text TEXT,
    long_text_iv TEXT,
    long_text_hash TEXT,
    date TEXT,
    date_short TEXT,
    date_deleted TEXT,
    color INTEGER,
    color_letter INTEGER,
    item_id INTEGER)''';
}
