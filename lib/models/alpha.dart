import 'item.dart';
import 'old_alpha.dart';

class Alpha extends Item {
  String username;
  String usernameIV;
  String password;
  String passwordIV;
  String passwordHash;
  String passwordDate;
  String passwordLapse;
  String passwordStatus;
  String passwordLevel;
  String pin;
  String pinIV;
  String pinHash;
  String pinDate;
  String pinLapse;
  String pinStatus;
  String ip;
  String ipIV;
  String longText;
  String longTextIV;

  Alpha({
    int id,
    String title = '',
    this.username = '',
    this.usernameIV = '',
    this.password = '',
    this.passwordIV = '',
    this.passwordHash = '',
    this.passwordDate = '',
    this.passwordLapse = '',
    this.passwordStatus = '',
    this.passwordLevel = '',
    this.pin = '',
    this.pinIV = '',
    this.pinHash = '',
    this.pinDate = '',
    this.pinLapse = '',
    this.pinStatus = '',
    this.ip = '',
    this.ipIV = '',
    this.longText = '',
    this.longTextIV = '',
    String date,
    String shortDate,
    int color = -1,
    int colorLetter = -1,
    String tags = '',
  }) : super(
          id: id,
          title: title,
          date: date,
          shortDate: shortDate,
          color: color,
          colorLetter: colorLetter,
          tags: tags,
        );

  Alpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
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
      'date_short': shortDate,
      'color': color,
      'color_letter': colorLetter,
      'tags': tags,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Alpha clone() {
    return Alpha(
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
      pin: this.pin,
      pinIV: this.pinIV,
      pinHash: this.pinHash,
      pinDate: this.pinDate,
      pinLapse: this.pinLapse,
      pinStatus: this.pinStatus,
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
  }

  OldAlpha saveOld(Alpha a) {
    if (this.passwordHash == a.passwordHash && this.pinHash == a.pinHash)
      return null;
    OldAlpha _old = OldAlpha.fromAlpha(this);
    if (this.passwordHash != a.passwordHash) {
      if (a.password == '')
        _old.passwordChange = 'deleted';
      else if (this.password == '')
        _old.passwordChange = 'added';
      else
        _old.passwordChange = 'updated';
    } else
      _old.password = '';
    if (this.pinHash != a.pinHash) {
      if (a.pin == '')
        _old.pinChange = 'deleted';
      else if (this.pin == '')
        _old.pinChange = 'added';
      else
        _old.pinChange = 'updated';
    } else
      _old.pin = '';
    return _old;
  }
}
