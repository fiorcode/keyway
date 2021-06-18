import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String userTable = "user";
  static const String itemTable = "item";
  static const String usernameTable = "username";
  static const String passwordTable = "password";
  static const String pinTable = "pin";
  static const String longTextTable = "long_text";
  static const String adressTable = "adress";
  static const String deviceTable = "device";
  static const String itemPasswordTable = "item_password";
  static const String tagTable = "tag";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'kw.db'),
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute(createUserTable);
        await db.execute(createItemTable);
        await db.execute(createUsernameTable);
        await db.execute(createPasswordTable);
        await db.execute(createItemPasswordTable);
        await db.execute(createPinTable);
        await db.execute(createLongTextTable);
        await db.execute(createDeviceTable);
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

  static Future<int> update(
          String table, Map<String, Object> data, String idName) async =>
      (await DBHelper.database()).update(
        table,
        data,
        where: '$idName = ?',
        whereArgs: [data[idName]],
      );

  static Future<List<Map<String, dynamic>>> getActiveItems() async =>
      (await DBHelper.database()).query(
        itemTable,
        where: 'item_status = ?',
        whereArgs: [''],
      );

  static Future<List<Map<String, dynamic>>> getActiveItemsByTitle(
          String title) async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemTable
        WHERE title LIKE '%$title%' AND item_status = '' ''');

  static Future<List<Map<String, dynamic>>> getDeletedItems() async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemTable
        WHERE item_status LIKE '%<DELETED>%' ''');

  static Future<List<Map<String, dynamic>>> getDeletedItemsByTitle(
          String title) async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemTable
        WHERE title LIKE '%$title%' AND item_status = '' ''');

  static Future<int> updateItem(Map<String, Object> data) async =>
      (await DBHelper.database()).update(
        itemTable,
        data,
        where: 'item_id = ?',
        whereArgs: [data['item_id']],
      );

  static Future<int> updateItemPassword(Map<String, Object> data) async =>
      (await DBHelper.database()).update(
        itemPasswordTable,
        data,
        where: 'fk_item_id = ? AND fk_password_id = ?',
        whereArgs: [data['fk_item_id'], data['fk_password_id']],
      );

  static Future<void> refreshItemPasswordStatus(int passwordId) async =>
      (await DBHelper.database()).rawQuery(
        '''UPDATE $itemPasswordTable 
        SET password_status = ? 
        WHERE password_status = ? 
        AND fk_password_id = ?''',
        [
          'REPEATED',
          '',
          '$passwordId',
        ],
      );

  static Future<List<Map<String, dynamic>>> getById(
      String table, int id) async {
    return (await DBHelper.database()).query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getUsernameById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.usernameTable,
      where: 'username_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getPasswordById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.passwordTable,
      where: 'password_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getPinById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.pinTable,
      where: 'pin_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getLongTextById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.longTextTable,
      where: 'long_text_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getDeviceById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.deviceTable,
      where: 'device_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getByValue(
      String table, String column, dynamic value) async {
    return (await DBHelper.database()).query(
      table,
      where: '$column = ?',
      whereArgs: [value],
    );
  }

  static Future<List<Map<String, dynamic>>> getItemPass(int itemId) async {
    return (await DBHelper.database()).rawQuery('''SELECT * 
        FROM $itemPasswordTable 
        WHERE fk_item_id = $itemId''');
  }

  static Future<List<Map<String, dynamic>>> getTags() async =>
      (await DBHelper.database()).rawQuery('SELECT * FROM $tagTable');

  static Future<List<Map<String, dynamic>>> getItemsWithOldPasswords() async {
    List<Map<String, dynamic>> _list =
        await (await DBHelper.database()).rawQuery('''SELECT *
      FROM $itemTable
      JOIN $itemPasswordTable ON $itemTable.item_id = $itemPasswordTable.fk_item_id
      GROUP BY $itemPasswordTable.fk_item_id
      HAVING COUNT(fk_item_id) > 1''');
    return _list;
  }

  static Future<List<Map<String, dynamic>>> getItemAndOldPasswords(
      int itemId) async {
    List<Map<String, dynamic>> _list =
        await (await DBHelper.database()).rawQuery(
      '''SELECT *
      FROM $itemTable 
      INNER JOIN $itemPasswordTable ON $itemTable.item_id = $itemPasswordTable.fk_item_id 
      INNER JOIN $passwordTable ON $itemPasswordTable.fk_password_id = $passwordTable.password_id 
      WHERE $itemPasswordTable.fk_item_id = ? 
      ORDER BY $itemPasswordTable.date DESC 
      LIMIT -1 OFFSET 1''',
      [itemId],
    );
    return _list;
  }

  static Future<void> removeTag(String tag) async {
    (await DBHelper.database()).rawQuery('''
          UPDATE $itemTable 
          SET tags = REPLACE(tags, '<$tag>', '') 
          WHERE tags LIKE '%<$tag>%'
          ''');
  }

  static Future<void> deleteTag(Map<String, dynamic> tag) async {
    (await DBHelper.database()).delete(
      tagTable,
      where: 'tag_id = ?',
      whereArgs: [tag['tag_id']],
    );
  }

  static Future<bool> removeDB() async {
    try {
      sql.deleteDatabase(await sql.getDatabasesPath());
      return await (await SharedPreferences.getInstance()).clear();
    } catch (e) {
      throw e;
    }
  }

  static const createUserTable = '''CREATE TABLE $userTable(
    mk_enc TEXT,
    mk_iv TEXT)''';

  static const createItemTable = '''CREATE TABLE $itemTable(
    item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    date TEXT,
    avatar_color INTEGER,
    avatar_letter_color INTEGER,
    font TEXT,
    item_status TEXT,
    tags TEXT,
    fk_username_id INTEGER,
    fk_pin_id INTEGER,
    fk_long_text_id INTEGER,
    fk_adress_id INTEGER,
    FOREIGN KEY (fk_username_id) REFERENCES $usernameTable (username_id),
    FOREIGN KEY (fk_pin_id) REFERENCES $pinTable (pin_id),
    FOREIGN KEY (fk_long_text_id) REFERENCES $longTextTable (long_text_id),
    FOREIGN KEY (fk_adress_id) REFERENCES $adressTable (adress_id))''';

  static const createPasswordTable = '''CREATE TABLE $passwordTable(
    password_id INTEGER PRIMARY KEY AUTOINCREMENT,
    password_enc TEXT,
    password_iv TEXT,
    strength TEXT,
    hash TEXT)''';

  static const createItemPasswordTable = '''CREATE TABLE $itemPasswordTable(
    fk_item_id INTEGER,
    fk_password_id INTEGER,
    lapse INTEGER,
    password_status TEXT,
    date TEXT,
    PRIMARY KEY (fk_item_id, fk_password_id),
    FOREIGN KEY (fk_item_id) REFERENCES $itemTable (item_id),
    FOREIGN KEY (fk_password_id) REFERENCES $passwordTable (password_id))''';

  static const createUsernameTable = '''CREATE TABLE $usernameTable(
    username_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username_enc TEXT,
    username_iv TEXT,
    username_hash TEXT)''';

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

  static const createAdressTable = '''CREATE TABLE $adressTable(
    adress_id INTEGER PRIMARY KEY AUTOINCREMENT,
    protocol TEXT,
    value TEXT,
    port INTEGER,
    fk_device_id INTEGER,
    FOREIGN KEY (fk_device_id) REFERENCES $deviceTable (device_id))''';

  static const createDeviceTable = '''CREATE TABLE $deviceTable(
    device_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    vendor TEXT,
    product TEXT,
    version TEXT,
    update_code TEXT)''';

  static const createTagTable = '''CREATE TABLE $tagTable(
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT)''';
}
