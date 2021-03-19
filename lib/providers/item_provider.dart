import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/alpha.dart';
import '../models/deleted_alpha.dart';
import '../models/old_alpha.dart';
import '../models/username.dart';
import '../models/tag.dart';

class ItemProvider with ChangeNotifier {
  List<dynamic> _items = [];
  List<dynamic> _itemsWithOlds = [];
  List<OldAlpha> _itemOlds = [];
  List<DeletedAlpha> _deletedItems = [];

  List<dynamic> get items => [..._items];
  List<dynamic> get itemsWithOlds => [..._itemsWithOlds];
  List<OldAlpha> get itemOlds => [..._itemOlds];
  List<DeletedAlpha> get deletedItems => [..._deletedItems];

  Future<void> fetchItems(String title) async {
    Iterable<Alpha> _iter;
    _items.clear();
    if (title.isEmpty) {
      await DBHelper.getData(DBHelper.alphaTable)
          .then((data) => _iter = data.map((e) => Alpha.fromMap(e)));
    } else {
      await DBHelper.getItemsByTitle(title)
          .then((data) => _iter = data.map((e) => Alpha.fromMap(e)));
    }
    _items.addAll(_iter.toList());
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

  Future<void> insertAlpha(Alpha a) async {
    await DBHelper.insert(DBHelper.alphaTable, a.toMap());
    if (a.passwordStatus == 'REPEATED')
      await DBHelper.setPassRepeted(DBHelper.alphaTable, a.passwordHash);

    if (a.pinStatus == 'REPEATED')
      await DBHelper.setPinRepeted(DBHelper.alphaTable, a.pinHash);
  }

  Future<void> updateAlpha(Alpha a) async {
    Alpha _prev;
    await DBHelper.getById(DBHelper.alphaTable, a.id).then(
      (_list) async {
        _prev = Alpha.fromMap(_list.first);
        if (_prev.passwordHash != a.passwordHash) {
          // HERE
        }
        OldAlpha _oldAlpha = _prev.saveOld(a);
        if (_oldAlpha != null) {
          await DBHelper.insert(DBHelper.oldAlphaTable, _oldAlpha.toMap());
        }
      },
    ).then((_) async {
      await DBHelper.update(DBHelper.alphaTable, a.toMap()).then((_) async {
        if (a.passwordStatus == 'REPEATED') {
          await DBHelper.setPassRepeted(DBHelper.alphaTable, a.passwordHash);
        }
        if (a.pinStatus == 'REPEATED') {
          await DBHelper.setPinRepeted(DBHelper.alphaTable, a.pinHash);
        }
        if (_prev.passwordHash != a.passwordHash) {
          await DBHelper.unsetPassRepeted(
              DBHelper.alphaTable, _prev.passwordHash);
        }
        if (_prev.pinHash != a.pinHash) {
          await DBHelper.unsetPinRepeted(DBHelper.alphaTable, _prev.pinHash);
        }
      });
    });
  }

  Future<void> deleteAlpha(Alpha a) async {
    await DBHelper.insert(
      DBHelper.deletedAlphaTable,
      DeletedAlpha.fromAlpha(a).toMap(),
    ).then(
      (_) async => await DBHelper.delete(DBHelper.alphaTable, a.id).then(
        (_) => _items.removeWhere((e) => e.id == a.id),
      ),
    );
  }

  Future<void> deleteOldAlpha(OldAlpha old) async {
    await DBHelper.delete(DBHelper.oldAlphaTable, old.id).then(
      (_) => _itemOlds.removeWhere((e) => e.id == old.id),
    );
  }

  Future<bool> isPasswordInDB(String hash) async {
    if (hash.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.alphaTable, 'password_hash', hash))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(
            DBHelper.oldAlphaTable, 'password_hash', hash))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(
            DBHelper.deletedAlphaTable, 'password_hash', hash))
        .isNotEmpty) return true;
    return false;
  }

  Future<bool> isPinInDB(String hash) async {
    if (hash.isEmpty) return false;
    if ((await DBHelper.getByValue(DBHelper.alphaTable, 'pin_hash', hash))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(DBHelper.oldAlphaTable, 'pin_hash', hash))
        .isNotEmpty) return true;
    if ((await DBHelper.getByValue(
            DBHelper.deletedAlphaTable, 'pin_hash', hash))
        .isNotEmpty) return true;
    return false;
  }

  Future<bool> isPasswordRepeated(String hash) async {
    if (hash.isEmpty) return false;
    List<Map<String, dynamic>> _listAllTables = <Map<String, dynamic>>[];
    await DBHelper.getByValue(DBHelper.alphaTable, 'password_hash', hash)
        .then((_list) {
      _listAllTables.addAll(_list);
      DBHelper.getByValue(DBHelper.oldAlphaTable, 'password_hash', hash)
          .then((_list) {
        _listAllTables.addAll(_list);
        DBHelper.getByValue(DBHelper.deletedAlphaTable, 'password_hash', hash)
            .then((_list) => _listAllTables.addAll(_list));
      });
    });
    return _listAllTables.length >= 2;
  }

  Future<bool> isPinRepeated(String hash) async {
    if (hash.isEmpty) return false;
    List<Map<String, dynamic>> _listAllTables = <Map<String, dynamic>>[];
    await DBHelper.getByValue(DBHelper.alphaTable, 'pin_hash', hash)
        .then((_list) {
      _listAllTables.addAll(_list);
      DBHelper.getByValue(DBHelper.oldAlphaTable, 'pin_hash', hash)
          .then((_list) {
        _listAllTables.addAll(_list);
        DBHelper.getByValue(DBHelper.deletedAlphaTable, 'pin_hash', hash)
            .then((_list) => _listAllTables.addAll(_list));
      });
    });
    return _listAllTables.length >= 2;
  }

  Future<int> setPassStatus(String table, String pass, String status) async =>
      await DBHelper.setPassStatus(table, pass, status);

  Future<int> setPinStatus(String table, String pin, String status) async =>
      await DBHelper.setPinStatus(table, pin, status);

  Future<void> removeItems() async {
    _items.clear();
    _itemsWithOlds.clear();
    _itemOlds.clear();
    _deletedItems.clear();
  }

  Future<List<Username>> getUsers() async {
    Iterable<Username> _iter;
    await DBHelper.getUsernames().then((data) {
      _iter = data.map((e) => Username.fromMap(e));
    });
    return _iter.toList();
  }

  Future<void> insertTag(Tag a) async =>
      await DBHelper.insert(DBHelper.tagTable, a.toMap());

  Future<void> deleteTag(Tag t) async {
    await DBHelper.removeTag(t.tagName);
    await DBHelper.delete(DBHelper.tagTable, t.id);
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
  //     'BNA Pin',
  //     'BBVA Pin',
  //     'SantaCruz Pin',
  //     'Windows Pin',
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
  //     'BNA User HB',
  //     'BBVA User HB',
  //     'SantaCruz User HB',
  //     '',
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
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //   ];
  //   List<String> _pins = [
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //     '',
  //     '2518',
  //     '4592',
  //     '6275',
  //     '3358',
  //     '9967',
  //     '1558',
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
  //   DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
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
  //         passwordLapse: _passes[i].isEmpty ? '' : '',
  //         passwordLevel: _passes[i].isEmpty ? '' : 'WEAK',
  //         pin: _cripto.doCrypt(_pins[i], _ivPin),
  //         pinIV: _pins[i].isEmpty ? '' : _ivPin,
  //         pinHash: _pins[i].isEmpty ? '' : _cripto.doHash(_pins[i]),
  //         pinDate: _pins[i].isEmpty ? '' : _d.toIso8601String(),
  //         pinLapse: _pins[i].isEmpty ? '' : '',
  //         pinStatus: _pins[i].isEmpty ? '' : '',
  //         ip: '',
  //         ipIV: '',
  //         longText: '',
  //         longTextIV: '',
  //         date: _d.toIso8601String(),
  //         shortDate: dateFormat.format(_d),
  //         color: _ran.nextInt(4294967290),
  //         colorLetter: _ran.nextInt(4294967290),
  //         tags: _tagsList,
  //       ),
  //     );
  //   }
  // }

  void dispose() {
    super.dispose();
  }
}
