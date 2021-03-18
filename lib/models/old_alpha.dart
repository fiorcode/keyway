import 'alpha.dart';

class OldAlpha extends Alpha {
  int itemId;
  String passwordChange;
  String pinChange;

  OldAlpha({
    int id,
    String title = '',
    String username = '',
    String usernameIV = '',
    String usernameHash = '',
    String password = '',
    String passwordIV = '',
    String passwordHash = '',
    String passwordDate = '',
    int passwordLapse = 320,
    String passwordStatus = '',
    String passwordLevel = '',
    this.passwordChange = '',
    String pin = '',
    String pinIV = '',
    String pinHash = '',
    String pinDate = '',
    int pinLapse = 320,
    String pinStatus = '',
    this.pinChange = '',
    String ip = '',
    String ipIV = '',
    String ipHash = '',
    String longTextIV = '',
    String longText = '',
    String longTextHash = '',
    String date = '',
    String shortDate = '',
    int color,
    int colorLetter,
    String tags = '',
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
          shortDate: shortDate,
          color: color,
          colorLetter: colorLetter,
          tags: tags,
        );

  OldAlpha.fromAlpha(Alpha a) {
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
    this.passwordChange = '';
    this.pin = a.pin;
    this.pinIV = a.pinIV;
    this.pinHash = a.pinHash;
    this.pinDate = a.pinDate;
    this.pinLapse = a.pinLapse;
    this.pinStatus = a.pinStatus;
    this.pinChange = '';
    this.ip = a.ip;
    this.ipIV = a.ipIV;
    this.longText = a.longText;
    this.longTextIV = a.longTextIV;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.color = a.color;
    this.colorLetter = a.colorLetter;
    this.tags = a.tags;
    this.itemId = a.id;
  }

  OldAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    usernameIV = map['username_iv'];
    password = map['password'];
    passwordIV = map['password_iv'];
    passwordHash = map['password_hash'];
    passwordDate = map['password_date'];
    passwordLapse = map['password_lapse'];
    passwordStatus = map['password_status'];
    passwordLevel = map['password_level'];
    passwordChange = map['password_change'];
    pin = map['pin'];
    pinIV = map['pin_iv'];
    pinHash = map['pin_hash'];
    pinDate = map['pin_date'];
    pinLapse = map['pin_lapse'];
    pinChange = map['pin_change'];
    pinStatus = map['pin_status'];
    ip = map['ip'];
    ipIV = map['ip_iv'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    tags = map['tags'];
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
      'password_change': passwordChange,
      'password_status': passwordStatus,
      'password_level': passwordLevel,
      'pin': pin,
      'pin_iv': pinIV,
      'pin_hash': pinHash,
      'pin_status': pinStatus,
      'pin_change': pinChange,
      'ip': ip,
      'ip_iv': ipIV,
      'long_text': longText,
      'long_text_iv': longTextIV,
      'date': date,
      'date_short': shortDate,
      'color': color,
      'color_letter': colorLetter,
      'tags': tags,
      'item_id': itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  OldAlpha cloneOld() {
    var old = OldAlpha(
      id: this.id,
      title: this.title,
      username: this.username,
      usernameIV: this.usernameIV,
      password: this.password,
      passwordIV: this.passwordIV,
      passwordHash: this.passwordHash,
      passwordDate: this.passwordDate,
      passwordLapse: this.passwordLapse,
      passwordStatus: this.passwordStatus,
      passwordLevel: this.passwordLevel,
      passwordChange: this.passwordChange,
      pin: this.pin,
      pinIV: this.pinIV,
      pinHash: this.pinHash,
      pinDate: this.pinDate,
      pinLapse: this.pinLapse,
      pinStatus: this.pinStatus,
      pinChange: this.pinChange,
      ip: this.ip,
      ipIV: this.ipIV,
      longText: this.longText,
      longTextIV: this.longTextIV,
      date: this.date,
      shortDate: this.shortDate,
      color: this.color,
      colorLetter: this.colorLetter,
      tags: this.tags,
    );
    return old;
  }
}
