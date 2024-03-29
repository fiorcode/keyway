import 'package:flutter/foundation.dart';

import 'package:keyway/helpers/date_helper.dart';

class ItemPassword {
  int? fkItemId;
  int? fkPasswordId;
  String? passwordDate;
  int passwordLapse = 320;
  String passwordStatus = '<active>';

  ItemPassword({
    this.fkItemId,
    this.fkPasswordId,
    this.passwordDate,
    this.passwordLapse = 320,
    this.passwordStatus = '<active>',
  });

  bool get repeatWarning => !this.passwordStatus.contains('<no-warning>');
  bool get active => this.passwordStatus.contains('<active>');
  bool get repeated => this.passwordStatus.contains('<repeated>');
  bool get deleted => this.passwordStatus.contains('<deleted>');
  bool get old => this.passwordStatus.contains('<old>');
  bool get expired => this.passwordLapse == 0
      ? false
      : DateHelper.expired(passwordDate, passwordLapse);
  bool get customLapse =>
      this.passwordLapse != 0 &&
      this.passwordLapse != 96 &&
      this.passwordLapse != 320;
  bool get noLapse => this.passwordLapse == 0;

  void repeatWarningSwitch() {
    if (repeatWarning)
      this.passwordStatus = this.passwordStatus + '<no-warning>';
    else
      this.passwordStatus = this.passwordStatus.replaceAll('<no-warning>', '');
  }

  void setActive() {
    if (!active) {
      unSetDeleted();
      unSetOld();
      this.passwordStatus = this.passwordStatus + '<active>';
    }
  }

  void unSetActive() =>
      this.passwordStatus = this.passwordStatus.replaceAll('<active>', '');

  void setRepeated() {
    if (!repeated) this.passwordStatus = this.passwordStatus + '<repeated>';
  }

  void unSetRepeated() =>
      this.passwordStatus = this.passwordStatus.replaceAll('<repeated>', '');

  void setDeleted() {
    if (!deleted) {
      unSetActive();
      this.passwordStatus = this.passwordStatus + '<deleted>';
    }
  }

  void unSetDeleted() =>
      this.passwordStatus = this.passwordStatus.replaceAll('<deleted>', '');

  void setOld() {
    if (!old) {
      unSetActive();
      this.passwordStatus = this.passwordStatus + '<old>';
    }
  }

  void unSetOld() =>
      this.passwordStatus = this.passwordStatus.replaceAll('<old>', '');

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

  bool notEqual(ItemPassword? ip) {
    if (ip == null) return true;
    if (this.fkItemId != ip.fkItemId) return true;
    if (this.fkPasswordId != ip.fkPasswordId) return true;
    if (this.passwordDate != ip.passwordDate) return true;
    if (this.passwordLapse != ip.passwordLapse) return true;
    if (this.passwordStatus != ip.passwordStatus) return true;
    return false;
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
