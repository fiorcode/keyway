abstract class Item {
  int id;
  String title;
  DateTime dateTime; // ???
  String date;
  String shortDate; //REMOVE
  int color;
  int colorLetter;
  String tags;

  Item(
    this.id,
    this.title,
    this.date,
    this.shortDate,
    this.color,
    this.colorLetter,
    this.tags,
  );

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    shortDate = map['date_short'];
    color = map['color'];
    colorLetter = map['color_letter'];
    tags = map['tags'];
  }
}

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
    String passwordDate,
    String passwordLapse,
    String passwordStatus,
    String passwordLevel,
    this.passwordChange,
    String pin,
    String pinIV,
    String pinHash,
    String pinDate,
    String pinLapse,
    String pinStatus,
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
    String tags,
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
          ipHash: ipHash,
          longText: longText,
          longTextIV: longTextIV,
          longTextHash: longTextHash,
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
    this.usernameHash = a.usernameHash;
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
    this.ipHash = a.ipHash;
    this.longText = a.longText;
    this.longTextIV = a.longTextIV;
    this.longTextHash = a.longTextHash;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.color = a.color;
    this.colorLetter = a.colorLetter;
    this.tags = a.tags;
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
    ipHash = map['ip_hash'];
    ipChange = map['ip_change'];
    longText = map['long_text'];
    longTextIV = map['long_text_iv'];
    longTextHash = map['long_text_hash'];
    longTextChange = map['long_text_change'];
    tags = map['tags'];
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
      titleChange: this.titleChange,
      username: this.username,
      usernameIV: this.usernameIV,
      usernameHash: this.usernameHash,
      usernameChange: this.usernameChange,
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
      tags: this.tags,
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
    String passwordDate,
    String passwordLapse,
    String passwordStatus,
    String passwordLevel,
    String pin,
    String pinIV,
    String pinHash,
    String pinDate,
    String pinLapse,
    String pinStatus,
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
    String tags,
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
          ipHash: ipHash,
          longText: longText,
          longTextIV: longTextIV,
          longTextHash: longTextHash,
          date: date,
          shortDate: shortDate,
          color: color,
          colorLetter: colorLetter,
          tags: tags,
        );

  DeletedAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.usernameIV = a.usernameIV;
    this.usernameHash = a.usernameHash;
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
    this.ipHash = a.ipHash;
    this.longText = a.longText;
    this.longTextIV = a.longTextIV;
    this.longTextHash = a.longTextHash;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.deletedDate = DateTime.now().toUtc().toIso8601String();
    this.color = a.color;
    this.colorLetter = a.colorLetter;
    this.tags = a.tags;
    this.itemId = a.id;
  }

  DeletedAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
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
    tags = map['tags'];
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

class Tag {
  int id;
  String tagName;

  Tag(this.tagName);

  Tag.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    tagName = map['tag_name'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'tag_name': tagName,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
