import 'alpha.dart';

class DeletedAlpha extends Alpha {
  int itemId;
  String deletedDate;

  DeletedAlpha({
    int id,
    String title,
    String username,
    String usernameIV,
    String password,
    String passwordIV,
    String passwordHash,
    String passwordDate,
    int passwordLapse,
    String passwordStatus,
    String passwordLevel,
    String pin,
    String pinIV,
    String pinHash,
    String pinDate,
    int pinLapse,
    String pinStatus,
    String ip,
    String ipIV,
    String longText,
    String longTextIV,
    String date,
    int color = 0,
    int colorLetter = 0,
    String font,
    String tags,
    this.deletedDate,
    this.itemId,
  }) : super(
          id: id,
          title: title,
          username: username,
          usernameIV: usernameIV,
          password: password,
          passwordIV: passwordIV,
          passwordHash: passwordHash,
          passwordDate: passwordDate,
          passwordLapse: passwordLapse,
          passwordStatus: passwordStatus,
          passwordLevel: passwordLevel,
          pin: pin,
          pinIV: pinIV,
          pinHash: pinHash,
          pinDate: pinDate,
          pinLapse: pinLapse,
          pinStatus: pinStatus,
          ip: ip,
          ipIV: ipIV,
          longText: longText,
          longTextIV: longTextIV,
          date: date,
          color: color,
          colorLetter: colorLetter,
          font: font,
          tags: tags,
        );

  DeletedAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.usernameIV = a.usernameIV;
    this.password = a.password;
    this.passwordIV = a.passwordIV;
    this.passwordHash = a.passwordHash;
    this.passwordDate = a.passwordDate;
    this.passwordLapse = a.passwordLapse;
    this.passwordStatus = a.passwordStatus;
    this.passwordLevel = a.passwordLevel;
    this.pin = a.pin;
    this.pinIV = a.pinIV;
    this.pinHash = a.pinHash;
    this.pinDate = a.pinDate;
    this.pinLapse = a.pinLapse;
    this.pinStatus = a.pinStatus;
    this.ip = a.ip;
    this.ipIV = a.ipIV;
    this.longText = a.longText;
    this.longTextIV = a.longTextIV;
    this.date = a.date;
    this.deletedDate = DateTime.now().toUtc().toIso8601String();
    this.color = a.color;
    this.colorLetter = a.colorLetter;
    this.font = a.font;
    this.tags = a.tags;
    this.itemId = a.id;
  }

  DeletedAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    usernameIV = map['username_iv'];
    password = map['password'];
    passwordIV = map['password_iv'];
    passwordHash = map['password_hash'];
    passwordDate = map['password_date'];
    passwordLapse = map['password_lapse'];
    passwordStatus = map['password_status'];
    passwordLevel = map['password_level'];
    pin = map['pin'];
    pinIV = map['pin_iv'];
    pinHash = map['pin_hash'];
    pinDate = map['pin_date'];
    pinLapse = map['pin_lapse'];
    pinStatus = map['pin_status'];
    ip = map['ip'];
    ipIV = map['ip_iv'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    font = map['font'];
    tags = map['tags'];
    deletedDate = map['date_deleted'];
    itemId = map['item_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'username_iv': usernameIV,
      'password': password,
      'password_iv': passwordIV,
      'password_hash': passwordHash,
      'password_date': passwordDate,
      'password_lapse': passwordLapse,
      'password_status': passwordStatus,
      'password_level': passwordLevel,
      'pin': pin,
      'pin_iv': pinIV,
      'pin_hash': pinHash,
      'pin_date': pinDate,
      'pin_lapse': pinLapse,
      'pin_status': pinStatus,
      'ip': ip,
      'ip_iv': ipIV,
      'long_text': longText,
      'long_text_iv': longTextIV,
      'date': date,
      'color': color,
      'color_letter': colorLetter,
      'font': font,
      'tags': tags,
      'date_deleted': deletedDate,
      'item_id': itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
