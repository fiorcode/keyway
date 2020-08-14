import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];

  List<Item> get items => [..._items];

  Future<void> fetchAndSetItems() async {
    _items.clear();
    await _fetchAndSetAlpha();
    _items.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _fetchAndSetAlpha() async {
    final _alphaList = await DBHelper.getData('alpha');
    _items.addAll(_alphaList
        .map(
          (item) => AlphaItem(
            id: item['id'],
            title: item['title'],
            username: item['username'],
            password: item['password'],
            pin: item['pin'],
            ip: item['ip'],
            date: item['date'],
          ),
        )
        .toList());
    notifyListeners();
  }

  void addAlpha(AlphaItem item) {
    DBHelper.insert('alpha', {
      'title': item.title,
      'username': item.username,
      'password': item.password,
      'pin': item.pin,
      'ip': item.ip,
      'date': DateTime.now().toUtc().toIso8601String(),
    });
    fetchAndSetItems();
  }

  void updateAlpha(AlphaItem item) {
    DBHelper.update('alpha', item.toMap());
    fetchAndSetItems();
  }

  Future<void> deleteAlpha(int id) async {
    await DBHelper.delete('alpha', id); //THIS COULD FAIL
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void removeItems() {
    DBHelper.removeDB();
    _items.clear();
    notifyListeners();
  }
}
