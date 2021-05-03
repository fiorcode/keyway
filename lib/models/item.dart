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
  // int fkPasswordId;
  int fkPinId;
  int fkLongTextId;
  int fkDeviceId;

  Item({
    this.itemId,
    this.title = '',
    this.date = '',
    this.avatarColor = 4290624957,
    this.avatarLetterColor = 4294967295,
    this.font = '',
    this.status = '',
    this.tags = '',
  });

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
    // fkPasswordId = map['fk_password_id'];
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
      // 'fk_password_id': fkPasswordId,
      'fk_pin_id': fkPinId,
      'fk_long_text_id': fkLongTextId,
      'fk_device_id': fkDeviceId,
    };
    if (itemId != null) map['item_id'] = itemId;
    return map;
  }

  void addRemoveTag(String tag) {
    if (this.tags.contains('<$tag>')) {
      this.tags = this.tags.replaceAll('<$tag>', '');
    } else {
      this.tags += '<$tag>';
    }
  }
}
