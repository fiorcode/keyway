import 'package:keyway/models/product.dart';
import 'package:keyway/models/username.dart';
import 'package:keyway/models/item_password.dart';
import 'package:keyway/models/password.dart';
import 'package:keyway/models/pin.dart';
import 'package:keyway/models/long_text.dart';
import 'package:keyway/models/address.dart';

class Item {
  int itemId;
  String title;
  String date;
  int avatarColor;
  int avatarLetterColor;
  String font;
  String itemStatus;
  String tags;
  int fkUsernameId;
  int fkPinId;
  int fkLongTextId;
  int fkAddressId;
  int fkProcutId;

  Username username;
  Password password;
  ItemPassword itemPassword;
  Pin pin;
  LongText longText;
  Address address;
  Product product;

  Item.factory() {
    this.title = '';
    this.date = '';
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
    this.fkLongTextId,
    this.fkAddressId,
    this.username,
    this.password,
    this.itemPassword,
    this.pin,
    this.longText,
    this.address,
  });

  Item.fromMap(Map<String, dynamic> map) {
    itemId = map['item_id'];
    title = map['title'];
    date = map['date'];
    avatarColor = map['avatar_color'];
    avatarLetterColor = map['avatar_letter_color'];
    font = map['font'];
    itemStatus = map['item_status'];
    tags = map['tags'];
    fkUsernameId = map['fk_username_id'];
    fkPinId = map['fk_pin_id'];
    fkLongTextId = map['fk_long_text_id'];
    fkAddressId = map['fk_address_id'];
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
      'fk_long_text_id': fkLongTextId,
      'fk_address_id': fkAddressId,
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
      fkLongTextId: this.fkLongTextId,
      fkAddressId: this.fkAddressId,
      username: this.username != null ? this.username.clone() : null,
      password: this.password != null ? this.password.clone() : null,
      itemPassword:
          this.itemPassword != null ? this.itemPassword.clone() : null,
      pin: this.pin != null ? this.pin.clone() : null,
      longText: this.longText != null ? this.longText.clone() : null,
      address: this.address != null ? this.address.clone() : null,
    );
    return _i;
  }

  void addRemoveTag(String tag) {
    if (this.tags.contains('<$tag>')) {
      this.tags = this.tags.replaceAll('<$tag>', '');
    } else {
      this.tags += '<$tag>';
    }
  }
}
