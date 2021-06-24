import 'package:flutter/material.dart';
import 'package:keyway/models/cpe23uri.dart';
import 'package:keyway/models/cpe23uri_cve.dart';
import 'package:keyway/models/cve.dart';

import '../helpers/db_helper.dart';

import '../models/device.dart';
import '../models/item.dart';
import '../models/item_password.dart';
import '../models/password.dart';
import '../models/username.dart';
import '../models/pin.dart';
import '../models/long_text.dart';
import '../models/tag.dart';
import '../models/address.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> _itemsWithOldPasswords = [];
  List<Item> _itemAndOldPasswords = [];
  List<Item> _itemsDeleted = [];

  List<Item> _allItems = [];
  List<ItemPassword> _itemsPasswords = [];
  List<Password> _passwords = [];
  List<Username> _usernames = [];
  List<Pin> _pins = [];
  List<LongText> _notes = [];
  List<Address> _addresses = [];
  List<Device> _devices = [];
  List<Cpe23uri> _cpe23uris = [];
  List<Cpe23uriCve> _cpe23uriCves = [];
  List<Cve> _cves = [];

  List<Item> get items => [..._items];
  List<Item> get itemsWithOldPasswords => [..._itemsWithOldPasswords];
  List<Item> get itemAndOldPasswords => [..._itemAndOldPasswords];
  List<Item> get itemsDeleted => [..._itemsDeleted];

  List<Item> get allItems => [..._allItems];
  List<ItemPassword> get itemPasswords => [..._itemsPasswords];
  List<Password> get passwords => [..._passwords];
  List<Username> get usernames => [..._usernames];
  List<Pin> get pins => [..._pins];
  List<LongText> get notes => [..._notes];
  List<Address> get addresses => [..._addresses];
  List<Device> get devices => [..._devices];
  List<Cpe23uri> get cpe23uris => [..._cpe23uris];
  List<Cpe23uriCve> get cpe23uriCves => [..._cpe23uriCves];
  List<Cve> get cves => [..._cves];

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

  Future<void> fetchAllItems(String title) async {
    Iterable<Item> _iter;
    _allItems.clear();
    if (title.isEmpty) {
      await DBHelper.getData(DBHelper.itemTable).then((data) {
        _iter = data.map((i) => Item.fromMap(i));
      });
    } else {
      await DBHelper.getData(DBHelper.itemTable)
          .then((data) => _iter = data.map((i) => Item.fromMap(i)));
    }
    _allItems.addAll(_iter.toList());
    await _buildAllItems();
  }

  Future<void> fetchItemPasswords() async {
    Iterable<ItemPassword> _iter;
    _itemsPasswords.clear();
    await DBHelper.getData(DBHelper.itemPasswordTable).then((data) {
      _iter = data.map((i) => ItemPassword.fromMap(i));
    });
    _itemsPasswords.addAll(_iter.toList());
  }

  Future<void> fetchPasswords() async {
    Iterable<Password> _iter;
    _passwords.clear();
    await DBHelper.getData(DBHelper.passwordTable).then((data) {
      _iter = data.map((i) => Password.fromMap(i));
    });
    _passwords.addAll(_iter.toList());
  }

  Future<void> fetchUsernames() async {
    Iterable<Username> _iter;
    _usernames.clear();
    await DBHelper.getData(DBHelper.usernameTable).then((data) {
      _iter = data.map((i) => Username.fromMap(i));
    });
    _usernames.addAll(_iter.toList());
  }

  Future<void> fetchPins() async {
    Iterable<Pin> _iter;
    _pins.clear();
    await DBHelper.getData(DBHelper.pinTable).then((data) {
      _iter = data.map((i) => Pin.fromMap(i));
    });
    _pins.addAll(_iter.toList());
  }

  Future<void> fetchNotes() async {
    Iterable<LongText> _iter;
    _notes.clear();
    await DBHelper.getData(DBHelper.longTextTable).then((data) {
      _iter = data.map((i) => LongText.fromMap(i));
    });
    _notes.addAll(_iter.toList());
  }

  Future<void> fetchAddresses() async {
    Iterable<Address> _iter;
    _addresses.clear();
    await DBHelper.getData(DBHelper.addressTable).then((data) {
      _iter = data.map((i) => Address.fromMap(i));
    });
    _addresses.addAll(_iter.toList());
  }

  Future<void> fetchDevices() async {
    Iterable<Device> _iter;
    _devices.clear();
    await DBHelper.getData(DBHelper.deviceTable).then((data) {
      _iter = data.map((i) => Device.fromMap(i));
    });
    _devices.addAll(_iter.toList());
  }

  Future<void> fetchCpe23uris() async {
    Iterable<Cpe23uri> _iter;
    _cpe23uris.clear();
    await DBHelper.getData(DBHelper.cpe23uriTable).then((data) {
      _iter = data.map((i) => Cpe23uri.fromMap(i));
    });
    _cpe23uris.addAll(_iter.toList());
  }

  Future<void> fetchCpe23uriCves() async {
    Iterable<Cpe23uriCve> _iter;
    _cpe23uriCves.clear();
    await DBHelper.getData(DBHelper.cpe23uriCveTable).then((data) {
      _iter = data.map((i) => Cpe23uriCve.fromMap(i));
    });
    _cpe23uriCves.addAll(_iter.toList());
  }

  Future<void> fetchCves() async {
    Iterable<Cve> _iter;
    _cves.clear();
    await DBHelper.getData(DBHelper.cveTable).then((data) {
      _iter = data.map((i) => Cve.fromMap(i));
    });
    _cves.addAll(_iter.toList());
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
      if (i.fkAddressId != null) {
        i.address = await getAdress(i.fkAddressId);
      }
    });
  }

  Future<void> _buildAllItems() async {
    _allItems.forEach((i) async {
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
      if (i.fkAddressId != null) {
        i.address = await getAdress(i.fkAddressId);
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
      if (i.fkAddressId != null) {
        i.address = await getAdress(i.fkAddressId);
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

  Future<int> insertAddress(Address a) async =>
      await DBHelper.insert(DBHelper.addressTable, a.toMap());

  Future<int> updateAddress(Address a) async =>
      await DBHelper.update(DBHelper.addressTable, a.toMap(), 'address_id');

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

  Future<Address> getAdress(int id) async {
    List<Map<String, dynamic>> _a = await DBHelper.getAdressById(id);
    return Address.fromMap(_a.first);
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
    await DBHelper.getData(DBHelper.tagTable).then((data) {
      _iter = data.map((e) => Tag.fromMap(e));
    });
    return _iter.toList();
  }

  void dispose() {
    super.dispose();
  }
}
