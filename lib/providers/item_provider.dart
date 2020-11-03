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

  fetchAndSetItems() async {
    _items.clear();
    await _fetchAndSet();
    await _checkExpirations();
    _items.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _fetchAndSet() async {
    List<Map<String, dynamic>> data =
        await DBHelper.getData(DBHelper.itemsTable);
    _items.addAll(data.map((item) => Alpha.fromMap(item)).toList());
  }

  fetchAndSetOldItems() async {
    _oldItems.clear();
    await _fetchAndSetOld();
    _oldItems.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  _fetchAndSetOld() async {
    final _alphaList = await DBHelper.getData(DBHelper.oldItemsTable);
    _oldItems.addAll(_alphaList.map((item) => Alpha.fromMap(item)).toList());
  }

  fetchAndSetDeletedItems() async {
    _deletedItems.clear();
    await _fetchAndSetDeleted();
    _deletedItems.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  _fetchAndSetDeleted() async {
    final _alphaList = await DBHelper.getData(DBHelper.deletedItemsTable);
    _deletedItems
        .addAll(_alphaList.map((item) => Alpha.fromMap(item)).toList());
  }

  insert(Alpha item) async {
    await DBHelper.insert(DBHelper.itemsTable, item.toMap());
    fetchAndSetItems();
  }

  update(Alpha item) async {
    await DBHelper.getItemById(item.id).then(
      (value) async {
        OldAlpha old = OldAlpha.fromAlpha(Alpha.fromMap(value.first));
        if (old.password != item.password || old.pin != item.pin) {
          await DBHelper.insert(DBHelper.oldItemsTable, old.toMap());
        }
      },
    );
    await DBHelper.update(DBHelper.itemsTable, item.toMap());
    fetchAndSetItems();
  }

  delete(Alpha item) async {
    if (item.repeated == 'n')
      await DBHelper.delete(DBHelper.itemsTable, item.id);
    else
      await DBHelper.deleteRepeated(item.toMap());
    DeletedAlpha delete = DeletedAlpha.fromAlpha(item);
    DBHelper.insert(DBHelper.deletedItemsTable, delete.toMap());
    _items.removeWhere((element) => element.id == item.id);
    fetchAndSetItems();
  }

  Future<bool> checkPassRepeated(String s) async {
    if ((await DBHelper.getByValue(DBHelper.itemsTable, 'password', s))
            .isNotEmpty ||
        (await DBHelper.getByValue(DBHelper.oldItemsTable, 'password', s))
            .isNotEmpty ||
        (await DBHelper.getByValue(DBHelper.deletedItemsTable, 'password', s))
            .isNotEmpty)
      return true;
    else
      return false;
  }

  insertRepeated(Alpha item) async {
    await DBHelper.insert('items', item.toMap());
    await DBHelper.checkRepeated(item.toMap());
    fetchAndSetItems();
  }

  updateRepeated(Alpha item) async {
    await DBHelper.update('items', item.toMap());
    await DBHelper.checkRepeated(item.toMap());
    fetchAndSetItems();
  }

  removeItems() async {
    await DBHelper.removeDB();
    fetchAndSetItems();
  }

  Future<void> _checkExpirations() async {
    _items.cast<Alpha>().forEach((i) async {
      i.expired = 'n';
      i.dateTime = DateTime.parse(i.date);
      if (i.dateTime.difference(DateTime.now()).inDays.abs() > 9) {
        i.expired = 'y';
      }
      await DBHelper.update('items', i.toMap());
    });
  }

  void dispose() {
    super.dispose();
  }
}
