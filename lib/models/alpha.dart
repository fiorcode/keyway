import 'item.dart';
import 'old_password_pin.dart';

class Alpha extends Item {
  String username;
  String usernameIV;
  String password;
  String passwordIV;
  String passwordHash;
  String passwordDate;
  int passwordLapse;
  String passwordStatus;
  String passwordLevel;
  String pin;
  String pinIV;
  String pinHash;
  String pinDate;
  int pinLapse;
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
    this.passwordLapse = 192,
    this.passwordStatus = '',
    this.passwordLevel = '',
    this.pin = '',
    this.pinIV = '',
    this.pinHash = '',
    this.pinDate = '',
    this.pinLapse = 192,
    this.pinStatus = '',
    this.ip = '',
    this.ipIV = '',
    this.longText = '',
    this.longTextIV = '',
    String date,
    int color,
    int colorLetter,
    String tags = '',
  }) : super(
          id: id,
          title: title,
          date: date,
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
    Map<String, dynamic> map = <String, dynamic>{
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
      color: this.color,
      colorLetter: this.colorLetter,
      tags: this.tags,
    );
  }

  copyPasswordValues(OldPasswrodPin opp) {
    opp.passwordPin = this.password;
    opp.passwordPinIv = this.passwordIV;
    opp.passwordPinHash = this.passwordHash;
    opp.passwordPinDate = this.passwordDate;
    opp.passwordPinLevel = this.passwordLevel;
    opp.type = 'password';
    opp.itemId = this.id;
  }

  copyPinValues(OldPasswrodPin opp) {
    opp.passwordPin = this.pin;
    opp.passwordPinIv = this.pinIV;
    opp.passwordPinHash = this.pinHash;
    opp.passwordPinDate = this.pinDate;
    opp.passwordPinLevel = '';
    opp.type = 'pin';
    opp.itemId = this.id;
  }
}
