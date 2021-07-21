import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';
import '../models/item.dart';
import '../models/item_password.dart';
import '../models/password.dart';
import '../models/username.dart';
import '../models/pin.dart';
import '../models/note.dart';
import '../models/address.dart';
import '../models/product.dart';
import '../models/cpe23uri.dart';
import '../models/cpe23uri_cve.dart';
import '../models/cve.dart';
import '../models/tag.dart';

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
  List<Note> _notes = [];
  List<Address> _addresses = [];
  List<Product> _products = [];
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
  List<Note> get notes => [..._notes];
  List<Address> get addresses => [..._addresses];
  List<Product> get products => [..._products];
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
      await DBHelper.read(DBHelper.itemTable).then((data) {
        _iter = data.map((i) => Item.fromMap(i));
      });
    } else {
      await DBHelper.read(DBHelper.itemTable)
          .then((data) => _iter = data.map((i) => Item.fromMap(i)));
    }
    _allItems.addAll(_iter.toList());
    await _buildAllItems();
  }

  Future<void> fetchItemPasswords() async {
    Iterable<ItemPassword> _iter;
    _itemsPasswords.clear();
    await DBHelper.read(DBHelper.itemPasswordTable).then((data) {
      _iter = data.map((i) => ItemPassword.fromMap(i));
    });
    _itemsPasswords.addAll(_iter.toList());
  }

  Future<void> fetchPasswords() async {
    Iterable<Password> _iter;
    _passwords.clear();
    await DBHelper.read(DBHelper.passwordTable).then((data) {
      _iter = data.map((i) => Password.fromMap(i));
    });
    _passwords.addAll(_iter.toList());
  }

  Future<void> fetchUsernames() async {
    Iterable<Username> _iter;
    _usernames.clear();
    await DBHelper.read(DBHelper.usernameTable).then((data) {
      _iter = data.map((i) => Username.fromMap(i));
    });
    _usernames.addAll(_iter.toList());
  }

  Future<void> fetchPins() async {
    Iterable<Pin> _iter;
    _pins.clear();
    await DBHelper.read(DBHelper.pinTable).then((data) {
      _iter = data.map((i) => Pin.fromMap(i));
    });
    _pins.addAll(_iter.toList());
  }

  Future<void> fetchNotes() async {
    Iterable<Note> _iter;
    _notes.clear();
    await DBHelper.read(DBHelper.noteTable).then((data) {
      _iter = data.map((i) => Note.fromMap(i));
    });
    _notes.addAll(_iter.toList());
  }

  Future<void> fetchAddresses() async {
    Iterable<Address> _iter;
    _addresses.clear();
    await DBHelper.read(DBHelper.addressTable).then((data) {
      _iter = data.map((i) => Address.fromMap(i));
    });
    _addresses.addAll(_iter.toList());
  }

  Future<void> fetchProducts() async {
    Iterable<Product> _iter;
    _products.clear();
    await DBHelper.read(DBHelper.productTable).then((data) {
      _iter = data.map((i) => Product.fromMap(i));
    });
    _products.addAll(_iter.toList());
  }

  Future<void> fetchCpe23uris() async {
    Iterable<Cpe23uri> _iter;
    _cpe23uris.clear();
    await DBHelper.read(DBHelper.cpe23uriTable).then((data) {
      _iter = data.map((i) => Cpe23uri.fromMap(i));
    });
    _cpe23uris.addAll(_iter.toList());
  }

  Future<void> fetchCpe23uriCves() async {
    Iterable<Cpe23uriCve> _iter;
    _cpe23uriCves.clear();
    await DBHelper.read(DBHelper.cpe23uriCveTable).then((data) {
      _iter = data.map((i) => Cpe23uriCve.fromMap(i));
    });
    _cpe23uriCves.addAll(_iter.toList());
  }

  Future<void> fetchCves() async {
    Iterable<Cve> _iter;
    _cves.clear();
    await DBHelper.read(DBHelper.cveTable).then((data) {
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
      if (i.fkNoteId != null) {
        i.note = await getNote(i.fkNoteId);
      }
      if (i.fkAddressId != null) {
        i.address = await getAdress(i.fkAddressId);
      }
      if (i.fkProductId != null) {
        i.product = await getProduct(i.fkProductId);
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
      if (i.fkNoteId != null) {
        i.note = await getNote(i.fkNoteId);
      }
      if (i.fkAddressId != null) {
        i.address = await getAdress(i.fkAddressId);
      }
      if (i.fkProductId != null) {
        i.product = await getProduct(i.fkProductId);
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
      if (i.fkNoteId != null) {
        i.note = await getNote(i.fkNoteId);
      }
      if (i.fkAddressId != null) {
        i.address = await getAdress(i.fkAddressId);
      }
    });
  }

  Future<void> insertItem(Item i) async {
    i.date = DateTime.now().toIso8601String();
    if (i.password != null) {
      i.itemPassword.passwordDate = i.date;
      if (i.password.passwordId == null) {
        i.itemPassword.fkPasswordId = await insertPassword(i.password);
      } else {
        i.itemPassword.fkPasswordId = i.password.passwordId;
        i.itemPassword.setRepeated();
      }
    }
    if (i.username != null) {
      if (i.username.usernameId == null) {
        i.fkUsernameId = await insertUsername(i.username);
      } else {
        i.fkUsernameId = i.username.usernameId;
      }
    }
    if (i.pin != null) {
      i.pin.pinDate = i.date;
      i.fkPinId = await insertPin(i.pin);
    }
    if (i.note != null) {
      i.fkNoteId = await insertNote(i.note);
    }
    if (i.address != null) {
      i.fkAddressId = await insertAddress(i.address);
    }
    if (i.product != null) {
      if (i.product.cpe23uri != null) {
        await insertCpe23uri(i.product.cpe23uri).then((cpe23uriId) async {
          i.product.fkCpe23uriId = cpe23uriId;
          i.fkProductId = await insertProduct(i.product);
        });
      } else {
        i.fkProductId = await insertProduct(i.product);
      }
    }
    DBHelper.insert(DBHelper.itemTable, i.toMap()).then((itemId) async {
      if (i.password != null) {
        i.itemPassword.fkItemId = itemId;
        await insertItemPassword(i.itemPassword);
      }
    });
  }

  Future<void> updateItem(Item oldItem, Item i) async {
    if (oldItem.password != null) {
      if (i.password != null) {
        if (i.password.passwordId == null) {
          i.itemPassword.passwordDate = DateTime.now().toIso8601String();
          i.itemPassword.fkPasswordId = await insertPassword(i.password);
          oldItem.itemPassword.setOld();
          await updateItemPassword(oldItem.itemPassword);
        } else {
          if (oldItem.password.passwordId != i.password.passwordId) {
            i.itemPassword.passwordDate = DateTime.now().toIso8601String();
            i.itemPassword.fkPasswordId = i.password.passwordId;
            i.itemPassword.setRepeated();
            oldItem.itemPassword.setOld();
            await updateItemPassword(oldItem.itemPassword);
          }
        }
      } else {
        oldItem.itemPassword.setDeleted();
        await updateItemPassword(oldItem.itemPassword);
      }
    } else {
      if (i.password != null) {
        i.itemPassword.passwordDate = DateTime.now().toIso8601String();
        if (i.password.passwordId == null) {
          i.itemPassword.fkPasswordId = await insertPassword(i.password);
        } else {
          i.itemPassword.fkPasswordId = i.password.passwordId;
          i.itemPassword.setRepeated();
        }
      }
    }

    if (i.username != null) {
      if (i.username.usernameId == null) {
        i.fkUsernameId = await insertUsername(i.username);
      } else {
        i.fkUsernameId = i.username.usernameId;
      }
    } else {
      i.fkUsernameId = null;
    }

    if (i.pin != null) {
      if (i.pin.pinId == null) {
        i.fkPinId = await insertPin(i.pin);
      } else {
        i.fkPinId = i.pin.pinId;
      }
    } else {
      i.fkPinId = null;
    }

    if (i.note != null) {
      if (i.note.noteId == null) {
        i.fkNoteId = await insertNote(i.note);
      } else {
        i.fkNoteId = i.note.noteId;
      }
    } else {
      i.fkNoteId = null;
    }

    if (i.address != null) {
      if (i.address.addressId == null) {
        i.fkAddressId = await insertAddress(i.address);
      } else {
        i.fkAddressId = i.address.addressId;
      }
    } else {
      i.fkAddressId = null;
    }

    if (oldItem.product != null) {
      if (i.product != null) {
        //PRODUCT (SAME OR MODIFIED)
        if (oldItem.product.cpe23uri != null) {
          if (i.product.cpe23uri != null) {
            //CPE (SAME OR MODIFIED)
            if (!oldItem.product.cpe23uri.equal(i.product.cpe23uri)) {
              if (i.product.cpe23uri.cpe23uriId == null) {
                i.product.fkCpe23uriId =
                    await insertCpe23uri(i.product.cpe23uri);
              } else {
                i.product.fkCpe23uriId = i.product.cpe23uri.cpe23uriId;
              }
            }
          } else {
            //CPE DELETED
            i.product.fkCpe23uriId = null;
          }
        } else {
          //CPE ADDED
          if (i.product.cpe23uri.cpe23uriId == null) {
            i.product.fkCpe23uriId = await insertCpe23uri(i.product.cpe23uri);
          } else {
            i.product.fkCpe23uriId = i.product.cpe23uri.cpe23uriId;
          }
        }
        if (i.product.productId != null) updateProduct(i.product);
      } else {
        //PRODUCT DELETED
        i.fkProductId = null;
        await deleteProduct(oldItem.product);
      }
    } else {
      if (i.product != null) {
        //PRODUCT ADDED
        if (i.product.cpe23uri != null) {
          insertCpe23uri(i.product.cpe23uri).then((cpe23uriId) async {
            i.product.fkCpe23uriId = cpe23uriId;
            await insertProduct(i.product);
          });
        } else {
          await insertProduct(i.product);
        }
      }
    }

    DBHelper.update(DBHelper.itemTable, i.toMap(), 'item_id')
        .then((itemId) async {
      if (i.password != null) {
        i.itemPassword.fkItemId = itemId;
        await insertItemPassword(i.itemPassword);
      }
    });
  }

  Future<int> insertPassword(Password p) async =>
      await DBHelper.insert(DBHelper.passwordTable, p.toMap());

  Future<int> updatePassword(Password p) async =>
      await DBHelper.update(DBHelper.passwordTable, p.toMap(), 'password_id');

  Future<int> deletePassword(Password p) async =>
      await DBHelper.delete(DBHelper.passwordTable, p.toMap(), 'password_id');

  Future<void> insertItemPassword(ItemPassword ip) async =>
      await DBHelper.insert(DBHelper.itemPasswordTable, ip.toMap());

  Future<void> updateItemPassword(ItemPassword ip) async =>
      await DBHelper.updateItemPassword(ip.toMap());

  Future<void> deleteItemPassword(ItemPassword ip) async =>
      await DBHelper.deleteItemPassword(ip.toMap());

  Future<int> insertUsername(Username u) async =>
      await DBHelper.insert(DBHelper.usernameTable, u.toMap());

  Future<int> updateUsername(Username u) async =>
      await DBHelper.update(DBHelper.usernameTable, u.toMap(), 'username_id');

  Future<int> deleteUsername(Username u) async =>
      await DBHelper.delete(DBHelper.usernameTable, u.toMap(), 'username_id');

  Future<int> insertPin(Pin p) async =>
      await DBHelper.insert(DBHelper.pinTable, p.toMap());

  Future<int> updatePin(Pin p) async =>
      await DBHelper.update(DBHelper.pinTable, p.toMap(), 'pin_id');

  Future<int> deletePin(Pin p) async =>
      await DBHelper.delete(DBHelper.pinTable, p.toMap(), 'pin_id');

  Future<int> insertNote(Note n) async =>
      await DBHelper.insert(DBHelper.noteTable, n.toMap());

  Future<int> updateNote(Note n) async =>
      await DBHelper.update(DBHelper.noteTable, n.toMap(), 'note_id');

  Future<int> deleteNote(Note n) async =>
      await DBHelper.delete(DBHelper.noteTable, n.toMap(), 'note_id');

  Future<int> insertAddress(Address a) async =>
      await DBHelper.insert(DBHelper.addressTable, a.toMap());

  Future<int> updateAddress(Address a) async =>
      await DBHelper.update(DBHelper.addressTable, a.toMap(), 'address_id');

  Future<int> deleteAddress(Address a) async =>
      await DBHelper.delete(DBHelper.addressTable, a.toMap(), 'address_id');

  Future<int> insertProduct(Product p) async =>
      await DBHelper.insert(DBHelper.productTable, p.toMap());

  Future<int> updateProduct(Product p) async =>
      await DBHelper.update(DBHelper.productTable, p.toMap(), 'product_id');

  Future<int> deleteProduct(Product p) async =>
      await DBHelper.delete(DBHelper.productTable, p.toMap(), 'product_id');

  Future<int> insertCpe23uri(Cpe23uri c) {
    return DBHelper.getByValue(DBHelper.cpe23uriTable, 'value', c.value).then(
      (list) async {
        if (list.isEmpty) {
          return await DBHelper.insert(DBHelper.cpe23uriTable, c.toMap());
        } else
          return Cpe23uri.fromMap(list.first).cpe23uriId;
      },
    );
  }

  Future<Password> passwordInDB(String hash) async {
    if (hash.isEmpty) return null;
    return DBHelper.getByValue(DBHelper.passwordTable, 'password_hash', hash)
        .then((list) {
      if (list.isEmpty)
        return null;
      else
        return Password.fromMap(list.first);
    });
  }

  Future<Username> usernameInDB(String hash) async {
    if (hash.isEmpty) return null;
    return DBHelper.getByValue(DBHelper.usernameTable, 'username_hash', hash)
        .then((list) {
      if (list.isEmpty)
        return null;
      else
        return Username.fromMap(list.first);
    });
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
      (await DBHelper.getByValue(DBHelper.passwordTable, 'password_hash', hash))
          .first);

  Future<List<ItemPassword>> getLastItemPassword(int itemId) async {
    Iterable<ItemPassword> _iter;
    await DBHelper.getItemPass(itemId).then((data) {
      _iter = data.map((e) => ItemPassword.fromMap(e));
    });
    List<ItemPassword> _ips = _iter.toList();
    _ips.sort((a, b) => b.passwordDate.compareTo(a.passwordDate));
    return _ips;
  }

  Future<Pin> getPin(int id) async {
    List<Map<String, dynamic>> _p = await DBHelper.getPinById(id);
    return Pin.fromMap(_p.first);
  }

  Future<Note> getNote(int id) async {
    List<Map<String, dynamic>> _n = await DBHelper.getNoteById(id);
    return Note.fromMap(_n.first);
  }

  Future<Address> getAdress(int id) async {
    List<Map<String, dynamic>> _a = await DBHelper.getAdressById(id);
    return Address.fromMap(_a.first);
  }

  Future<Product> getProduct(int id) async {
    List<Map<String, dynamic>> _d = await DBHelper.getProductById(id);
    return Product.fromMap(_d.first);
  }

  Future<List<Username>> getUsers() async {
    Iterable<Username> _iter;
    await DBHelper.read(DBHelper.usernameTable).then((data) {
      _iter = data.map((e) => Username.fromMap(e));
    });
    return _iter.toList();
  }

  Future<int> insertTag(Tag a) async =>
      await DBHelper.insert(DBHelper.tagTable, a.toMap());

  Future<void> deleteTag(Tag t) async {
    await DBHelper.removeTag(t.tagName);
    await DBHelper.deleteTag(t.toMap());
  }

  Future<List<Tag>> getTags() async {
    Iterable<Tag> _iter;
    await DBHelper.read(DBHelper.tagTable).then((data) {
      _iter = data.map((e) => Tag.fromMap(e));
    });
    return _iter.toList();
  }

  void dispose() {
    super.dispose();
  }
}
