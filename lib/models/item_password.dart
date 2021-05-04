class ItemPassword {
  int fkItemId;
  int fkPasswordId;
  String date;
  int lapse;
  String status;
  DateTime dateTime;

  ItemPassword({
    this.fkItemId,
    this.fkPasswordId,
    this.date,
    this.lapse = 320,
    this.status = '',
    this.dateTime,
  });

  ItemPassword.fromMap(Map<String, dynamic> map) {
    fkItemId = map['fk_item_id'];
    fkPasswordId = map['fk_password_id'];
    date = map['date'];
    lapse = map['lapse'];
    status = map['status'];
    dateTime = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fk_item_id': fkItemId,
        'fk_password_id': fkPasswordId,
        'date': date,
        'lapse': lapse,
        'status': status,
      };

  ItemPassword clone() => ItemPassword(
        fkItemId: this.fkItemId,
        fkPasswordId: this.fkPasswordId,
        date: this.date,
        lapse: this.lapse,
        status: this.status,
        dateTime: this.dateTime,
      );
}
