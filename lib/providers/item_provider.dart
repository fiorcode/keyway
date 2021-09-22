import 'dart:math';
import 'package:flutter/material.dart';

import '../providers/cripto_provider.dart';
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
import '../models/product_cve.dart';
import '../models/user.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<ItemPassword> _itemsPasswords = [];
  List<Password> _passwords = [];
  List<Username> _usernames = [];
  List<Pin> _pins = [];
  List<Note> _notes = [];
  List<Address> _addresses = [];
  List<Product> _products = [];
  List<ProductCve> _productCves = [];
  List<Cpe23uri> _cpe23uris = [];
  List<Cpe23uriCve> _cpe23uriCves = [];
  List<Cve> _cves = [];

  List<Item> get items => [..._items];
  List<ItemPassword> get itemPasswords => [..._itemsPasswords];
  List<Password> get passwords => [..._passwords];
  List<Username> get usernames => [..._usernames];
  List<Pin> get pins => [..._pins];
  List<Note> get notes => [..._notes];
  List<Address> get addresses => [..._addresses];
  List<Product> get products => [..._products];
  List<ProductCve> get productCves => [..._productCves];
  List<Cpe23uri> get cpe23uris => [..._cpe23uris];
  List<Cpe23uriCve> get cpe23uriCves => [..._cpe23uriCves];
  List<Cve> get cves => [..._cves];

  Future<List<Item>> fetchItems() async {
    _items = (await DBHelper.getItems()).map((i) => Item.fromMap(i)).toList();
    return _items;
  }

  Future<List<ItemPassword>> fetchItemPasswords() async {
    _itemsPasswords = (await DBHelper.read(DBHelper.itemPasswordTable))
        .map((i) => ItemPassword.fromMap(i))
        .toList();
    return _itemsPasswords;
  }

  Future<List<Password>> fetchPasswords() async {
    _passwords = (await DBHelper.read(DBHelper.passwordTable))
        .map((i) => Password.fromMap(i))
        .toList();
    return _passwords;
  }

  Future<List<Username>> fetchUsernames() async {
    _usernames = (await DBHelper.read(DBHelper.usernameTable))
        .map((i) => Username.fromMap(i))
        .toList();
    return _usernames;
  }

  Future<List<Pin>> fetchPins() async {
    _pins = (await DBHelper.read(DBHelper.pinTable))
        .map((i) => Pin.fromMap(i))
        .toList();
    return _pins;
  }

  Future<List<Note>> fetchNotes() async {
    _notes = (await DBHelper.read(DBHelper.noteTable))
        .map((i) => Note.fromMap(i))
        .toList();
    return _notes;
  }

  Future<List<Address>> fetchAddresses() async {
    _addresses = (await DBHelper.read(DBHelper.addressTable))
        .map((i) => Address.fromMap(i))
        .toList();
    return _addresses;
  }

  Future<List<Product>> fetchProducts() async {
    _products = (await DBHelper.read(DBHelper.productTable))
        .map((i) => Product.fromMap(i))
        .toList();
    return _products;
  }

  Future<List<ProductCve>> fetchProductCves() async {
    _productCves = (await DBHelper.read(DBHelper.productCveTable))
        .map((i) => ProductCve.fromMap(i))
        .toList();
    return _productCves;
  }

  Future<List<Cpe23uri>> fetchCpe23uris() async {
    _cpe23uris = (await DBHelper.read(DBHelper.cpe23uriTable))
        .map((i) => Cpe23uri.fromMap(i))
        .toList();
    return _cpe23uris;
  }

  Future<List<Cpe23uriCve>> fetchCpe23uriCves() async {
    _cpe23uriCves = (await DBHelper.read(DBHelper.cpe23uriCveTable))
        .map((i) => Cpe23uriCve.fromMap(i))
        .toList();
    return _cpe23uriCves;
  }

  Future<List<Cve>> fetchCves() async {
    _cves = (await DBHelper.read(DBHelper.cveTable))
        .map((i) => Cve.fromMap(i))
        .toList();
    return _cves;
  }

  Future<int> insertItem(Item i, {String date}) async {
    //TODO: change this in production
    if (date != null)
      i.date = date;
    else
      i.date = DateTime.now().toIso8601String();
    //--------------------------------

    if (i.password != null) {
      i.itemPassword.passwordDate = i.date;
      if (i.password.passwordId == null) {
        i.itemPassword.fkPasswordId = await insertPassword(i.password);
      } else {
        i.itemPassword.fkPasswordId = i.password.passwordId;
        i.itemPassword.setRepeated();
        await _setRepeated(i.password.passwordId);
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
          if (i.product.cpe23uri.vulnerabilities.isNotEmpty) {
            await Future.forEach(i.product.cpe23uri.vulnerabilities,
                (String v) async {
              int cveId = await insertCve(Cve(cve: v));
              await insertCpe23UriCve(Cpe23uriCve(cpe23uriId, cveId));
            });
          }
        });
      } else {
        i.fkProductId = await insertProduct(i.product);
      }
    }
    int _itemId = await DBHelper.insert(DBHelper.itemTable, i.toMap());
    if (i.password != null) {
      i.itemPassword.fkItemId = _itemId;
      await insertItemPassword(i.itemPassword);
    }
    return _itemId;
  }

  Future<void> updateItem(Item oldItem, Item i) async {
    if (oldItem.password != null) {
      if (i.password != null) {
        if (i.password.passwordId == null) {
          i.itemPassword = ItemPassword();
          i.itemPassword.passwordDate = DateTime.now().toIso8601String();
          i.itemPassword.fkPasswordId = await insertPassword(i.password);
          oldItem.itemPassword.setOld();
          await updateItemPassword(oldItem.itemPassword);
        } else {
          if (oldItem.password.passwordId != i.password.passwordId) {
            i.itemPassword.passwordDate = DateTime.now().toIso8601String();
            i.itemPassword.fkPasswordId = i.password.passwordId;
            i.itemPassword.setRepeated();
            await _setRepeated(i.password.passwordId);
            oldItem.itemPassword.setOld();
            await updateItemPassword(oldItem.itemPassword);
          } else {
            await updateItemPassword(i.itemPassword);
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
          await _setRepeated(i.password.passwordId);
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
      if (oldItem.pin != null) {
        if (i.pin.notEqual(oldItem.pin)) {
          i.pin.pinId = oldItem.pin.pinId;
          i.pin.pinDate = DateTime.now().toIso8601String();
          await updatePin(i.pin);
        }
      } else {
        i.pin.pinDate = DateTime.now().toIso8601String();
        i.fkPinId = await insertPin(i.pin);
      }
    } else {
      i.fkPinId = null;
    }

    if (i.note != null) {
      if (i.note.noteId == null) {
        i.fkNoteId = await insertNote(i.note);
      } else {
        i.fkNoteId = i.note.noteId;
        await updateNote(i.note);
      }
    } else {
      i.fkNoteId = null;
    }

    if (i.address != null) {
      if (i.address.addressId == null) {
        i.fkAddressId = await insertAddress(i.address);
      } else {
        i.fkAddressId = i.address.addressId;
        await updateAddress(i.address);
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
                if (i.product.cpe23uri.vulnerabilities.isNotEmpty) {
                  await Future.forEach(i.product.cpe23uri.vulnerabilities,
                      (String v) async {
                    int cveId = await insertCve(Cve(cve: v));
                    await insertCpe23UriCve(
                      Cpe23uriCve(i.product.fkCpe23uriId, cveId),
                    );
                    await insertProductCve(ProductCve(
                        fkProductId: i.product.productId, fkCveId: cveId));
                  });
                }
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
          if (i.product.cpe23uri != null) {
            if (i.product.cpe23uri.cpe23uriId == null) {
              i.product.fkCpe23uriId = await insertCpe23uri(i.product.cpe23uri);
              if (i.product.cpe23uri.vulnerabilities.isNotEmpty) {
                await Future.forEach(i.product.cpe23uri.vulnerabilities,
                    (String v) async {
                  int cveId = await insertCve(Cve(cve: v));
                  await insertCpe23UriCve(
                    Cpe23uriCve(i.product.fkCpe23uriId, cveId),
                  );
                  await insertProductCve(ProductCve(
                      fkProductId: i.product.productId, fkCveId: cveId));
                });
              }
            } else {
              i.product.fkCpe23uriId = i.product.cpe23uri.cpe23uriId;
            }
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

    DBHelper.update(DBHelper.itemTable, i.toMap(), 'item_id').then((_) async {
      if (i.password != null) {
        if (oldItem.itemPassword.fkPasswordId != i.itemPassword.fkPasswordId) {
          i.itemPassword.fkItemId = i.itemId;
          await insertItemPassword(i.itemPassword);
        }
      }
      oldItem = i;
    });
  }

  Future<int> insertPassword(Password p) async =>
      await DBHelper.insert(DBHelper.passwordTable, p.toMap());

  Future<int> updatePassword(Item oldItem, Item newItem) async {
    //logical
    if (oldItem.password != null) {
      if (newItem.password != null) {
        if (oldItem.password.notEqual(newItem.password)) {
          if (newItem.password.passwordId == null) {
            return insertPassword(newItem.password);
          } else {
            return newItem.password.passwordId;
          }
        } else {
          return newItem.password.passwordId;
        }
      } else {
        return null;
      }
    } else {
      if (newItem != null) {
        if (newItem.password.passwordId == null) {
          return insertPassword(newItem.password);
        } else {
          return newItem.password.passwordId;
        }
      } else {
        return null;
      }
    }
  }

  Future<int> deletePassword(Password p) async {
    await DBHelper.deletePasswordItems(p.passwordId);
    return DBHelper.delete(DBHelper.passwordTable, p.toMap(), 'password_id');
  }

  Future<void> insertItemPassword(ItemPassword ip) async =>
      await DBHelper.insert(DBHelper.itemPasswordTable, ip.toMap());

  Future<void> updateItemPassword(ItemPassword ip) async =>
      await DBHelper.updateItemPassword(ip.toMap());

  // Future<void> deleteItemPassword(ItemPassword ip) async =>
  //     await DBHelper.deleteItemPassword(ip.toMap());

  Future<void> loadPasswords(Item i) async {
    List<Map<String, dynamic>> _list =
        await DBHelper.getPasswordsByItemId(i.itemId);
    i.loadPasswords(_list);
  }

  Future<int> insertUsername(Username u) async =>
      await DBHelper.insert(DBHelper.usernameTable, u.toMap());

  // Future<int> updateUsername(Username u) async =>
  //     await DBHelper.update(DBHelper.usernameTable, u.toMap(), 'username_id');

  Future<int> deleteUsername(Username u) async {
    await DBHelper.deleteUsernameItem(u.usernameId);
    return DBHelper.delete(DBHelper.usernameTable, u.toMap(), 'username_id');
  }

  Future<int> insertPin(Pin p) async =>
      await DBHelper.insert(DBHelper.pinTable, p.toMap());

  Future<int> updatePin(Pin p) async =>
      await DBHelper.update(DBHelper.pinTable, p.toMap(), 'pin_id');

  Future<int> deletePin(Pin p) async {
    await DBHelper.deletePinItem(p.pinId);
    return DBHelper.delete(DBHelper.pinTable, p.toMap(), 'pin_id');
  }

  Future<int> insertNote(Note n) async =>
      await DBHelper.insert(DBHelper.noteTable, n.toMap());

  Future<int> updateNote(Note n) async =>
      await DBHelper.update(DBHelper.noteTable, n.toMap(), 'note_id');

  Future<int> deleteNote(Note n) async {
    await DBHelper.deleteNoteItem(n.noteId);
    return DBHelper.delete(DBHelper.noteTable, n.toMap(), 'note_id');
  }

  Future<int> insertAddress(Address a) async =>
      await DBHelper.insert(DBHelper.addressTable, a.toMap());

  Future<int> updateAddress(Address a) async =>
      await DBHelper.update(DBHelper.addressTable, a.toMap(), 'address_id');

  Future<int> deleteAddress(Address a) async {
    await DBHelper.deleteAddressItem(a.addressId);
    return DBHelper.delete(DBHelper.addressTable, a.toMap(), 'address_id');
  }

  Future<int> insertProduct(Product p) async =>
      await DBHelper.insert(DBHelper.productTable, p.toMap());

  Future<int> updateProduct(Product p) async =>
      await DBHelper.update(DBHelper.productTable, p.toMap(), 'product_id');

  Future<int> insertProductCve(ProductCve pc) async =>
      await DBHelper.insert(DBHelper.productCveTable, pc.toMap());

  Future<int> deleteProduct(Product p) async {
    await DBHelper.deleteProductItem(p.productId);
    return DBHelper.delete(DBHelper.productTable, p.toMap(), 'product_id');
  }

  Future<int> insertCpe23uri(Cpe23uri c) {
    return DBHelper.getByValue(DBHelper.cpe23uriTable, 'value', c.value).then(
      (list) {
        if (list.isEmpty) {
          return DBHelper.insert(DBHelper.cpe23uriTable, c.toMap());
        } else
          return Cpe23uri.fromMap(list.first).cpe23uriId;
      },
    );
  }

  Future<int> insertCpe23UriCve(Cpe23uriCve cc) async {
    return DBHelper.insert(DBHelper.cpe23uriCveTable, cc.toMap());
  }

  Future<int> insertCve(Cve c) async {
    return DBHelper.getCveByName(c.cve).then((list) {
      if (list.isNotEmpty)
        return Cve.fromMap(list.first).cveId;
      else
        return DBHelper.insert(DBHelper.cveTable, c.toMap());
    });
  }

  Future<Password> passwordInDB(String hash) async {
    if (hash.isEmpty) return null;
    List<Map<String, dynamic>> _list = await DBHelper.getByValue(
        DBHelper.passwordTable, 'password_hash', hash);
    if (_list.isEmpty)
      return null;
    else
      return Password.fromMap(_list.first);
  }

  Future<void> _setRepeated(int passwordId) async {
    return DBHelper.getItemPasswordsByPasswordId(passwordId).then((data) {
      List<ItemPassword> _ips = <ItemPassword>[];
      _ips = data.map((e) => ItemPassword.fromMap(e)).toList();
      if (_ips.isNotEmpty) {
        Future.forEach(_ips, (ItemPassword ip) async {
          if (!ip.repeated) {
            ip.setRepeated();
            await updateItemPassword(ip);
          }
        });
      }
    });
  }

  Future<Username> usernameInDB(String hash) async {
    if (hash.isEmpty) return null;
    List<Map<String, dynamic>> _list = await DBHelper.getByValue(
        DBHelper.usernameTable, 'username_hash', hash);
    if (_list.isEmpty)
      return null;
    else
      return Username.fromMap(_list.first);
  }

  // Future<void> refreshItemPasswordStatus(int passwordId) async =>
  //     await DBHelper.refreshItemPasswordStatus(passwordId);

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

  Future<List<ItemPassword>> getItemPasswordsByItemId(int itemId) async {
    List<ItemPassword> _ips;
    await DBHelper.getItemPasswordsByItemId(itemId).then((data) {
      _ips = data.map((e) => ItemPassword.fromMap(e)).toList();
      _ips.sort((a, b) => b.passwordDate.compareTo(a.passwordDate));
    });
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

  Future<List<Product>> getProductsWithNoCpe() async {
    Iterable<Product> _iter;
    await DBHelper.getProductsWithNoCpe().then((data) {
      _iter = data.map((i) => Product.fromMap(i));
    });
    return _iter.toList();
  }

  Future<List<Username>> getUsers() async {
    Iterable<Username> _iter;
    await DBHelper.read(DBHelper.usernameTable).then((data) {
      _iter = data.map((e) => Username.fromMap(e));
    });
    return _iter.toList();
  }

  Future<Tag> insertTag(Tag t) async {
    List<Map<String, dynamic>> _tags = await DBHelper.getTagByName(t.tagName);
    if (_tags.isEmpty) {
      await DBHelper.insert(DBHelper.tagTable, t.toMap());
      return t;
    } else {
      return Tag.fromMap(_tags.first);
    }
  }

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

  Future<List<User>> getUserData() async {
    Iterable<User> _iter;
    await DBHelper.read(DBHelper.userTable).then((data) {
      _iter = data.map((e) => User.fromMap(e));
    });
    return _iter.toList();
  }

  Future<void> mockData() async {
    CriptoProvider _cripto = CriptoProvider();
    await _cripto.unlock('Qwe123!');
    List<String> _titles = [
      'Facebook',
      'Instagram',
      'WiFiCasa',
      'Spotify',
      'Netflix',
      'Steam',
      'Discord',
      'GitHub',
      'Zoom',
      'TeamViewer',
    ];
    List<String> _tags = [
      'social',
      'hard',
      'stream',
      'game',
      'code',
      'app',
    ];
    Random _r = Random();
    await Future.forEach(_tags, (t) async {
      Color _c = Color.fromRGBO(
        _r.nextInt(255),
        _r.nextInt(255),
        _r.nextInt(255),
        1,
      );
      insertTag(Tag(tagName: t, tagColor: _c.value));
    });
    _tags = [
      'social',
      'social',
      'hard',
      'stream',
      'stream',
      'game',
      'game',
      'code',
      'app',
      'app'
    ];
    int _t = 0;
    await Future.forEach(_titles, (t) async {
      DateTime _date = DateTime(2021, _r.nextInt(7) + 1, _r.nextInt(27) + 1);
      Color _avatarColor = Color.fromRGBO(
        _r.nextInt(255),
        _r.nextInt(255),
        _r.nextInt(255),
        1,
      );
      Password _p = _cripto.createPassword(t + '@password');
      ItemPassword _ip = ItemPassword(passwordLapse: _r.nextInt(360) + 1);
      Username _u = _cripto.createUsername(t + '@username');
      Pin _pin = _cripto.createPin(_r.nextInt(9999).toString());
      _pin.pinLapse = _r.nextInt(360) + 1;
      Note _n = _cripto.createNote(t + '@note');
      Address _a = _cripto.createAddress('www.' + t + '.com');
      Product _pr = Product(
        productTrademark: t + '_trademark',
        productModel: t + '_model',
      );
      Item _i = Item(
        title: t,
        date: _date.toIso8601String(),
        avatarColor: _avatarColor.value,
        avatarLetterColor: _setAvatarLetterColor(_avatarColor).value,
        password: _p,
        itemPassword: _ip,
        username: _u,
        pin: _pin,
        note: _n,
        address: _a,
        product: _pr,
      );
      _i.addRemoveTag(_tags[_t]);
      _t += 1;
      await insertItem(_i, date: _date.toIso8601String());
    });
  }

  Color _setAvatarLetterColor(Color c) {
    double _bgDelta = c.red * 0.299 + c.green * 0.587 + c.blue * 0.114;
    return (255 - _bgDelta > 105) ? Colors.white : Colors.black;
  }
}
