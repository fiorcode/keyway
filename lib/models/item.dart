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
  String status;
  String tags;
  int fkUsernameId;
  int fkPinId;
  int fkLongTextId;
  int fkDeviceId;

  Username usernameObj;
  Password passwordObj;
  ItemPassword itemPasswordObj;
  Pin pinObj;
  LongText longTextObj;
  Device deviceObj;

  Item({
    this.itemId,
    this.title = '',
    this.date = '',
    this.avatarColor = 4290624957,
    this.avatarLetterColor = 4294967295,
    this.font = '',
    this.status = '',
    this.tags = '',
    this.fkUsernameId,
    this.fkPinId,
    this.fkLongTextId,
    this.fkDeviceId,
    this.usernameObj,
    this.passwordObj,
    this.itemPasswordObj,
    this.pinObj,
    this.longTextObj,
    this.deviceObj,
  });
  // {
  //   this.usernameObj = Username();
  //   this.passwordObj = Password();
  //   this.itemPasswordObj = ItemPassword();
  //   this.pinObj = Pin();
  //   this.longTextObj = LongText();
  //   this.deviceObj = Device();
  // }

  Item.fromMap(Map<String, dynamic> map) {
    itemId = map['item_id'];
    title = map['title'];
    date = map['date'];
    avatarColor = map['avatar_color'];
    avatarLetterColor = map['avatar_letter_color'];
    font = map['font'];
    status = map['status'];
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
      'status': status,
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
      status: this.status,
      tags: this.tags,
      fkUsernameId: this.fkUsernameId,
      fkPinId: this.fkPinId,
      fkLongTextId: this.fkLongTextId,
      fkDeviceId: this.fkDeviceId,
      usernameObj: this.usernameObj != null ? this.usernameObj.clone() : null,
      passwordObj: this.passwordObj != null ? this.passwordObj.clone() : null,
      itemPasswordObj:
          this.itemPasswordObj != null ? this.itemPasswordObj.clone() : null,
      pinObj: this.pinObj != null ? this.pinObj.clone() : null,
      longTextObj: this.longTextObj != null ? this.longTextObj.clone() : null,
      deviceObj: this.deviceObj != null ? this.deviceObj.clone() : null,
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
