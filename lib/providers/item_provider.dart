import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:keyway/providers/cripto_provider.dart';

import '../helpers/db_helper.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _itemsWithHistory = [];
  List<Item> _itemHistory = [];
  List<Item> _deletedItems = [];

  List<Item> get items => [..._items];
  List<Item> get itemsWithHistory => [..._itemsWithHistory];
  List<Item> get itemHistory => [..._itemHistory];
  List<Item> get deletedItems => [..._deletedItems];

  Future<void> fetchItems() async {
    Iterable<Alpha> _iter;
    await DBHelper.getData(DBHelper.itemsTable).then((data) {
      _items.clear();
      _iter = data.map((e) => Alpha.fromMap(e));
    });
    _items.addAll(_iter.toList());
    await _checkExpirations();
    _items.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchItemsWithHistory() async {
    Iterable<OldAlpha> _iterIWH;
    Iterable<DeletedAlpha> _iterDIWH;
    _itemsWithHistory.clear();
    await DBHelper.getItemsWithHistory().then((data) {
      _iterIWH = data.map((e) => OldAlpha.fromMap(e));
    });
    _itemsWithHistory.addAll(_iterIWH.toList());
    await DBHelper.getDeletedItemsWithHistory().then((data) {
      _iterDIWH = data.map((e) => DeletedAlpha.fromMap(e));
    });
    _itemsWithHistory.addAll(_iterDIWH.toList());
    _itemsWithHistory.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchItemHistory(int itemId) async {
    Iterable<OldAlpha> _iterIH;
    await DBHelper.getByValue(DBHelper.oldsTable, 'item_id', itemId)
        .then((data) {
      _itemHistory.clear();
      _iterIH = data.map((e) => OldAlpha.fromMap(e));
    });
    _itemHistory.addAll(_iterIH.toList());
    _itemHistory.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchDeletedItems() async {
    Iterable<DeletedAlpha> _iterDI;
    await DBHelper.getData(DBHelper.deletedTable).then((data) {
      _deletedItems.clear();
      _iterDI = data.map((e) => DeletedAlpha.fromMap(e));
    });
    _deletedItems.addAll(_iterDI.toList());
    _deletedItems.sort((a, b) => b.date.compareTo(a.date));
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
      await DBHelper.setItemRepeated(column, value);

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
      if (_diff > 180 && i.expired != 'y') {
        i.expired = 'y';
        await DBHelper.update(DBHelper.itemsTable, i.toMap());
      }
      if (_diff <= 180 && i.expired == 'y') {
        i.expired = 'n';
        await DBHelper.update(DBHelper.itemsTable, i.toMap());
      }
    });
  }

  Future<void> mockData(CriptoProvider _cripto) async {
    List<String> _titles = [
      'Facebook',
      'Instagram',
      'Spotify',
      'Github',
      'Discord',
      'Google',
      'Steam',
      'Hotmail',
      'Siglo21'
    ];
    List<String> _users = [
      'FacebookUser',
      'InstagramUser',
      'SpotifyUser',
      'GithubUser',
      'DiscordUser',
      'GoogleUser',
      'SteamUser',
      'HotmailUser',
      'Siglo21User'
    ];
    List<String> _passes = [
      'FacebookPass',
      'InstagramPass',
      'SpotifyPass',
      'GithubPass',
      'DiscordPass',
      'GooglePass',
      'SteamPass',
      'HotmailPass',
      'Siglo21Pass'
    ];
    Random _ran = Random(59986674);
    DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
    _cripto.unlock('Qwe123!');
    for (int i = 0; i < _titles.length; i++) {
      DateTime _date = DateTime(2020, _ran.nextInt(11) + 1);
      insert(Alpha(
          title: _titles[i],
          username: _cripto.doCrypt(_users[i]),
          password: _cripto.doCrypt(_passes[i]),
          pin: '',
          ip: '',
          strong: _titles[i].contains('g') ? 'TRUE' : 'FALSE',
          date: _date.toIso8601String(),
          shortDate: dateFormat.format(_date),
          color: _ran.nextInt(4294967295),
          repeated: 'n',
          expired: _date.month < 7 ? 'y' : 'n'));
    }
  }

  void dispose() {
    super.dispose();
  }
}
