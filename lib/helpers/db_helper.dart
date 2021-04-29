import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String userDataTable = "user";
  static const String itemTable = "item";
  static const String usernameTable = "username";
  static const String passwordTable = "password";
  static const String pinTable = "pin";
  static const String longTextTable = "long_text";
  static const String oldPasswordPinTable = "old_password_pin";
  static const String deletedAlphaTable = "deleted_alpha";
  static const String tagTable = "tag";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'kw.db'),
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute(createItemTable);
        await db.execute(createUserTable);
        await db.execute(createTagTable);
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

  static Future<List<Map<String, dynamic>>> getItemsByTitle(
          String title) async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemTable
        WHERE title LIKE \'%$title%\'''');

  static Future<List<Map<String, dynamic>>> getUsernames() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
        $itemTable.username, $itemTable.username_iv
        FROM $itemTable 
        WHERE $itemTable.username <> ''
        GROUP BY $itemTable.username''');

  static Future<List<Map<String, dynamic>>> getTags() async =>
      (await DBHelper.database()).rawQuery('SELECT * FROM $tagTable');

  static Future<int> setPassStatus(
          String table, String pass, String status) async =>
      (await DBHelper.database()).update(
        table,
        {'password_status': status},
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

  static Future<int> setPassRepeted(String passwordHash) async =>
      await (await DBHelper.database()).rawUpdate(
        '''UPDATE 
        $itemTable
        SET password_status = ?
        WHERE password_hash = ? 
        AND password_status = ?''',
        ['REPEATED', '$passwordHash', ''],
      );

  static Future<int> unsetPassRepeted(String passwordHash) async =>
      await (await DBHelper.database()).rawUpdate(
        '''UPDATE $itemTable 
        SET password_status = ? 
        WHERE password_hash = ? AND password_status = ? 
        AND 1 = (SELECT COUNT(*) FROM $itemTable WHERE password_hash = ?) 
        AND 0 = (SELECT COUNT(*) FROM $oldPasswordPinTable WHERE password_pin_hash = ?) 
        AND 0 = (SELECT COUNT(*) FROM $deletedAlphaTable WHERE password_hash = ?)''',
        [
          '',
          '$passwordHash',
          'REPEATED',
          '$passwordHash',
          '$passwordHash',
          '$passwordHash'
        ],
      );

  static Future<int> setPinRepeted(String pinHash) async =>
      await (await DBHelper.database()).rawUpdate(
        '''UPDATE 
        $itemTable
        SET pin_status = ?
        WHERE pin_hash = ? 
        AND pin_status = ?''',
        ['REPEATED', '$pinHash', ''],
      );

  static Future<int> unsetPinRepeted(String pinHash) async =>
      await (await DBHelper.database()).rawUpdate(
        '''UPDATE $itemTable 
        SET pin_status = ? 
        WHERE pin_hash = ? AND pin_status = ? 
        AND 1 = (SELECT COUNT(*) FROM $itemTable WHERE pin_hash = ?) 
        AND 0 = (SELECT COUNT(*) FROM $oldPasswordPinTable WHERE pin_hash = ?) 
        AND 0 = (SELECT COUNT(*) FROM $deletedAlphaTable WHERE pin_hash = ?)''',
        ['', '$pinHash', 'REPEATED', '$pinHash', '$pinHash', '$pinHash'],
      );

  static Future<List<Map<String, dynamic>>> getAlphaWithOlds() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
      $itemTable.id, $itemTable.title,
      $itemTable.username, $itemTable.username_iv,
      $itemTable.password, $itemTable.password_iv, $itemTable.password_hash,
      $itemTable.password_date, $itemTable.password_lapse,
      $itemTable.password_status, $itemTable.password_level,
      $itemTable.pin, $itemTable.pin_iv, $itemTable.pin_hash, 
      $itemTable.pin_date, $itemTable.pin_lapse, $itemTable.pin_status,
      $itemTable.ip, $itemTable.ip_iv, $itemTable.long_text, $itemTable.long_text_iv,
      $itemTable.date, $itemTable.color, $itemTable.color_letter, $itemTable.font
      FROM $itemTable
      JOIN $oldPasswordPinTable ON $itemTable.id = $oldPasswordPinTable.item_id
      GROUP BY $itemTable.id''');

  static Future<List<Map<String, dynamic>>> getDeletedAlphaWithOlds() async =>
      (await DBHelper.database()).rawQuery('''SELECT 
        $deletedAlphaTable.id, $deletedAlphaTable.title,
        $deletedAlphaTable.username, $deletedAlphaTable.username_iv,
        $deletedAlphaTable.password, $deletedAlphaTable.password_iv, $deletedAlphaTable.password_hash,
        $deletedAlphaTable.password_date, $deletedAlphaTable.password_lapse, 
        $deletedAlphaTable.password_status, $deletedAlphaTable.password_level,
        $deletedAlphaTable.pin, $deletedAlphaTable.pin_iv, $deletedAlphaTable.pin_hash, 
        $deletedAlphaTable.pin_date, $deletedAlphaTable.pin_lapse, $deletedAlphaTable.pin_status,
        $deletedAlphaTable.ip, $deletedAlphaTable.ip_iv, $deletedAlphaTable.long_text, $deletedAlphaTable.long_text_iv,
        $deletedAlphaTable.date, $deletedAlphaTable.date_deleted, $deletedAlphaTable.font,
        $deletedAlphaTable.color, $deletedAlphaTable.color_letter, $deletedAlphaTable.item_id         
        FROM $deletedAlphaTable 
        JOIN $oldPasswordPinTable ON $deletedAlphaTable.item_id = $oldPasswordPinTable.item_id 
        GROUP BY $deletedAlphaTable.id''');

  static Future<void> removeTag(String tag) async =>
      (await DBHelper.database()).rawQuery('''
          UPDATE $itemTable 
          SET tags = REPLACE(tags, '<$tag>', '') 
          WHERE tags LIKE '%<$tag>%'
          ''');

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

  static const createUserTable = '''CREATE TABLE $userDataTable(
    mk_enc TEXT,
    mk_iv TEXT)''';

  static const createItemTable = '''CREATE TABLE $itemTable(
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    date TEXT,
    avatar_color INTEGER,
    avatar_letter_color INTEGER,
    font TEXT,
    status TEXT,
    tags TEXT,
    username_id INTEGER,
    password_id INTEGER,
    pin_id INTEGER,
    long_text_id INTEGER,
    FOREIGN KEY (username_id) REFERENCES $usernameTable (username_id),
    FOREIGN KEY (password_id) REFERENCES $passwordTable (password_id),
    FOREIGN KEY (pin_id) REFERENCES $pinTable (pin_id),
    FOREIGN KEY (long_text_id) REFERENCES $longTextTable (long_text_id))''';

  static const createUsernameTable = '''CREATE TABLE $usernameTable(
    username_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username_enc TEXT,
    username_iv TEXT)''';

  static const createPasswordTable = '''CREATE TABLE $passwordTable(
    password_id INTEGER PRIMARY KEY AUTOINCREMENT,
    password_enc TEXT,
    password_iv TEXT,
    password_date TEXT,
    password_lapse INTEGER,
    password_status TEXT,
    strength TEXT,
    hash TEXT)''';

  static const createPinTable = '''CREATE TABLE $pinTable(
    pin_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pin_enc TEXT,
    pin_iv TEXT,
    pin_date TEXT,
    pin_lapse INTEGER,
    pin_status TEXT)''';

  static const createLongTextTable = '''CREATE TABLE $longTextTable(
    long_text_id INTEGER PRIMARY KEY AUTOINCREMENT,
    long_text_enc TEXT,
    long_text_iv TEXT)''';

  static const createTagTable = '''CREATE TABLE $tagTable(
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    value TEXT)''';
}
