import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String userTable = "user";
  static const String itemTable = "item";
  static const String itemPasswordTable = "item_password";
  static const String passwordTable = "password";
  static const String usernameTable = "username";
  static const String pinTable = "pin";
  static const String longTextTable = "long_text";
  static const String addressTable = "address";
  static const String productTable = "product";
  static const String cpe23uriTable = "cpe23uri";
  static const String productCpe23uriTable = "product_cpe23uri";
  static const String cpe23uriCveTable = "cpe23uri_cve";
  static const String cveTable = "cve";
  static const String cveImpactV3Table = "cve_impact_v3";
  static const String tagTable = "tag";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'kw.db'),
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute(createUserTable);
        await db.execute(createItemTable);
        await db.execute(createItemPasswordTable);
        await db.execute(createPasswordTable);
        await db.execute(createUsernameTable);
        await db.execute(createPinTable);
        await db.execute(createLongTextTable);
        await db.execute(createAddressTable);
        await db.execute(createProductTable);
        await db.execute(createCpe23uriTable);
        await db.execute(createProductCpe23uriTable);
        await db.execute(createCpe23uriCveTable);
        await db.execute(createCveTable);
        await db.execute(createCveImpactV3Table);
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

  static Future<int> insert(String table, Map<String, Object> data) async =>
      (await DBHelper.database()).insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.fail,
      );

  static Future<List<Map<String, dynamic>>> read(String table) async =>
      (await DBHelper.database()).query(table);

  static Future<int> update(
          String table, Map<String, Object> data, String idName) async =>
      (await DBHelper.database()).update(
        table,
        data,
        where: '$idName = ?',
        whereArgs: [data[idName]],
      );

  static Future<int> delete(
          String table, Map<String, Object> data, String idName) async =>
      (await DBHelper.database()).delete(
        table,
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

  static Future<int> deleteItemPassword(Map<String, Object> data) async =>
      (await DBHelper.database()).delete(
        itemPasswordTable,
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

  static Future<List<Map<String, dynamic>>> getAdressById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.addressTable,
      where: 'address_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getProductById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.productTable,
      where: 'product_id = ?',
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
    fk_address_id INTEGER,
    fk_product_id INTEGER,
    FOREIGN KEY (fk_username_id) REFERENCES $usernameTable (username_id),
    FOREIGN KEY (fk_pin_id) REFERENCES $pinTable (pin_id),
    FOREIGN KEY (fk_long_text_id) REFERENCES $longTextTable (long_text_id),
    FOREIGN KEY (fk_address_id) REFERENCES $addressTable (address_id),
    FOREIGN KEY (fk_product_id) REFERENCES $productTable (product_id))''';

  static const createPasswordTable = '''CREATE TABLE $passwordTable(
    password_id INTEGER PRIMARY KEY AUTOINCREMENT,
    password_enc TEXT,
    password_iv TEXT,
    password_strength TEXT,
    password_hash TEXT)''';

  static const createItemPasswordTable = '''CREATE TABLE $itemPasswordTable(
    fk_item_id INTEGER,
    fk_password_id INTEGER,
    password_lapse INTEGER,
    password_status TEXT,
    password_date TEXT,
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

  //TODO: replace long_text for note
  static const createLongTextTable = '''CREATE TABLE $longTextTable(
    long_text_id INTEGER PRIMARY KEY AUTOINCREMENT,
    long_text_enc TEXT,
    long_text_iv TEXT)''';

  static const createAddressTable = '''CREATE TABLE $addressTable(
    address_id INTEGER PRIMARY KEY AUTOINCREMENT,
    address_enc TEXT,
    address_iv TEXT,
    address_protocol TEXT,
    address_port INTEGER)''';

  static const createProductTable = '''CREATE TABLE $productTable(
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_type TEXT,
    product_trademark TEXT,
    product_model TEXT,
    product_version TEXT,
    product_update TEXT,
    product_status TEXT)''';

  static const createCpe23uriTable = '''CREATE TABLE $cpe23uriTable(
    cpe23uri_id INTEGER PRIMARY KEY AUTOINCREMENT,
    value TEXT,
    deprecated INTEGER,
    last_modified_date TEXT,
    title TEXT,
    ref TEXT,
    ref_type TEXT,
    last_tracking TEXT)''';

  static const createProductCpe23uriTable =
      '''CREATE TABLE $productCpe23uriTable(
    fk_product_id INTEGER,
    fk_cpe23uri_id INTEGER,
    PRIMARY KEY (fk_product_id, fk_cpe23uri_id),
    FOREIGN KEY (fk_product_id) REFERENCES $productTable (product_id),
    FOREIGN KEY (fk_cpe23uri_id) REFERENCES $cpe23uriTable (cpe23uri_id))''';

  static const createCpe23uriCveTable = '''CREATE TABLE $cpe23uriCveTable(
    fk_cpe23uri_id INTEGER,
    fk_cve_id INTEGER,
    PRIMARY KEY (fk_cpe23uri_id, fk_cve_id),
    FOREIGN KEY (fk_cpe23uri_id) REFERENCES $cpe23uriTable (cpe23uri_id),
    FOREIGN KEY (fk_cve_id) REFERENCES $cveTable (cve_id))''';

  static const createCveTable = '''CREATE TABLE $cveTable(
    cve_id TEXT PRIMARY KEY,
    assigner TEXT,
    references_url TEXT,
    descriptions TEXT,
    published_date TEXT,
    last_modified_date TEXT,
    fk_cve_impact_v3_id INTEGER,
    FOREIGN KEY (fk_cve_impact_v3_id) REFERENCES $cveImpactV3Table (cve_impact_v3_id))''';

  static const createCveImpactV3Table = '''CREATE TABLE $cveImpactV3Table(
    cve_impact_v3_id INTEGER PRIMARY KEY AUTOINCREMENT,
    exploitability_score REAL,
    impact_score REAL,
    attack_vector TEXT,
    attack_complexity TEXT,
    privileges_required TEXT,
    user_interaction TEXT,
    scope TEXT,
    confidentiality_impact TEXT,
    integrity_impact TEXT,
    availability_impact TEXT,
    base_score REAL,
    base_severity REAL)''';

  static const createTagTable = '''CREATE TABLE $tagTable(
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT)''';
}
