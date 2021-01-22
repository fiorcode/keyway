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
  String usernameIV;
  String usernameHash;
  String password;
  String passwordIV;
  String passwordHash;
  String pin;
  String pinIV;
  String pinHash;
  String ip;
  String ipIV;
  String ipHash;
  String longText;
  String longTextIV;
  String longTextHash;
  String passStatus;
  String pinStatus;
  String passLevel;

  Alpha({
    int id,
    String title = '',
    this.username = '',
    this.usernameIV = '',
    this.usernameHash = '',
    this.password = '',
    this.passwordIV = '',
    this.passwordHash = '',
    this.pin = '',
    this.pinIV = '',
    this.pinHash = '',
    this.ip = '',
    this.ipIV = '',
    this.ipHash = '',
    this.longText = '',
    this.longTextIV = '',
    this.longTextHash = '',
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
    usernameIV = map['username_iv'];
    usernameHash = map['username_hash'];
    password = map['password'];
    passwordIV = map['password_iv'];
    passwordHash = map['password_hash'];
    pin = map['pin'];
    pinIV = map['pin_iv'];
    pinHash = map['pin_hash'];
    ip = map['ip'];
    ipIV = map['ip_iv'];
    ipHash = map['ip_hash'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    longTextHash = map['long_text_hash'];
    passStatus = map['pass_status'];
    pinStatus = map['pin_status'];
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
      'pin': pin,
      'pin_iv': pinIV,
      'pin_hash': pinHash,
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
      usernameIV: this.usernameIV,
      usernameHash: this.usernameHash,
      password: this.password,
      passwordIV: this.passwordIV,
      passwordHash: this.passwordHash,
      pin: this.pin,
      pinIV: this.pinIV,
      pinHash: this.pinHash,
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
      passStatus: this.passStatus,
      pinStatus: this.pinStatus,
      passLevel: this.passLevel,
      expired: this.expired,
      expiredLapse: this.expiredLapse,
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

class OldAlpha extends Alpha {
  int itemId;
  String titleChange;
  String usernameChange;
  String passwordChange;
  String pinChange;
  String ipChange;
  String longTextChange;

  OldAlpha({
    int id,
    String title,
    this.titleChange,
    String username,
    String usernameIV,
    String usernameHash,
    this.usernameChange,
    String password,
    String passwordIV,
    String passwordHash,
    this.passwordChange,
    String pin,
    String pinIV,
    String pinHash,
    this.pinChange,
    String ip,
    String ipIV,
    String ipHash,
    this.ipChange,
    String longTextIV,
    String longText,
    String longTextHash,
    this.longTextChange,
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
  }) : super(
          id: id,
          title: title,
          username: username,
          usernameIV: usernameIV,
          usernameHash: usernameHash,
          password: password,
          passwordIV: passwordIV,
          passwordHash: passwordHash,
          pin: pin,
          pinIV: pinIV,
          pinHash: pinHash,
          ip: ip,
          ipIV: ipIV,
          ipHash: ipHash,
          longText: longText,
          longTextIV: longTextIV,
          longTextHash: longTextHash,
          date: date,
          shortDate: shortDate,
          color: color,
          colorLetter: colorLetter,
          passStatus: passStatus,
          pinStatus: pinStatus,
          passLevel: passLevel,
          expired: expired,
          expiredLapse: expiredLapse,
        );

  OldAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.usernameIV = a.usernameIV;
    this.usernameHash = a.usernameHash;
    this.password = a.password;
    this.passwordIV = a.passwordIV;
    this.passwordHash = a.passwordHash;
    this.pin = a.pin;
    this.pinIV = a.pinIV;
    this.pinHash = a.pinHash;
    this.ip = a.ip;
    this.ipIV = a.ipIV;
    this.ipHash = a.ipHash;
    this.longText = a.longText;
    this.longTextIV = a.longTextIV;
    this.longTextHash = a.longTextHash;
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
    titleChange = map['title_change'];
    username = map['username'];
    usernameIV = map['username_iv'];
    usernameHash = map['username_hash'];
    usernameChange = map['username_change'];
    password = map['password'];
    passwordIV = map['password_iv'];
    passwordHash = map['password_hash'];
    passwordChange = map['password_change'];
    pin = map['pin'];
    pinIV = map['pin_iv'];
    pinHash = map['pin_hash'];
    pinChange = map['pin_change'];
    ip = map['ip'];
    ipIV = map['ip_iv'];
    ipHash = map['ip_hash'];
    ipChange = map['ip_change'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    longTextHash = map['long_text_hash'];
    longTextChange = map['long_text_change'];
    passStatus = map['pass_status'];
    pinStatus = map['pin_status'];
    passLevel = map['pass_level'];
    itemId = map['item_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'title_change': titleChange,
      'username': username,
      'username_iv': usernameIV,
      'username_hash': usernameHash,
      'username_change': usernameChange,
      'password': password,
      'password_iv': passwordIV,
      'password_hash': passwordHash,
      'password_change': passwordChange,
      'pin': pin,
      'pin_iv': pinIV,
      'pin_hash': pinHash,
      'pin_change': pinChange,
      'ip': ip,
      'ip_iv': ipIV,
      'ip_hash': ipHash,
      'ip_change': ipChange,
      'long_text': longText,
      'long_text_iv': longTextIV,
      'long_text_hash': longTextHash,
      'long_text_change': longTextChange,
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

  OldAlpha cloneOld() {
    var old = OldAlpha(
      id: this.id,
      title: this.title,
      titleChange: this.titleChange,
      username: this.username,
      usernameIV: this.usernameIV,
      usernameHash: this.usernameHash,
      usernameChange: this.usernameChange,
      password: this.password,
      passwordIV: this.passwordIV,
      passwordHash: this.passwordHash,
      passwordChange: this.passwordChange,
      pin: this.pin,
      pinIV: this.pinIV,
      pinHash: this.pinHash,
      pinChange: this.pinChange,
      ip: this.ip,
      ipIV: this.ipIV,
      ipHash: this.ipHash,
      ipChange: this.ipChange,
      longText: this.longText,
      longTextIV: this.longTextIV,
      longTextHash: this.longTextHash,
      longTextChange: this.longTextChange,
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
    return old;
  }
}

class DeletedAlpha extends Alpha {
  int itemId;
  String deletedDate;

  DeletedAlpha({
    int id,
    String title,
    String username,
    String usernameIV,
    String usernameHash,
    String password,
    String passwordIV,
    String passwordHash,
    String pin,
    String pinIV,
    String pinHash,
    String ip,
    String ipIV,
    String ipHash,
    String longText,
    String longTextIV,
    String longTextHash,
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
  }) : super(
          id: id,
          title: title,
          username: username,
          usernameIV: usernameIV,
          usernameHash: usernameHash,
          password: password,
          passwordIV: passwordIV,
          passwordHash: passwordHash,
          pin: pin,
          pinIV: pinIV,
          pinHash: pinHash,
          ip: ip,
          ipIV: ipIV,
          ipHash: ipHash,
          longText: longText,
          longTextIV: longTextIV,
          longTextHash: longTextHash,
          date: date,
          shortDate: shortDate,
          color: color,
          colorLetter: colorLetter,
          passStatus: passStatus,
          pinStatus: pinStatus,
          passLevel: passLevel,
          expired: expired,
          expiredLapse: expiredLapse,
        );

  DeletedAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.usernameIV = a.usernameIV;
    this.usernameHash = a.usernameHash;
    this.password = a.password;
    this.passwordIV = a.passwordIV;
    this.passwordHash = a.passwordHash;
    this.pin = a.pin;
    this.pinIV = a.pinIV;
    this.pinHash = a.pinHash;
    this.ip = a.ip;
    this.ipIV = a.ipIV;
    this.ipHash = a.ipHash;
    this.longText = a.longText;
    this.longTextIV = a.longTextIV;
    this.longTextHash = a.longTextHash;
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
    usernameIV = map['username_iv'];
    usernameHash = map['username_hash'];
    password = map['password'];
    passwordIV = map['password_iv'];
    passwordHash = map['password_hash'];
    pin = map['pin'];
    pinIV = map['pin_iv'];
    pinHash = map['pin_hash'];
    ip = map['ip'];
    ipIV = map['ip_iv'];
    ipHash = map['ip_hash'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    longTextHash = map['long_text_hash'];
    passStatus = map['pass_status'];
    pinStatus = map['pin_status'];
    passLevel = map['pass_level'];
    deletedDate = map['date_deleted'];
    itemId = map['item_id'];
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
      'pin': pin,
      'pin_iv': pinIV,
      'pin_hash': pinHash,
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

class Username {
  String username, usernameIV, usernameHash;

  Username(this.username, this.usernameIV, {this.usernameHash});

  Username.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    usernameIV = map['username_iv'];
    usernameHash = map['username_hash'];
  }
}
