class ItemPassword {
  int fkItemId;
  int fkPasswordId;
  String passwordDate;
  int passwordLapse;
  String passwordStatus;
  DateTime dateTime;

  ItemPassword({
    this.fkItemId,
    this.fkPasswordId,
    this.passwordDate,
    this.passwordLapse = 320,
    this.passwordStatus = '<active>',
    this.dateTime,
  });

  bool get repeatWarning => !this.passwordStatus.contains('<no-warning>');
  bool get repeated => !this.passwordStatus.contains('<repeated>');

  ItemPassword.fromMap(Map<String, dynamic> map) {
    fkItemId = map['fk_item_id'];
    fkPasswordId = map['fk_password_id'];
    passwordDate = map['password_date'];
    passwordLapse = map['password_lapse'];
    passwordStatus = map['password_status'];
    dateTime = DateTime.parse(map['password_date']);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fk_item_id': fkItemId,
        'fk_password_id': fkPasswordId,
        'password_date': passwordDate,
        'password_lapse': passwordLapse,
        'password_status': passwordStatus,
      };

  void repeatWarningSwitch() {
    if (repeatWarning)
      this.passwordStatus += '<no-warning>';
    else
      this.passwordStatus = this.passwordStatus.replaceAll('<no-warning>', '');
  }

  void setRepeat() {
    if (repeated)
      return;
    else
      this.passwordStatus += '<repeated>';
  }

  ItemPassword clone() {
    ItemPassword _ip = ItemPassword(
      fkItemId: this.fkItemId,
      fkPasswordId: this.fkPasswordId,
      passwordDate: this.passwordDate,
      passwordLapse: this.passwordLapse,
      passwordStatus: this.passwordStatus,
      dateTime: this.dateTime,
    );
    return _ip;
  }
}
