import 'product.dart';
import 'username.dart';
import 'item_password.dart';
import 'password.dart';
import 'pin.dart';
import 'address.dart';
import 'note.dart';

class Item {
  int? itemId;
  String title = '';
  String date = '';
  int? avatarColor;
  int? avatarLetterColor;
  String? font;
  String? itemStatus;
  String? tags;
  int? fkUsernameId;
  int? fkPinId;
  int? fkNoteId;
  int? fkAddressId;
  int? fkProductId;

  Username? username;
  Password? password;
  List<Password>? passwords;
  ItemPassword? itemPassword;
  List<ItemPassword>? itemPasswords;
  Pin? pin;
  Note? note;
  Address? address;
  Product? product;

  bool get deleted => this.itemStatus!.contains('<deleted>');
  bool get cleartext => this.itemStatus!.contains('<cleartext>');
  bool get expired {
    if (this.itemPassword != null) {
      if (this.itemPassword!.expired) return true;
    }
    if (this.pin != null) {
      if (this.pin!.expired) return true;
    }
    return false;
  }

  bool get empty {
    if (this.username != null) {
      if (!this.username!.empty) return false;
    }
    if (this.password != null) {
      if (!this.password!.empty) return false;
    }
    if (this.pin != null) {
      if (!this.pin!.empty) return false;
    }
    if (this.note != null) {
      if (!this.note!.empty) return false;
    }
    if (this.address != null) {
      if (!this.address!.empty) return false;
    }
    if (this.product != null) {
      if (!this.product!.empty) return false;
    }
    return true;
  }

  Item.factory() {
    this.avatarColor = 4290624957;
    this.avatarLetterColor = 4294967295;
    this.font = '';
    this.itemStatus = '';
    this.tags = '';
    this.username = Username();
    this.password = Password();
    this.itemPassword = ItemPassword();
  }

  Item({
    this.itemId,
    this.title = '',
    this.date = '',
    this.avatarColor = 4290624957,
    this.avatarLetterColor = 4294967295,
    this.font = '',
    this.itemStatus = '',
    this.tags = '',
    this.fkUsernameId,
    this.fkPinId,
    this.fkNoteId,
    this.fkAddressId,
    this.fkProductId,
    this.username,
    this.password,
    this.passwords,
    this.itemPassword,
    this.itemPasswords,
    this.pin,
    this.note,
    this.address,
    this.product,
  });

  void setDeleted() {
    if (!this.deleted) this.itemStatus = this.itemStatus! + '<deleted>';
  }

  void unSetDeleted() {
    this.itemStatus = this.itemStatus!.replaceAll('<deleted>', '');
  }

  void setCleartext() {
    if (!this.cleartext) this.itemStatus = this.itemStatus! + '<cleartext>';
  }

  void unSetCleartext() {
    this.itemStatus = this.itemStatus!.replaceAll('<cleartext>', '');
  }

  bool hasOldPasswords() {
    if (this.itemPasswords == null) return false;
    if (this.itemPasswords!.isEmpty) return false;
    return true;
  }

