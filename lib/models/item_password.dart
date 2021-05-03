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
    this.lapse = 320,
    this.status = '',
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
}
