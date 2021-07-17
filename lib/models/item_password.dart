import 'package:flutter/foundation.dart';

class ItemPassword {
  int fkItemId;
  int fkPasswordId;
  String passwordDate;
  int passwordLapse;
  String passwordStatus;

  ItemPassword({
    this.fkItemId,
    this.fkPasswordId,
    this.passwordDate,
    this.passwordLapse = 320,
    this.passwordStatus = '<active>',
  });

  bool get repeatWarning => !this.passwordStatus.contains('<no-warning>');
  bool get repeated => !this.passwordStatus.contains('<repeated>');

  ItemPassword.fromMap(Map<String, dynamic> map) {
    fkItemId = map['fk_item_id'];
    fkPasswordId = map['fk_password_id'];
    passwordDate = map['password_date'];
    passwordLapse = map['password_lapse'];
    passwordStatus = map['password_status'];
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
    );
    return _ip;
  }

  bool equal(ItemPassword ip) {
    if (this.fkItemId != ip.fkItemId) return false;
    if (this.fkPasswordId != ip.fkPasswordId) return false;
    if (this.passwordDate != ip.passwordDate) return false;
    if (this.passwordLapse != ip.passwordLapse) return false;
    if (!_equalStatus(ip.passwordStatus)) return false;
    return true;
  }

  bool _equalStatus(String ps) {
    List<String> _s1 = ps.split("<");
    List<String> _s2 = this.passwordStatus.split("<");
    _s1.sort();
    _s2.sort();
    return listEquals(_s1, _s2);
  }
}
