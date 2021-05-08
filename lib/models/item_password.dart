class ItemPassword {
  int fkItemId;
  int fkPasswordId;
  String date;
  int lapse;
  String passwordStatus;
  DateTime dateTime;

  ItemPassword({
    this.fkItemId,
    this.fkPasswordId,
    this.date,
    this.lapse = 320,
    this.passwordStatus = '',
    this.dateTime,
  }) {
    this.dateTime = DateTime.now(); //FIX THIS
  }

  ItemPassword.fromMap(Map<String, dynamic> map) {
    fkItemId = map['fk_item_id'];
    fkPasswordId = map['fk_password_id'];
    date = map['date'];
    lapse = map['lapse'];
    passwordStatus = map['password_status'];
    dateTime = DateTime.parse(map['date']);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fk_item_id': fkItemId,
        'fk_password_id': fkPasswordId,
        'date': date,
        'lapse': lapse,
        'password_status': passwordStatus,
      };

  ItemPassword clone() {
    ItemPassword _ip = ItemPassword(
      fkItemId: this.fkItemId,
      fkPasswordId: this.fkPasswordId,
      date: this.date,
      lapse: this.lapse,
      passwordStatus: this.passwordStatus,
      dateTime: this.dateTime,
    );
    return _ip;
  }
}
