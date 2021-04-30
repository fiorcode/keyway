class Item {
  int id;
  String title;
  String date;
  int avatarColor;
  int avatarLetterColor;
  String font;
  String status;
  String tags;
  int usernameId;
  int passwordId;
  int pinId;
  int longTextId;
  int deviceId;

  Item({
    this.id,
    this.title = '',
    this.date = '',
    this.avatarColor = 4290624957,
    this.avatarLetterColor = 4294967295,
    this.font = '',
    this.status = '',
    this.tags = '',
  });

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    avatarColor = map['avatar_color'];
    avatarLetterColor = map['avatar_letter_color'];
    font = map['font'];
    status = map['status'];
    tags = map['tags'];
    usernameId = map['username_id'];
    passwordId = map['password_id'];
    pinId = map['pin_id'];
    longTextId = map['long_text_id'];
    deviceId = map['device_id'];
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
      'username_id': usernameId,
      'password_id': passwordId,
      'pin_id': pinId,
      'long_text_id': longTextId,
      'device_id': deviceId,
    };
    if (id != null) map['id'] = id;
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
