import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../providers/cripto_provider.dart';
import '../helpers/db_helper.dart';
import '../models/item.dart';

class ItemProvider with ChangeNotifier {
  List<dynamic> _items = [];
  List<dynamic> _itemsWithOlds = [];
  List<OldAlpha> _itemOlds = [];
  List<DeletedAlpha> _deletedItems = [];

  List<dynamic> get items => [..._items];
  List<dynamic> get itemsWithOlds => [..._itemsWithOlds];
  List<OldAlpha> get itemOlds => [..._itemOlds];
  List<DeletedAlpha> get deletedItems => [..._deletedItems];

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

  Future<void> fetchItemsWithOlds() async {
    Iterable<OldAlpha> _iterIWH;
    Iterable<DeletedAlpha> _iterDIWH;
    _itemsWithOlds.clear();
    await DBHelper.getAlphaWithOlds().then((data) {
      _iterIWH = data.map((e) => OldAlpha.fromMap(e));
    });
    _itemsWithOlds.addAll(_iterIWH.toList());
    await DBHelper.getDeletedAlphaWithOlds().then((data) {
      _iterDIWH = data.map((e) => DeletedAlpha.fromMap(e));
    });
    _itemsWithOlds.addAll(_iterDIWH.toList());
    _itemsWithOlds.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchItemOlds(int itemId) async {
    Iterable<OldAlpha> _iterIH;
    await DBHelper.getByValue(DBHelper.oldAlphaTable, 'item_id', itemId)
        .then((data) {
      _itemOlds.clear();
      _iterIH = data.map((e) => OldAlpha.fromMap(e));
      _itemOlds.addAll(_iterIH.toList());
      _itemOlds.sort((a, b) => b.date.compareTo(a.date));
    });
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

  Future<void> updateAlpha(Alpha a) async {
    Alpha _prev;
    await DBHelper.getById(DBHelper.alphaTable, a.id).then(
      (_list) async {
        _prev = Alpha.fromMap(_list.first);
        OldAlpha _old = _prev.saveOld(a);
        if (_old != null) {
          await DBHelper.insert(DBHelper.oldAlphaTable, _old.toMap());
        }
      },
    ).then(
      (_) async => await DBHelper.update(DBHelper.alphaTable, a.toMap()).then(
        (_) async {
          await DBHelper.repeatedAlpha(_prev.password).then(
            (_list2) async {
              if (_list2.length == 1) {
                Alpha _a = Alpha.fromMap(_list2.first);
                _a.passStatus = '';
                await DBHelper.update(DBHelper.alphaTable, _a.toMap());
              }
            },
          );
        },
      ),
    );
  }

  Future<void> deleteAlpha(Alpha a) async {
    DeletedAlpha _deleted = DeletedAlpha.fromAlpha(a);
    await DBHelper.insert(DBHelper.deletedAlphaTable, _deleted.toMap()).then(
      (_) async => await DBHelper.delete(DBHelper.alphaTable, a.id).then(
        (_) {
          _items.removeWhere((e) => e.id == a.id);
          notifyListeners();
        },
      ),
    );
  }

  Future<bool> isPasswordRepeated(String pass) async {
    if (pass.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.alphaTable, 'password', pass))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.oldAlphaTable, 'password', pass))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(
            DBHelper.deletedAlphaTable, 'password', pass))
        .isNotEmpty) return true;
    return false;
  }

  Future<bool> isPinRepeated(String pin) async {
    if (pin.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.alphaTable, 'pin', pin)).isNotEmpty)
      return true;
    if ((await DBHelper.getByValue(DBHelper.oldAlphaTable, 'pin', pin))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.deletedAlphaTable, 'pin', pin))
        .isNotEmpty) return true;
    return false;
  }

  Future<int> setPassStatus(String table, String pass, String status) async =>
      await DBHelper.setPassStatus(table, pass, status);

  Future<int> setPinStatus(String table, String pin, String status) async =>
      await DBHelper.setPinStatus(table, pin, status);

  Future<void> setAlphaPassRepeted(String pass) async =>
      await DBHelper.setPassRepeted(DBHelper.alphaTable, pass);

  Future<void> setOldAlphaPassRepeted(String pass) async =>
      await DBHelper.setPassRepeted(DBHelper.oldAlphaTable, pass);

  Future<void> setDeletedAlphaPassRepeted(String pass) async =>
      await DBHelper.setPassRepeted(DBHelper.deletedAlphaTable, pass);

  Future<void> setAlphaPinRepeted(String pin) async =>
      await DBHelper.setPinRepeted(DBHelper.alphaTable, pin);

  Future<void> setOldAlphaPinRepeted(String pin) async =>
      await DBHelper.setPinRepeted(DBHelper.oldAlphaTable, pin);

  Future<void> setDeletedAlphaPinRepeted(String pin) async =>
      await DBHelper.setPinRepeted(DBHelper.deletedAlphaTable, pin);

  Future<void> removeItems() async {
    _items.clear();
    _itemsWithOlds.clear();
    _itemOlds.clear();
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
      'Siglo21',
      'BNA Pin',
      'BBVA Pin',
      'SantaCruz Pin',
      'Windows Pin',
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
      'Siglo21User',
      'BNA User HB',
      'BBVA User HB',
      'SantaCruz User HB',
      '',
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
      'Siglo21Pass',
      '',
      '',
      '',
      '',
      '',
      '',
    ];
    List<String> _pins = [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '2518',
      '4592',
      '6275',
      '3358',
      '9967',
      '1558',
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
          pin: _cripto.doCrypt(_pins[i]),
          ip: '',
          longText: '',
          date: _date.toIso8601String(),
          shortDate: dateFormat.format(_date),
          color: _ran.nextInt(4294967295),
          colorLetter: _ran.nextInt(4294967295),
          passStatus: '',
          pinStatus: '',
          passLevel: 'WEAK',
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
