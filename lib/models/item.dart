abstract class Item {
  int id;
  String type;
  String title;
  String date;
  String globalId;

  Item(this.id, this.type, this.title, this.date);
}

class AlphaItem extends Item {
  String username;
  String password;
  String pin;
  String ip;
  String note;

  AlphaItem({
    int id,
    String type,
    String title,
    this.username,
    this.password,
    this.pin,
    this.ip,
    this.note,
    String date,
  }) : super(id, type, title, date);
}
