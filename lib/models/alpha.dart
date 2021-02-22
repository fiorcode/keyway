import 'item.dart';
import 'old_alpha.dart';

class Alpha extends Item {
  String username;
  String usernameIV;
  String usernameHash;
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
  String ipHash;
  String longText;
  String longTextIV;
  String longTextHash;

  Alpha({
    int id,
    String title = '',
    this.username = '',
    this.usernameIV = '',
    this.usernameHash = '',
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
    this.ipHash = '',
    this.longText = '',
    this.longTextIV = '',
    this.longTextHash = '',
    String date,
    String shortDate,
    int color = 0,
    int colorLetter = 0,
    String tags,
  }) : super(
          id,
          title,
          date,
          shortDate,
          color,
          colorLetter,
          tags,
        );

  Alpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    usernameIV = map['username_iv'];
    usernameHash = map['username_hash'];
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
    ipHash = map['ip_hash'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    longTextHash = map['long_text_hash'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'username_iv': usernameIV,
      'username_hash': usernameHash,
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
      'ip_hash': ipHash,
      'long_text': longText,
      'long_text_iv': longTextIV,
      'long_text_hash': longTextHash,
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
      usernameHash: this.usernameHash,
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
      ipHash: this.ipHash,
      longText: this.longText,
      longTextIV: this.longTextIV,
      longTextHash: this.longTextHash,
      date: this.date,
      shortDate: this.shortDate,
      color: this.color,
      colorLetter: this.colorLetter,
      tags: this.tags,
    );
  }

  bool _savePrevious(Alpha a) {
    if (this.title != a.title) return true;
    if (this.usernameHash != a.usernameHash) return true;
    if (this.passwordHash != a.passwordHash) return true;
    if (this.pinHash != a.pinHash) return true;
    if (this.ipHash != a.ipHash) return true;
    if (this.longTextHash != a.longTextHash) return true;
    return false;
  }

  OldAlpha saveOld(Alpha a) {
    if (_savePrevious(a)) {
      OldAlpha _old = OldAlpha.fromAlpha(this);
      if (this.title != a.title) _old.titleChange = 'changed';
      if (this.usernameHash != a.usernameHash) {
        if (a.username == '')
          _old.usernameChange = 'deleted';
        else if (this.username == '')
          _old.usernameChange = 'added';
        else
          _old.usernameChange = 'updated';
      } else
        _old.username = '';
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
      if (this.ipHash != a.ipHash) {
        if (a.ip == '')
          _old.ipChange = 'deleted';
        else if (this.ip == '')
          _old.ipChange = 'added';
        else
          _old.ipChange = 'updated';
      } else
        _old.ip = '';
      if (this.longTextHash != a.longTextHash) {
        if (a.longText == '')
          _old.longTextChange = 'deleted';
        else if (this.longText == '')
          _old.longTextChange = 'added';
        else
          _old.longTextChange = 'updated';
      } else
        _old.longText = '';
      return _old;
    } else
      return null;
  }
}
