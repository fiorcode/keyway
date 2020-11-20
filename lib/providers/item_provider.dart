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
    _oldItems.clear();
    await _fetchAndSetOld();
    _oldItems.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> _fetchAndSetOld() async {
    final _alphaList = await DBHelper.getData(DBHelper.oldItemsTable);
    _oldItems.addAll(_alphaList.map((item) => Alpha.fromMap(item)).toList());
  }

  Future<void> fetchAndSetDeletedItems() async {
    _deletedItems.clear();
    await _fetchAndSetDeleted();
    _deletedItems.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> _fetchAndSetDeleted() async {
    final _alphaList = await DBHelper.getData(DBHelper.deletedItemsTable);
    _deletedItems
        .addAll(_alphaList.map((item) => Alpha.fromMap(item)).toList());
  }

  Future<void> insert(Alpha item) async =>
      await DBHelper.insert(DBHelper.itemsTable, item.toMap());

  Future<void> update(Alpha item) async =>
      await DBHelper.getItemById(item.id).then(
        (value) async {
          OldAlpha old = OldAlpha.fromAlpha(Alpha.fromMap(value.first));
          if (old.password != item.password || old.pin != item.pin) {
            await DBHelper.insert(DBHelper.oldItemsTable, old.toMap());
            await DBHelper.update(DBHelper.itemsTable, item.toMap());
            if (await repeatedPass(item.password))
              await DBHelper.setRepeated(item.toMap());
            else {
              if (item.repeated == 'y') {
                item.repeated = 'n';
                await DBHelper.update(DBHelper.itemsTable, item.toMap());
              }
            }
          }
        },
      );

  Future<void> delete(Alpha item) async {
    if (item.repeated == 'n')
      await DBHelper.delete(DBHelper.itemsTable, item.id);
    else
      await DBHelper.deleteRepeated(item.toMap());
    DeletedAlpha delete = DeletedAlpha.fromAlpha(item);
    await DBHelper.insert(DBHelper.deletedItemsTable, delete.toMap());
    _items.removeWhere((element) => element.id == item.id);
  }

  Future<bool> repeatedPass(String s) async {
    if ((await DBHelper.getByValue(DBHelper.itemsTable, 'password', s))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.oldItemsTable, 'password', s))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.deletedItemsTable, 'password', s))
        .isNotEmpty) return true;
    return false;
  }

  Future<bool> repeatedPin(String p) async {
    if ((await DBHelper.getByValue(DBHelper.itemsTable, 'pin', p)).isNotEmpty)
      return true;
    if ((await DBHelper.getByValue(DBHelper.oldItemsTable, 'pin', p))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.deletedItemsTable, 'pin', p))
        .isNotEmpty) return true;
    return false;
  }

  Future<void> insertRepeated(Alpha item) async {
    await DBHelper.insert('items', item.toMap());
    await DBHelper.setRepeated(item.toMap());
  }

  Future<void> updateRepeated(Alpha item) async {
    await DBHelper.update('items', item.toMap());
    await DBHelper.setRepeated(item.toMap());
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
