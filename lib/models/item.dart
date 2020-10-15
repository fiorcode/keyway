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

class AlphaItem extends Item {
  String username;
  String password;
  String pin;
  String ip;

  AlphaItem(
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

  AlphaItem.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
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
