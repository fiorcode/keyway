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
  static const String noteTable = "note";
  static const String addressTable = "address";
  static const String productTable = "product";
  static const String productCveTable = "product_cve";
  static const String cpe23uriTable = "cpe23uri";
  static const String cpe23uriCveTable = "cpe23uri_cve";
  static const String cveTable = "cve";
  static const String cveImpactV3Table = "cve_impact_v3";
  static const String tagTable = "tag";
  static const String backupTable = "backup";
  static const String _backupPath = "/keyway/backups";

  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'kw.db'),
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute(_createUserTable);
        await db.execute(_createItemTable);
        await db.execute(_createItemPasswordTable);
        await db.execute(_createPasswordTable);
        await db.execute(_createUsernameTable);
        await db.execute(_createPinTable);
        await db.execute(_createNoteTable);
        await db.execute(_createAddressTable);
        await db.execute(_createProductTable);
        await db.execute(_createProductCveTable);
        await db.execute(_createCpe23uriTable);
        await db.execute(_createCpe23uriCveTable);
        await db.execute(_createCveTable);
        await db.execute(_createCveImpactV3Table);
        await db.execute(_createTagTable);
        await db.execute(_createBackupTable);
      },
      version: 1,
    );
  }

  static Future<String> dbPath() => sql.getDatabasesPath();

  static Future<int> dbSize() async {
    final _dbPath = await sql.getDatabasesPath();
    return File('$_dbPath/kw.db').length();
  }

  static Future<DateTime> dbLastModified() async {
    final _dbPath = await sql.getDatabasesPath();
    return File('$_dbPath/kw.db').lastModified();
  }

  static Future<bool> createBackup(String path,
      {bool backupPath = true}) async {
    String _path = backupPath ? '$path$_backupPath' : path;
    Directory _dir = await Directory(_path).create(recursive: true);
    final _dbPath = await dbPath();
    final _localDB = File('$_dbPath/kw.db');
    _localDB.copySync(_dir.path + '/kw_backup.db');
    return true;
  }

  static Future<bool> restoreBackup(String filePath) async {
    File _backupFile = File(filePath);
    final _dbPath = await dbPath();
    _backupFile.copySync('$_dbPath/kw.db');
    return true;
  }

  static Future<int> insert(String table, Map<String, Object?> data) async =>
      (await DBHelper.database()).insert(
        table,
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.fail,
      );

  static Future<List<Map<String, dynamic>>> read(String table) async =>
      (await DBHelper.database()).query(table);

  static Future<int> update(
          String table, Map<String, Object?> data, String idName) async =>
      (await DBHelper.database()).update(
        table,
        data,
        where: '$idName = ?',
        whereArgs: [data[idName]],
      );

  static Future<int> delete(
          String table, Map<String, Object?> data, String idName) async =>
      (await DBHelper.database()).delete(
        table,
        where: '$idName = ?',
        whereArgs: [data[idName]],
      );

  static Future<List<Map<String, dynamic>>> getItems() async =>
      (await DBHelper.database()).rawQuery('''SELECT * FROM item
      LEFT JOIN item_password ON item.item_id=item_password.fk_item_id
      LEFT JOIN password ON item_password.fk_password_id=password_id
      LEFT JOIN username ON item.fk_username_id=username.username_id
      LEFT JOIN pin ON item.fk_pin_id=pin.pin_id
      LEFT JOIN note ON item.fk_note_id=note.note_id
      LEFT JOIN address ON item.fk_address_id=address.address_id
      LEFT JOIN product ON item.fk_product_id=product.product_id
      WHERE item_status NOT LIKE '%<deleted>%'
      AND (password_status LIKE '%<active>%'
      OR password_status IS NULL)
      ORDER BY date DESC''');

  static Future<List<Map<String, dynamic>>> getItemsWithCves() async =>
      (await DBHelper.database()).rawQuery('''SELECT * FROM item
      INNER JOIN product ON item.fk_product_id=product.product_id
      WHERE item_status NOT LIKE '%<deleted>%'
      ORDER BY date DESC''');

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

  static Future<List<Map<String, dynamic>>> getActiveItemsWithTag(
          String tagName) async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemTable
        WHERE tags LIKE '%$tagName%' AND item_status = '' ''');

  static Future<List<Map<String, dynamic>>> getDeletedItems() async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemTable
        WHERE item_status LIKE '%<deleted>%' ''');

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

  static Future<int> deleteProductItem(int? productId) async =>
      (await DBHelper.database()).update(
        itemTable,
        {'fk_product_id': null},
        where: 'fk_product_id = ?',
        whereArgs: [productId],
      );

  static Future<int> deleteAddressItem(int? addressId) async =>
      (await DBHelper.database()).update(
        itemTable,
        {'fk_address_id': null},
        where: 'fk_address_id = ?',
        whereArgs: [addressId],
      );

  static Future<int> deleteNoteItem(int? noteId) async =>
      (await DBHelper.database()).update(
        itemTable,
        {'fk_note_id': null},
        where: 'fk_note_id = ?',
        whereArgs: [noteId],
      );

  static Future<int> deletePinItem(int? pinId) async =>
      (await DBHelper.database()).update(
        itemTable,
        {'fk_pin_id': null},
        where: 'fk_pin_id = ?',
        whereArgs: [pinId],
      );

  static Future<int> deleteUsernameItem(int? usernameId) async =>
      (await DBHelper.database()).update(
        itemTable,
        {'fk_username_id': null},
        where: 'fk_username_id = ?',
        whereArgs: [usernameId],
      );

  static Future<int> deletePasswordItems(int? passwordId) async =>
      (await DBHelper.database()).delete(
        itemPasswordTable,
        where: 'fk_password_id = ?',
        whereArgs: [passwordId],
      );

  static Future<int> updateItemPassword(Map<String, Object?> data) async =>
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

  // static Future<void> setRepeated(int passwordId) async {
  //   (await DBHelper.database()).rawQuery('''
  //         UPDATE $itemPasswordTable
  //         SET password_status = REPLACE(tags, '<$tag>', '')
  //         WHERE tags LIKE '%<$tag>%'
  //         ''');
  // }

  // static Future<void> refreshItemPasswordStatus(int passwordId) async =>
  //     (await DBHelper.database()).rawQuery(
  //       '''UPDATE $itemPasswordTable
  //       SET password_status = ?
  //       WHERE password_status = ?
  //       AND fk_password_id = ?''',
  //       [
  //         'REPEATED',
  //         '',
  //         '$passwordId',
  //       ],
  //     );

  static Future<List<Map<String, dynamic>>> getById(
      String table, int id) async {
    return (await DBHelper.database()).query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getCveByName(String? cve) async {
    return (await DBHelper.database()).query(
      cveTable,
      where: 'cve = ?',
      whereArgs: [cve],
    );
  }

  static Future<List<Map<String, dynamic>>> getItemById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.itemTable,
      where: 'item_id = ?',
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

  static Future<List<Map<String, dynamic>>> getNoteById(int id) async {
    return (await DBHelper.database()).query(
      DBHelper.noteTable,
      where: 'note_id = ?',
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

  static Future<List<Map<String, dynamic>>> getProductsWithNoCpe() async =>
      (await DBHelper.database()).rawQuery('''SELECT *
        FROM $productTable
        WHERE fk_cpe23uri_id IS NULL''');

  static Future<List<Map<String, dynamic>>> getByValue(
      String table, String column, dynamic value) async {
    return (await DBHelper.database()).query(
      table,
      where: '$column = ?',
      whereArgs: [value],
    );
  }

  static Future<List<Map<String, dynamic>>> getItemPasswordsByItemId(
      int itemId) async {
    return (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemPasswordTable
        WHERE fk_item_id = $itemId''');
  }

  static Future<List<Map<String, dynamic>>> getItemPasswordsByPasswordId(
      int? passwordId) async {
    return (await DBHelper.database()).rawQuery('''SELECT *
        FROM $itemPasswordTable
        WHERE fk_password_id = $passwordId''');
  }

  static Future<List<Map<String, dynamic>>> getPasswordsByItemId(
      int? itemId) async {
    return (await DBHelper.database())
        .rawQuery('''SELECT * FROM $itemPasswordTable
        LEFT JOIN $passwordTable ON $itemPasswordTable.fk_password_id=password_id
        WHERE $itemPasswordTable.fk_item_id=$itemId
        ORDER BY password_date DESC
        LIMIT -1 OFFSET 1''');
  }

  static Future<List<Map<String, dynamic>>> getTags() async =>
      (await DBHelper.database()).rawQuery('SELECT * FROM $tagTable');

  static Future<List<Map<String, dynamic>>> getTagByName(String? n) async =>
      (await DBHelper.database()).query(
        tagTable,
        where: 'tag_name = ?',
        whereArgs: [n],
      );

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

  static Future<void> removeTag(String? tag) async {
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
    await sql.deleteDatabase(await sql.getDatabasesPath());
    return (await SharedPreferences.getInstance()).clear();
  }

  static const _createUserTable = '''CREATE TABLE $userTable(
    mk_enc TEXT,
    mk_iv TEXT)''';

  static const _createItemTable = '''CREATE TABLE $itemTable(
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
    fk_note_id INTEGER,
    fk_address_id INTEGER,
    fk_product_id INTEGER,
    FOREIGN KEY (fk_username_id) REFERENCES $usernameTable (username_id),
    FOREIGN KEY (fk_pin_id) REFERENCES $pinTable (pin_id),
    FOREIGN KEY (fk_note_id) REFERENCES $noteTable (note_id),
    FOREIGN KEY (fk_address_id) REFERENCES $addressTable (address_id),
    FOREIGN KEY (fk_product_id) REFERENCES $productTable (product_id))''';

  static const _createPasswordTable = '''CREATE TABLE $passwordTable(
    password_id INTEGER PRIMARY KEY AUTOINCREMENT,
    password_enc TEXT,
    password_iv TEXT,
    password_strength TEXT,
    password_hash TEXT)''';

  static const _createItemPasswordTable = '''CREATE TABLE $itemPasswordTable(
    fk_item_id INTEGER,
    fk_password_id INTEGER,
    password_date TEXT,
    password_lapse INTEGER,
    password_status TEXT)''';

  static const _createUsernameTable = '''CREATE TABLE $usernameTable(
    username_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username_enc TEXT,
    username_iv TEXT,
    username_hash TEXT)''';

  static const _createPinTable = '''CREATE TABLE $pinTable(
    pin_id INTEGER PRIMARY KEY AUTOINCREMENT,
    pin_enc TEXT,
    pin_iv TEXT,
    pin_date TEXT,
    pin_lapse INTEGER,
    pin_status TEXT)''';

  static const _createNoteTable = '''CREATE TABLE $noteTable(
    note_id INTEGER PRIMARY KEY AUTOINCREMENT,
    note_enc TEXT,
    note_iv TEXT)''';

  static const _createAddressTable = '''CREATE TABLE $addressTable(
    address_id INTEGER PRIMARY KEY AUTOINCREMENT,
    address_enc TEXT,
    address_iv TEXT,
    address_protocol TEXT,
    address_port INTEGER)''';

  static const _createProductTable = '''CREATE TABLE $productTable(
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_type TEXT,
    product_trademark TEXT,
    product_model TEXT,
    product_version TEXT,
    product_update TEXT,
    product_status TEXT,
    fk_cpe23uri_id INTEGER,
    FOREIGN KEY (fk_cpe23uri_id) REFERENCES $cpe23uriTable (cpe23uri_id))''';

  static const _createProductCveTable = '''CREATE TABLE $productCveTable(
    fk_product_id INTEGER,
    fk_cve_id INTEGER,
    patched INTEGER,
    PRIMARY KEY (fk_product_id, fk_cve_id),
    FOREIGN KEY (fk_product_id) REFERENCES $productTable (product_id),
    FOREIGN KEY (fk_cve_id) REFERENCES $cveTable (cve_id))''';

  static const _createCpe23uriTable = '''CREATE TABLE $cpe23uriTable(
    cpe23uri_id INTEGER PRIMARY KEY AUTOINCREMENT,
    value TEXT,
    deprecated INTEGER,
    last_modified_date TEXT,
    title TEXT,
    ref TEXT,
    ref_type TEXT,
    last_tracking TEXT)''';

  static const _createCpe23uriCveTable = '''CREATE TABLE $cpe23uriCveTable(
    fk_cpe23uri_id INTEGER,
    fk_cve_id INTEGER,
    PRIMARY KEY (fk_cpe23uri_id, fk_cve_id),
    FOREIGN KEY (fk_cpe23uri_id) REFERENCES $cpe23uriTable (cpe23uri_id),
    FOREIGN KEY (fk_cve_id) REFERENCES $cveTable (cve_id))''';

  static const _createCveTable = '''CREATE TABLE $cveTable(
    cve_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cve TEXT,
    assigner TEXT,
    references_url TEXT,
    descriptions TEXT,
    published_date TEXT,
    last_modified_date TEXT,
    fk_cve_impact_v3_id INTEGER,
    FOREIGN KEY (fk_cve_impact_v3_id) REFERENCES $cveImpactV3Table (cve_impact_v3_id))''';

  static const _createCveImpactV3Table = '''CREATE TABLE $cveImpactV3Table(
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

  static const _createTagTable = '''CREATE TABLE $tagTable(
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT,
    tag_color INTEGER)''';

  static const _createBackupTable = '''CREATE TABLE $backupTable(
    backup_id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_date TEXT,
    backup_type TEXT,
    backup_path TEXT)''';
}
