abstract class Item {
  int id;
  String title;
  String date;

  Item(this.id, this.title, this.date);
}

class AlphaItem extends Item {
  String username;
  String password;
  String pin;
  String ip;

  AlphaItem({
    int id,
    String title,
    this.username,
    this.password,
    this.pin,
    this.ip,
    String date,
  }) : super(id, title, date);
}
