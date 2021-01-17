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

  bool _savePrevious(Alpha a) {
    if (this.title != a.title) return true;
    if (this.username != a.username) return true;
    if (this.password != a.password) return true;
    if (this.pin != a.pin) return true;
    if (this.ip != a.ip) return true;
    if (this.longText != a.longText) return true;
    return false;
  }

  OldAlpha saveOld(Alpha a) {
    if (_savePrevious(a)) {
      OldAlpha _old = OldAlpha.fromAlpha(this);
      if (this.title != a.title) _old.titleChange = 'changed';
      if (this.username != a.username) {
        if (a.username == '')
          _old.usernameChange = 'deleted';
        else if (this.username == '')
          _old.usernameChange = 'added';
        else
          _old.usernameChange = 'updated';
      } else
        _old.username = '';
      if (this.password != a.password) {
        if (a.password == '')
          _old.passwordChange = 'deleted';
        else if (this.password == '')
          _old.passwordChange = 'added';
        else
          _old.passwordChange = 'updated';
      } else
        _old.password = '';
      if (this.pin != a.pin) {
        if (a.pin == '')
          _old.pinChange = 'deleted';
        else if (this.pin == '')
          _old.pinChange = 'added';
        else
          _old.pinChange = 'updated';
      } else
        _old.pin = '';
      if (this.ip != a.ip) {
        if (a.ip == '')
          _old.ipChange = 'deleted';
        else if (this.ip == '')
          _old.ipChange = 'added';
        else
          _old.ipChange = 'updated';
      } else
        _old.ip = '';
      if (this.longText != a.longText) {
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
    this.usernameChange,
    String password,
    this.passwordChange,
    String pin,
    this.pinChange,
    String ip,
    this.ipChange,
    String longText,
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
          password: password,
          pin: pin,
          ip: ip,
          longText: longText,
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
    titleChange = map['title_change'];
    username = map['username'];
    usernameChange = map['username_change'];
    password = map['password'];
    passwordChange = map['password_change'];
    pin = map['pin'];
    pinChange = map['pin_change'];
    ip = map['ip'];
    ipChange = map['ip_change'];
    longText = map['long_text'];
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
      'username_change': usernameChange,
      'password': password,
      'password_change': passwordChange,
      'pin': pin,
      'pin_change': pinChange,
      'ip': ip,
      'ip_change': ipChange,
      'long_text': longText,
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
      usernameChange: this.usernameChange,
      password: this.password,
      passwordChange: this.passwordChange,
      pin: this.pin,
      pinChange: this.pinChange,
      ip: this.ip,
      ipChange: this.ipChange,
      longText: this.longText,
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
      'date_deleted': deletedDate,
      'item_id': itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
