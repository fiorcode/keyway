import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => [..._items];

  Future fetchAndSetItems() async {
    _items.clear();
    await _fetchAndSetAlpha();
    _items.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future _fetchAndSetAlpha() async {
    final _alphaList = await DBHelper.getData('alpha');
    _items.addAll(_alphaList.map((item) => AlphaItem.fromMap(item)).toList());
  }

  addAlpha(AlphaItem item) async {
    await DBHelper.insert('alpha', item.toMap());
    fetchAndSetItems();
  }

  updateAlpha(AlphaItem item) async {
    await DBHelper.update('alpha', item.toMap());
    fetchAndSetItems();
  }

  Future deleteAlpha(int id) async {
    await DBHelper.delete('alpha', id); //THIS COULD FAIL
    _items.removeWhere((element) => element.id == id);
    fetchAndSetItems();
  }

  Future<bool> checkPassRepeated(String s) async {
    final _result = await DBHelper.getByValue('alpha', 'password', s);
    if (_result.isNotEmpty)
      return true;
    else
      return false;
  }

  Future checkRepeated() async {
    List<AlphaItem> _alphaItems = _items.cast<AlphaItem>();
    _alphaItems.sort((a, b) => b.password.compareTo(a.password));
  }

  removeItems() async {
    await DBHelper.removeDB();
    fetchAndSetItems();
  }
}
