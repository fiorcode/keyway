import 'product.dart';
import 'username.dart';
import 'item_password.dart';
import 'password.dart';
import 'pin.dart';
import 'address.dart';
import 'note.dart';

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
  int fkNoteId;
  int fkAddressId;
  int fkProductId;

  Username username;
  Password password;
  ItemPassword itemPassword;
  Pin pin;
  Note note;
  Address address;
  Product product;

  bool get deleted => this.itemStatus.contains('<deleted>');

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
    this.fkNoteId,
    this.fkAddressId,
    this.fkProductId,
    this.username,
    this.password,
    this.itemPassword,
    this.pin,
    this.note,
    this.address,
    this.product,
  });

  void setDeleted() {
    if (!deleted) this.itemStatus += '<deleted>';
  }

  void unSetDeleted() =>
      this.itemStatus = this.itemStatus.replaceAll('<deleted>', '');

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
    fkNoteId = map['fk_note_id'];
    fkAddressId = map['fk_address_id'];
    fkProductId = map['fk_product_id'];
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
      fkProductId: this.fkAddressId,
      username: this.username != null ? this.username.clone() : null,
      password: this.password != null ? this.password.clone() : null,
      itemPassword:
          this.itemPassword != null ? this.itemPassword.clone() : null,
      pin: this.pin != null ? this.pin.clone() : null,
      note: this.note != null ? this.note.clone() : null,
      address: this.address != null ? this.address.clone() : null,
      product: this.product != null ? this.product.clone() : null,
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
