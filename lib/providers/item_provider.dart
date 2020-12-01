import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _oldItems = [];
  List<Item> _deletedItems = [];

  List<Item> get items => [..._items];
  List<Item> get oldItems => [..._oldItems];
  List<Item> get deletedItems => [..._deletedItems];

  Future<void> fetchAndSetItems() async {
    Iterable<Alpha> _iter;
    await DBHelper.getData(DBHelper.itemsTable).then((data) {
      _items.clear();
      _iter = data.map((e) => Alpha.fromMap(e));
    });
    _items.addAll(_iter.toList());
    await _checkExpirations();
    _items.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchAndSetOldItems() async {
    Iterable<Alpha> _iterOld;
    await DBHelper.getData(DBHelper.oldsTable).then((data) {
      _oldItems.clear();
      _iterOld = data.map((e) => Alpha.fromMap(e));
    });
    _oldItems.addAll(_iterOld.toList());
    _oldItems.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchAndSetDeletedItems() async {
    _deletedItems.clear();
    await _fetchAndSetDeleted();
    _deletedItems.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> _fetchAndSetDeleted() async {
    final _alphaList = await DBHelper.getData(DBHelper.deletedTable);
    _deletedItems
        .addAll(_alphaList.map((item) => Alpha.fromMap(item)).toList());
  }

  Future<void> insert(Alpha item) async =>
      await DBHelper.insert(DBHelper.itemsTable, item.toMap());

  Future<void> update(Alpha item) async =>
      await DBHelper.getItemById(item.id).then(
        (value) async {
          OldAlpha old = OldAlpha.fromAlpha(Alpha.fromMap(value.first));
          await DBHelper.insert(DBHelper.oldsTable, old.toMap());
          await DBHelper.update(DBHelper.itemsTable, item.toMap());
        },
      );

  Future<void> delete(Alpha item) async {
    if (item.repeated == 'n')
      await DBHelper.delete(DBHelper.itemsTable, item.id);
    else
      await DBHelper.refreshRepetedPassword(item.password);
    DeletedAlpha delete = DeletedAlpha.fromAlpha(item);
    await DBHelper.insert(DBHelper.deletedTable, delete.toMap());
    _items.removeWhere((element) => element.id == item.id);
  }

  Future<bool> verifyRepeatedPass(String s) async {
    if (s.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.itemsTable, 'password', s))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.oldsTable, 'password', s))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.deletedTable, 'password', s))
        .isNotEmpty) return true;
    return false;
  }

  Future<bool> verifyRepeatedPin(String p) async {
    if (p.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.itemsTable, 'pin', p)).isNotEmpty)
      return true;
    if ((await DBHelper.getByValue(DBHelper.oldsTable, 'pin', p)).isNotEmpty)
      return true;
    if ((await DBHelper.getByValue(DBHelper.deletedTable, 'pin', p)).isNotEmpty)
      return true;
    return false;
  }

  Future<void> setRepeated(String column, String value) async =>
      await DBHelper.setRepeated(column, value);

  Future<void> refreshRepetedPassword(String p) async {
    List<Map<String, dynamic>> _list =
        await DBHelper.getByValue(DBHelper.itemsTable, 'password', p);
    if (_list.length < 2) DBHelper.refreshRepetedPassword(p);
  }

  Future<void> removeItems() async => await DBHelper.removeDB();

  Future<void> _checkExpirations() async {
    _items.cast<Alpha>().forEach((i) async {
      i.dateTime = DateTime.parse(i.date);
      int _diff = i.dateTime.difference(DateTime.now()).inDays.abs();
      if (_diff > 2 && i.expired != 'y') {
        i.expired = 'y';
        await DBHelper.update('items', i.toMap());
      }
      if (_diff <= 2 && i.expired == 'y') {
        i.expired = 'n';
        await DBHelper.update('items', i.toMap());
      }
    });
  }

  void dispose() {
    super.dispose();
  }
}
