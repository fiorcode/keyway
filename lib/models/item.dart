abstract class Item {
  int id;
  String title;
  DateTime dateTime; // ???
  String date;
  String shortDate;
  int color;
  int colorLetter;
  String expired;
  String expiredLapse;

  Item(
    this.id,
    this.title,
    this.date,
    this.shortDate,
    this.color,
    this.colorLetter,
    this.expired,
    this.expiredLapse,
  );

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    shortDate = map['date_short'];
    color = map['color'];
    colorLetter = map['color_letter'];
    expired = map['expired'];
    expiredLapse = map['expired_lapse'];
  }
}

class Alpha extends Item {
  String username;
  String password;
  String pin;
  String ip;
  String longText;
  String passStatus;
  String pinStatus;
  String passLevel;

  Alpha({
    int id,
    String title = '',
    this.username = '',
    this.password = '',
    this.pin = '',
    this.ip = '',
    this.longText = '',
    this.passStatus = '',
    this.pinStatus = '',
    this.passLevel = '',
    String date,
    String shortDate,
    int color = 0,
    int colorLetter = 0,
    String expired = '',
    String expiredLapse = '',
  }) : super(
          id,
          title,
          date,
          shortDate,
          color,
          colorLetter,
          expired,
          expiredLapse,
        );

  Alpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
    longText = map['long_text'];
    passStatus = map['pass_status'];
    pinStatus = map['pin_status'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'long_text': longText,
      'date': date,
      'date_short': shortDate,
      'color': color,
      'color_letter': colorLetter,
      'pass_status': passStatus,
      'pin_status': pinStatus,
      'pass_level': passLevel,
      'expired': expired,
      'expired_lapse': expiredLapse,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Alpha clone() {
    return Alpha(
      id: this.id,
      title: this.title,
      username: this.username,
      password: this.password,
      pin: this.pin,
      ip: this.ip,
      longText: this.longText,
      date: this.date,
      shortDate: this.shortDate,
      color: this.color,
      colorLetter: this.colorLetter,
      passStatus: this.passStatus,
      pinStatus: this.pinStatus,
      passLevel: this.passLevel,
      expired: this.expired,
      expiredLapse: this.expiredLapse,
    );
  }

  bool savePrevious(Alpha a) {
    if (this.username != a.username) return true;
    if (this.password != a.password) return true;
    if (this.pin != a.pin) return true;
    if (this.ip != a.ip) return true;
    if (this.longText != a.longText) return true;
    return false;
  }
}

class OldAlpha extends Alpha {
  int itemId;

  OldAlpha({
    int id,
    String title,
    String username,
    String password,
    String pin,
    String ip,
    String longText,
    String date,
    String shortDate,
    int color = 0,
    int colorLetter = 0,
    String passStatus,
    String pinStatus,
    String passLevel,
    String expired,
    String expiredLapse,
    this.itemId,
  }) : super();

  OldAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.password = a.password;
    this.pin = a.pin;
    this.ip = a.ip;
    this.longText = a.longText;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.color = a.color;
    this.colorLetter = a.colorLetter;
    this.passStatus = a.passStatus;
    this.pinStatus = a.pinStatus;
    this.passLevel = a.passLevel;
    this.expired = a.expired;
    this.expiredLapse = a.expiredLapse;
    this.itemId = a.id;
  }

  OldAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
    longText = map['long_text'];
    passStatus = map['pass_status'];
    pinStatus = map['pin_status'];
    passLevel = map['pass_level'];
    itemId = map['item_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'long_text': longText,
      'date': date,
      'date_short': shortDate,
      'color': color,
      'color_letter': colorLetter,
      'pass_status': passStatus,
      'pin_status': pinStatus,
      'pass_level': passLevel,
      'expired': expired,
      'expired_lapse': expiredLapse,
      'item_id': itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}

class DeletedAlpha extends Alpha {
  int itemId;
  String deletedDate;

  DeletedAlpha({
    int id,
    String title,
    String username,
    String password,
    String pin,
    String ip,
    String longText,
    String date,
    String shortDate,
    int color = 0,
    int colorLetter = 0,
    String passStatus,
    String pinStatus,
    String passLevel,
    String expired,
    String expiredLapse,
    this.deletedDate,
    this.itemId,
  }) : super();

  DeletedAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.password = a.password;
    this.pin = a.pin;
    this.ip = a.ip;
    this.longText = a.longText;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.deletedDate = DateTime.now().toUtc().toIso8601String();
    this.color = a.color;
    this.colorLetter = a.colorLetter;
    this.passStatus = a.passStatus;
    this.pinStatus = a.pinStatus;
    this.passLevel = a.passLevel;
    this.expired = a.expired;
    this.expiredLapse = a.expiredLapse;
    this.itemId = a.id;
  }

  DeletedAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
    longText = map['long_text'];
    passStatus = map['pass_status'];
    pinStatus = map['pin_status'];
    passLevel = map['pass_level'];
    deletedDate = map['date_deleted'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'long_text': longText,
      'date': date,
      'date_short': shortDate,
      'color': color,
      'color_letter': colorLetter,
      'pass_status': passStatus,
      'pin_status': pinStatus,
      'pass_level': passLevel,
      'expired': expired,
      'expired_lapse': expiredLapse,
      'date_deleted': deletedDate,
      'item_id': itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