  Item.fromMap(Map<String, dynamic> map) {
    this.itemId = map['item_id'];
    this.title = map['title'];
    this.date = map['date'];
    this.avatarColor = map['avatar_color'];
    this.avatarLetterColor = map['avatar_letter_color'];
    this.font = map['font'];
    this.itemStatus = map['item_status'];
    this.tags = map['tags'];
    this.fkUsernameId = map['fk_username_id'];
    this.fkPinId = map['fk_pin_id'];
    this.fkNoteId = map['fk_note_id'];
    this.fkAddressId = map['fk_address_id'];
    this.fkProductId = map['fk_product_id'];
    this.itemPasswords = <ItemPassword>[];
    this.passwords = <Password>[];
    this.itemPassword =
        map['fk_password_id'] != null ? ItemPassword.fromMap(map) : null;
    this.password = map['password_id'] != null ? Password.fromMap(map) : null;
    this.username =
        map['fk_username_id'] != null ? Username.fromMap(map) : null;
    this.pin = map['fk_pin_id'] != null ? Pin.fromMap(map) : null;
    this.note = map['fk_note_id'] != null ? Note.fromMap(map) : null;
    this.address = map['fk_address_id'] != null ? Address.fromMap(map) : null;
    this.product = map['fk_product_id'] != null ? Product.fromMap(map) : null;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'title': title,
      'date': date,
      'avatar_color': avatarColor,
      'avatar_letter_color': avatarLetterColor,
      'font': font,
      'item_status': itemStatus,
      'tags': tags,
      'fk_username_id': fkUsernameId,
      'fk_pin_id': fkPinId,
      'fk_note_id': fkNoteId,
      'fk_address_id': fkAddressId,
      'fk_product_id': fkProductId,
    };
    if (itemId != null) map['item_id'] = itemId;
    return map;
  }

  Item clone() {
    Item _i = Item(
      itemId: this.itemId,
      title: this.title,
      date: this.date,
      avatarColor: this.avatarColor,
      avatarLetterColor: this.avatarLetterColor,
      font: this.font,
      itemStatus: this.itemStatus,
      tags: this.tags,
      fkUsernameId: this.fkUsernameId,
      fkPinId: this.fkPinId,
      fkNoteId: this.fkNoteId,
      fkAddressId: this.fkAddressId,
      fkProductId: this.fkProductId,
      username: this.username != null ? this.username!.clone() : null,
      password: this.password != null ? this.password!.clone() : null,
      passwords: this.passwords,
      itemPassword:
          this.itemPassword != null ? this.itemPassword!.clone() : null,
      itemPasswords: this.itemPasswords,
      pin: this.pin != null ? this.pin!.clone() : null,
      note: this.note != null ? this.note!.clone() : null,
      address: this.address != null ? this.address!.clone() : null,
      product: this.product != null ? this.product!.clone() : null,
    );
    return _i;
  }

  bool changed(Item i) {
    if (this.itemId != i.itemId) return true;
    if (this.title != i.title) return true;
    if (this.date != i.date) return true;
    if (this.avatarColor != i.avatarColor) return true;
    if (this.avatarLetterColor != i.avatarLetterColor) return true;
    if (this.font != i.font) return true;
    if (this.itemStatus != i.itemStatus) return true;
    if (this.tags != i.tags) return true;
    if (this.password != null) {
      if (this.password!.notEqual(i.password)) return true;
    } else {
      if (i.password != null) return true;
    }
    if (this.itemPassword != null) {
      if (this.itemPassword!.notEqual(i.itemPassword)) return true;
    } else {
      if (i.itemPassword != null) return true;
    }
    if (this.username != null) {
      if (this.username!.notEqual(i.username)) return true;
    } else {
      if (i.username != null) return true;
    }
    if (this.pin != null) {
      if (this.pin!.notEqual(i.pin)) return true;
    } else {
      if (i.pin != null) return true;
    }
    if (this.note != null) {
      if (this.note!.notEqual(i.note)) return true;
    } else {
      if (i.note != null) return true;
    }
    if (this.address != null) {
      if (this.address!.notEqual(i.address)) return true;
    } else {
      if (i.address != null) return true;
    }
    if (this.product != null) {
      if (this.product!.notEqual(i.product)) return true;
    } else {
      if (i.product != null) return true;
    }
    return false;
  }

  void loadPasswords(List<Map<String, dynamic>> listMap) {
    if (listMap.isEmpty) return;
    listMap.forEach((ip) {
      this.itemPasswords!.add(ItemPassword.fromMap(ip));
      this.passwords!.add(Password.fromMap(ip));
    });
  }

  void addRemoveTag(String? tag) {
    if (this.tags!.contains('<$tag>')) {
      this.tags = this.tags!.replaceAll('<$tag>', '');
    } else {
      this.tags = this.tags! + '<$tag>';
    }
  }

  void clearDecriptedValues() {
    if (this.password != null) this.password!.clearPasswordDec();
    if (this.username != null) this.username!.clearUsernameDec();
    if (this.pin != null) this.pin!.clearPinDec();
    if (this.note != null) this.note!.clearNoteDec();
    if (this.address != null) this.address!.clearAddressDec();
  }
}
