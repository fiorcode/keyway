abstract class Item {
  int id;
  String title;
  DateTime dateTime; // ???
  String date;
  String shortDate; //REMOVE
  int color;
  int colorLetter;
  String tags;

  Item({
    this.id,
    this.title = '',
    this.date = '',
    this.shortDate = '',
    this.color,
    this.colorLetter,
    this.tags = '',
  });

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
