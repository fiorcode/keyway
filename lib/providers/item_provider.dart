import 'package:flutter/material.dart';
import 'package:keyway/models/item_password.dart';

// import 'dart:math';
// import 'package:encrypt/encrypt.dart' as e;
// import 'package:keyway/providers/cripto_provider.dart';

import '../helpers/db_helper.dart';

import '../models/device.dart';
import '../models/item.dart';
import '../models/long_text.dart';
import '../models/password.dart';
import '../models/pin.dart';
import '../models/username.dart';
import '../models/tag.dart';
import '../models/adress.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _itemsWithOldPasswords = [];
  List<Item> _itemAndOldPasswords = [];
  List<Item> _itemsDeleted = [];

  List<Item> get items => [..._items];
  List<Item> get itemsWithOldPasswords => [..._itemsWithOldPasswords];
  List<Item> get itemAndOldPasswords => [..._itemAndOldPasswords];
  List<Item> get itemsDeleted => [..._itemsDeleted];

  Future<void> fetchItems(String title) async {
    Iterable<Item> _iter;
    _items.clear();
    if (title.isEmpty) {
      await DBHelper.getActiveItems().then((data) {
        _iter = data.map((i) => Item.fromMap(i));
      });
    } else {
      await DBHelper.getActiveItemsByTitle(title)
          .then((data) => _iter = data.map((i) => Item.fromMap(i)));
    }
    _items.addAll(_iter.toList());
    await _buildItems();
  }

  Future<void> _buildItems() async {
    _items.forEach((i) async {
      if (i.fkUsernameId != null) {
        i.username = await getUsername(i.fkUsernameId);
      }
      await getLastItemPassword(i.itemId).then((_ips) async {
        if (_ips.isNotEmpty) {
          i.itemPassword = _ips.first;
          i.password = await getPassword(_ips.first.fkPasswordId);
        }
      });
      if (i.fkPinId != null) {
        i.pin = await getPin(i.fkPinId);
      }
      if (i.fkLongTextId != null) {
        i.longText = await getLongText(i.fkLongTextId);
      }
      if (i.fkAdressId != null) {
        i.adress = await getAdress(i.fkAdressId);
      }
    });
  }

  Future<void> fetchItemsWithOldPasswords() async {
    Iterable<Item> _iter;
    _itemsWithOldPasswords.clear();
    await DBHelper.getItemsWithOldPasswords().then((data) {
      _iter = data.map((e) => Item.fromMap(e));
    });
    _itemsWithOldPasswords.addAll(_iter.toList());
    _itemsWithOldPasswords.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> fetchItemAndOldPasswords(int itemId) async {
    Iterable<Item> _iter;
    _itemAndOldPasswords.clear();
    await DBHelper.getItemAndOldPasswords(itemId).then((data) {
      _iter = data.map((e) {
        Item _i = Item.fromMap(e);
        _i.itemPassword = ItemPassword.fromMap(e);
        _i.password = Password.fromMap(e);
        return _i;
      });
      _itemAndOldPasswords.addAll(_iter.toList());
    });
  }

  Future<void> fetchItemsDeleted() async {
    Iterable<Item> _iter;
    _itemsDeleted.clear();
    await DBHelper.getDeletedItems().then((data) {
      _iter = data.map((e) => Item.fromMap(e));
    });
    _itemsDeleted.addAll(_iter.toList());
    _itemsDeleted.sort((a, b) => b.date.compareTo(a.date));
    _buildItemsDeleted();
  }

  Future<void> _buildItemsDeleted() async {
    _itemsDeleted.forEach((i) async {
      if (i.fkUsernameId != null) {
        i.username = await getUsername(i.fkUsernameId);
      }
      await getLastItemPassword(i.itemId).then((_ips) async {
        if (_ips.isNotEmpty) {
          i.itemPassword = _ips.first;
          i.password = await getPassword(_ips.first.fkPasswordId);
        }
      });
      if (i.fkPinId != null) {
        i.pin = await getPin(i.fkPinId);
      }
      if (i.fkLongTextId != null) {
        i.longText = await getLongText(i.fkLongTextId);
      }
      if (i.fkAdressId != null) {
        i.adress = await getAdress(i.fkAdressId);
      }
    });
  }

  Future<int> insertItem(Item i) async =>
      await DBHelper.insert(DBHelper.itemTable, i.toMap());

  Future<int> updateItem(Item i) async => await DBHelper.updateItem(i.toMap());

  Future<int> insertUsername(Username u) async =>
      await DBHelper.insert(DBHelper.usernameTable, u.toMap());

  Future<int> updateUsername(Username u) async =>
      await DBHelper.update(DBHelper.usernameTable, u.toMap(), 'username_id');

  Future<int> insertPassword(Password p) async =>
      await DBHelper.insert(DBHelper.passwordTable, p.toMap());

  Future<int> updatePassword(Password p) async =>
      await DBHelper.update(DBHelper.passwordTable, p.toMap(), 'password_id');

  Future<void> insertItemPassword(ItemPassword ip) async =>
      await DBHelper.insert(DBHelper.itemPasswordTable, ip.toMap());

  Future<void> updateItemPassword(ItemPassword ip) async =>
      await DBHelper.updateItemPassword(ip.toMap());

  Future<int> insertPin(Pin p) async =>
      await DBHelper.insert(DBHelper.pinTable, p.toMap());

  Future<int> updatePin(Pin p) async =>
      await DBHelper.update(DBHelper.pinTable, p.toMap(), 'pin_id');

  Future<int> insertLongText(LongText l) async =>
      await DBHelper.insert(DBHelper.longTextTable, l.toMap());

  Future<int> updateLongText(LongText l) async =>
      await DBHelper.update(DBHelper.longTextTable, l.toMap(), 'long_text_id');

  Future<bool> passUsed(Password p) async {
    if (p.hash.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.passwordTable, 'hash', p.hash))
        .isNotEmpty) return true;
    return false;
  }

  Future<void> refreshItemPasswordStatus(int passwordId) async =>
      await DBHelper.refreshItemPasswordStatus(passwordId);

  Future<void> removeItems() async {
    _items.clear();
    _itemsWithOldPasswords.clear();
    _itemAndOldPasswords.clear();
    _itemsDeleted.clear();
  }

  Future<Username> getUsername(int id) async {
    List<Map<String, dynamic>> _u = await DBHelper.getUsernameById(id);
    return Username.fromMap(_u.first);
  }

  Future<Password> getPassword(int id) async {
    List<Map<String, dynamic>> _p = await DBHelper.getPasswordById(id);
    return Password.fromMap(_p.first);
  }

  Future<Password> getPasswordByHash(String hash) async => Password.fromMap(
      (await DBHelper.getByValue(DBHelper.passwordTable, 'hash', hash)).first);

  Future<List<ItemPassword>> getLastItemPassword(int itemId) async {
    Iterable<ItemPassword> _iter;
    await DBHelper.getItemPass(itemId).then((data) {
      _iter = data.map((e) => ItemPassword.fromMap(e));
    });
    List<ItemPassword> _ips = _iter.toList();
    _ips.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return _ips;
  }

  Future<Pin> getPin(int id) async {
    List<Map<String, dynamic>> _p = await DBHelper.getPinById(id);
    return Pin.fromMap(_p.first);
  }

  Future<LongText> getLongText(int id) async {
    List<Map<String, dynamic>> _lt = await DBHelper.getLongTextById(id);
    return LongText.fromMap(_lt.first);
  }

  Future<Adress> getAdress(int id) async {
    List<Map<String, dynamic>> _a = await DBHelper.getAdressById(id);
    return Adress.fromMap(_a.first);
  }

  Future<Device> getDevice(int id) async {
    List<Map<String, dynamic>> _d = await DBHelper.getDeviceById(id);
    return Device.fromMap(_d.first);
  }

  Future<List<Username>> getUsers() async {
    Iterable<Username> _iter;
    await DBHelper.getData(DBHelper.usernameTable).then((data) {
      _iter = data.map((e) => Username.fromMap(e));
    });
    return _iter.toList();
  }

  Future<void> insertTag(Tag a) async =>
      await DBHelper.insert(DBHelper.tagTable, a.toMap());

  Future<void> deleteTag(Tag t) async {
    await DBHelper.removeTag(t.tagName);
    await DBHelper.deleteTag(t.toMap());
  }

  Future<List<Tag>> getTags() async {
    Iterable<Tag> _iter;
    await DBHelper.getTags().then((data) {
      _iter = data.map((e) => Tag.fromMap(e));
    });
    return _iter.toList();
  }

  // Future<void> mockData(CriptoProvider _cripto) async {
  //   List<String> _titles = [
  //     'Facebook',
  //     'Instagram',
  //     'Spotify',
  //     'Github',
  //     'Discord',
  //     'Google',
  //     'Steam',
  //     'Hotmail',
  //     'Siglo21',
  //   ];
  //   List<String> _users = [
  //     'FacebookUser',
  //     'InstagramUser',
  //     'SpotifyUser',
  //     'GithubUser',
  //     'DiscordUser',
  //     'GoogleUser',
  //     'SteamUser',
  //     'HotmailUser',
  //     'Siglo21User',
  //   ];
  //   List<String> _passes = [
  //     'FacebookPass',
  //     'InstagramPass',
  //     'SpotifyPass',
  //     'GithubPass',
  //     'DiscordPass',
  //     'GooglePass',
  //     'SteamPass',
  //     'HotmailPass',
  //     'Siglo21Pass',
  //   ];
  //   List<int> _colors = [
  //     Colors.lightBlue.value,
  //     Colors.pink.value,
  //     Colors.green.value,
  //     Colors.deepPurple.value,
  //     Colors.purple.value,
  //     Colors.deepOrange.value,
  //     Colors.blue.value,
  //     Colors.teal.value,
  //     Colors.lightGreen.value,
  //   ];
  //   List<String> _pins = [
  //     '',
  //     '',
  //     '3358',
  //     '',
  //     '9967',
  //     '2518',
  //     '',
  //     '',
  //     '',
  //   ];
  //   List<Tag> _tags = [
  //     Tag('personal'),
  //     Tag('shared'),
  //     Tag('work'),
  //     Tag('family'),
  //     Tag('social'),
  //     Tag('gaming'),
  //   ];
  //   _tags.forEach(
  //       (_tag) async => await DBHelper.insert(DBHelper.tagTable, _tag.toMap()));
  //   Random _ran = Random(59986674);
  //   await _cripto.unlock('Qwe123!');
  //   for (int i = 0; i < _titles.length; i++) {
  //     String _tagsList = '';
  //     _tagsList += '<${_tags[_ran.nextInt(5)].tagName}>';
  //     String _secTag = '<${_tags[_ran.nextInt(5)].tagName}>';
  //     if (!_tagsList.contains(_secTag)) _tagsList += _secTag;
  //     DateTime _d = DateTime(2020, _ran.nextInt(11) + 1, _ran.nextInt(27) + 1);
  //     String _ivUser = e.IV.fromSecureRandom(16).base16;
  //     String _ivPass = e.IV.fromSecureRandom(16).base16;
  //     String _ivPin = e.IV.fromSecureRandom(16).base16;
  //     insertAlpha(
  //       Alpha(
  //         title: _titles[i],
  //         username: _cripto.doCrypt(_users[i], _ivUser),
  //         usernameIV: _users[i].isEmpty ? '' : _ivUser,
  //         password: _cripto.doCrypt(_passes[i], _ivPass),
  //         passwordIV: _passes[i].isEmpty ? '' : _ivPass,
  //         passwordHash: _passes[i].isEmpty ? '' : _cripto.doHash(_passes[i]),
  //         passwordStatus: _passes[i].isEmpty ? '' : '',
  //         passwordDate: _passes[i].isEmpty ? '' : _d.toIso8601String(),
  //         passwordLevel: _passes[i].isEmpty ? '' : 'WEAK',
  //         pin: _cripto.doCrypt(_pins[i], _ivPin),
  //         pinIV: _pins[i].isEmpty ? '' : _ivPin,
  //         pinHash: _pins[i].isEmpty ? '' : _cripto.doHash(_pins[i]),
  //         pinDate: _pins[i].isEmpty ? '' : _d.toIso8601String(),
  //         pinStatus: _pins[i].isEmpty ? '' : '',
  //         ip: '',
  //         ipIV: '',
  //         longText: '',
  //         longTextIV: '',
  //         date: _d.toIso8601String(),
  //         avatarColor: _colors[i],
  //         avatarColorLetter: -1,
  //         tags: _tagsList,
  //       ),
  //     );
  //   }
  // }

  void dispose() {
    super.dispose();
  }
}
