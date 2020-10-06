import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => [..._items];

  fetchAndSetItems() async {
    _items.clear();
    await _fetchAndSetAlpha();
    await _checkExpirations();
    _items.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  _fetchAndSetAlpha() async {
    final _alphaList = await DBHelper.getData('alpha');
    _items.addAll(_alphaList.map((item) => AlphaItem.fromMap(item)).toList());
  }

  insertAlpha(AlphaItem item) async {
    await DBHelper.insert('alpha', item.toMap());
    fetchAndSetItems();
  }

  updateAlpha(AlphaItem item) async {
    await DBHelper.update('alpha', item.toMap());
    fetchAndSetItems();
  }

  deleteAlpha(AlphaItem item) async {
    if (item.repeated == 'n')
      await DBHelper.delete('alpha', item.id);
    else
      await DBHelper.deleteRepeated(item.toMap());
    _items.removeWhere((element) => element.id == item.id);
    fetchAndSetItems();
  }

  Future<bool> checkPassRepeated(String s) async {
    final _result = await DBHelper.getByValue('alpha', 'password', s);
    if (_result.isNotEmpty)
      return true;
    else
      return false;
  }

  _checkExpirations() async {
    _items.cast<AlphaItem>().forEach((i) async {
      i.expired = 'n';
      i.dateTime = DateTime.parse(i.date);
      if (i.dateTime.difference(DateTime.now()).inMinutes.abs() > 10) {
        i.expired = 'y';
        await DBHelper.update('alpha', i.toMap());
      }
    });
  }

  insertRepeated(AlphaItem item) async {
    await DBHelper.insert('alpha', item.toMap());
    await DBHelper.updateRepeated(item.toMap());
    fetchAndSetItems();
  }

  deleteRepeated(AlphaItem item) async {
    await DBHelper.deleteRepeated(item.toMap());
    fetchAndSetItems();
  }

  removeItems() async {
    await DBHelper.removeDB();
    fetchAndSetItems();
  }
}
