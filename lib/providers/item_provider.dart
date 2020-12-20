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
    await DBHelper.getData(DBHelper.alphaTable).then((data) {
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
    await DBHelper.getAlphaWithOlds().then((data) {
      _iterIWH = data.map((e) => OldAlpha.fromMap(e));
    });
    _itemsWithHistory.addAll(_iterIWH.toList());
    await DBHelper.getDeletedAlphaWithOlds().then((data) {
      _iterDIWH = data.map((e) => DeletedAlpha.fromMap(e));
    });
    _itemsWithHistory.addAll(_iterDIWH.toList());
    _itemsWithHistory.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchItemHistory(int itemId) async {
    Iterable<OldAlpha> _iterIH;
    await DBHelper.getByValue(DBHelper.oldAlphaTable, 'item_id', itemId)
        .then((data) {
      _itemHistory.clear();
      _iterIH = data.map((e) => OldAlpha.fromMap(e));
    });
    _itemHistory.addAll(_iterIH.toList());
    _itemHistory.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchDeletedItems() async {
    Iterable<DeletedAlpha> _iterDI;
    await DBHelper.getData(DBHelper.deletedAlphaTable).then((data) {
      _deletedItems.clear();
      _iterDI = data.map((e) => DeletedAlpha.fromMap(e));
    });
    _deletedItems.addAll(_iterDI.toList());
    _deletedItems.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> insert(Alpha a) async =>
      await DBHelper.insert(DBHelper.alphaTable, a.toMap());

  Future<void> update(Alpha a) async {
    await DBHelper.getById(DBHelper.alphaTable, a.id).then(
      (items) async {
        Alpha _a = Alpha.fromMap(items.first);
        if (_a.savePrevious(a)) {
          OldAlpha old = OldAlpha.fromAlpha(_a);
          await DBHelper.insert(DBHelper.oldAlphaTable, old.toMap());
        }
      },
    );
    await DBHelper.update(DBHelper.alphaTable, a.toMap());
  }

  Future<void> delete(Alpha item) async {
    // REFRESH REPEATED STATUS
    if (item.passStatus != 'REPEATED')
      await DBHelper.delete(DBHelper.alphaTable, item.id);
    else
      await DBHelper.refreshPassRepeted(item.password);
    DeletedAlpha delete = DeletedAlpha.fromAlpha(item);
    await DBHelper.insert(DBHelper.deletedAlphaTable, delete.toMap());
    _items.removeWhere((element) => element.id == item.id);
  }

  Future<bool> verifyRepeatedPass(String s) async {
    if (s.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.alphaTable, 'password', s))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.oldAlphaTable, 'password', s))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.deletedAlphaTable, 'password', s))
        .isNotEmpty) return true;
    return false;
  }

  Future<bool> verifyRepeatedPin(String p) async {
    if (p.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.alphaTable, 'pin', p)).isNotEmpty)
      return true;
    if ((await DBHelper.getByValue(DBHelper.oldAlphaTable, 'pin', p))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.deletedAlphaTable, 'pin', p))
        .isNotEmpty) return true;
    return false;
  }

  Future<void> setPassStatus(String pass, String status) async =>
      await DBHelper.setPassStatus(DBHelper.alphaTable, pass, status);

  Future<void> setPinStatus(String pin, String status) async =>
      await DBHelper.setPinStatus(DBHelper.alphaTable, pin, status);

  // Future<void> refreshRepetedPassword(String p) async {
  //   List<Map<String, dynamic>> _list =
  //       await DBHelper.getByValue(DBHelper.alphaTable, 'password', p);
  //   if (_list.length < 2) DBHelper.refreshPassRepeted(p);
  // }

  Future<void> refreshPassRepeted(String p) async =>
      await DBHelper.refreshPassRepeted(p);

  Future<void> removeItems() async {
    _items.clear();
    _itemsWithHistory.clear();
    _itemHistory.clear();
    _deletedItems.clear();
  }

  Future<void> _checkExpirations() async {
    _items.cast<Alpha>().forEach((i) async {
      i.dateTime = DateTime.parse(i.date);
      int _diff = i.dateTime.difference(DateTime.now()).inDays.abs();
      if (_diff > 180 && i.expired != 'YES') {
        i.expired = 'YES';
        await DBHelper.update(DBHelper.alphaTable, i.toMap());
      }
      if (_diff <= 180 && i.expired == 'YES') {
        i.expired = '';
        await DBHelper.update(DBHelper.alphaTable, i.toMap());
      }
    });
  }

  Future<List<String>> getUsers() async {
    Iterable<String> _iter;
    await DBHelper.getUsernames().then((data) {
      _iter = data.map((e) => e['username']);
    });
    return _iter.toList();
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
    await _cripto.unlock('Qwe123!');
    for (int i = 0; i < _titles.length; i++) {
      DateTime _date = DateTime(
        2020,
        _ran.nextInt(11) + 1,
        _ran.nextInt(27) + 1,
      );
      insert(
        Alpha(
          title: _titles[i],
          username: _cripto.doCrypt(_users[i]),
          password: _cripto.doCrypt(_passes[i]),
          pin: '',
          ip: '',
          longText: '',
          date: _date.toIso8601String(),
          shortDate: dateFormat.format(_date),
          color: _ran.nextInt(4294967295),
          colorLetter: _ran.nextInt(4294967295),
          passStatus: _titles[i].contains('g') ? 'REPEATED' : '',
          pinStatus: '',
          passLevel: _titles[i].contains('g') ? 'WEAK' : 'STRONG',
          expired: _date.month < 7 ? 'YES' : 'NO',
          expiredLapse: '${_ran.nextInt(365).toString()} DAYS',
        ),
      );
    }
  }

  void dispose() {
    super.dispose();
  }
}
