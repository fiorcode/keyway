abstract class Item {
  int id;
  String title;
  DateTime dateTime;
  String date;
  String shortDate;
  int color;
  String repeated;
  String expired;

  Item(
    this.id,
    this.title,
    this.date,
    this.shortDate,
    this.color,
    this.repeated,
    this.expired,
  );

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    shortDate = map['date_short'];
    color = map['color'];
    repeated = map['repeated'];
    expired = map['expired'];
  }
}

class Alpha extends Item {
  String username;
  String password;
  String pin;
  String ip;

  Alpha(
      {int id,
      String title,
      this.username,
      this.password,
      this.pin,
      this.ip,
      String date,
      String shortDate,
      int color = 0,
      String repeated = 'n',
      String expired = 'n'})
      : super(id, title, date, shortDate, color, repeated, expired);

  Alpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'date': date,
      'date_short': shortDate,
      'color': color,
      'repeated': repeated,
      'expired': expired,
    };
    if (id != null) map['id'] = id;
    return map;
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
    String date,
    String shortDate,
    int color = 0,
    String repeated = 'n',
    String expired = 'n',
    this.itemId,
  }) : super();

  OldAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.password = a.password;
    this.pin = a.pin;
    this.ip = a.pin;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.color = a.color;
    this.repeated = a.repeated;
    this.expired = a.expired;
    this.itemId = a.id;
  }

  OldAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
    itemId = map['item_id'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'date': date,
      'date_short': shortDate,
      'color': color,
      'repeated': repeated,
      'expired': expired,
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
    String date,
    String shortDate,
    this.deletedDate,
    int color = 0,
    String repeated = 'n',
    String expired = 'n',
    this.itemId,
  }) : super();

  DeletedAlpha.fromAlpha(Alpha a) {
    this.title = a.title;
    this.username = a.username;
    this.password = a.password;
    this.pin = a.pin;
    this.ip = a.pin;
    this.date = a.date;
    this.shortDate = a.shortDate;
    this.deletedDate = DateTime.now().toIso8601String();
    this.color = a.color;
    this.repeated = a.repeated;
    this.expired = a.expired;
    this.itemId = a.id;
  }

  DeletedAlpha.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
    itemId = map['item_id'];
    deletedDate = map['date_deleted'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'date': date,
      'date_short': shortDate,
      'date_deleted': deletedDate,
      'color': color,
      'repeated': repeated,
      'expired': expired,
      'item_id': itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
