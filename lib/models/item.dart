import 'package:keyway/models/device.dart';
import 'package:keyway/models/item_password.dart';
import 'package:keyway/models/longText.dart';
import 'package:keyway/models/password.dart';
import 'package:keyway/models/pin.dart';
import 'package:keyway/models/username.dart';

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
  int fkDeviceId;

  Username username;
  Password password;
  ItemPassword itemPassword;
  Pin pin;
  LongText longText;
  Device device;

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
    this.fkDeviceId,
    this.username,
    this.password,
    this.itemPassword,
    this.pin,
    this.longText,
    this.device,
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
    fkDeviceId = map['fk_device_id'];
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
      'fk_device_id': fkDeviceId,
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
      fkDeviceId: this.fkDeviceId,
      username: this.username != null ? this.username.clone() : null,
      password: this.password != null ? this.password.clone() : null,
      itemPassword:
          this.itemPassword != null ? this.itemPassword.clone() : null,
      pin: this.pin != null ? this.pin.clone() : null,
      longText: this.longText != null ? this.longText.clone() : null,
      device: this.device != null ? this.device.clone() : null,
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
