class OldPasswrodPin {
  int id;
  String passwordPin;
  String passwordPinIv;
  String passwordPinHash;
  String passwordPinDate;
  int passwordPinLapse;
  String passwordPinStatus;
  String passwordPinLevel;
  String passwordPinChange;
  String type;
  int itemId;

  OldPasswrodPin({
    this.id,
    this.itemId,
    this.passwordPin,
    this.passwordPinChange,
    this.passwordPinDate,
    this.passwordPinHash,
    this.passwordPinLapse,
    this.passwordPinLevel,
    this.passwordPinStatus,
    this.passwordPinIv,
    this.type,
  });

  OldPasswrodPin.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.passwordPin = map['password_pin'];
    this.passwordPinIv = map['password_pin_iv'];
    this.passwordPinHash = map['password_pin_hash'];
    this.passwordPinDate = map['password_pin_date'];
    this.passwordPinLapse = map['password_pin_lapse'];
    this.passwordPinStatus = map['password_pin_status'];
    this.passwordPinLevel = map['password_pin_level'];
    this.passwordPinChange = map['password_pin_change'];
    this.type = map['type'];
    this.itemId = map['item_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'password_pin': this.passwordPin,
      'password_pin_iv': this.passwordPinIv,
      'password_pin_hash': this.passwordPinHash,
      'password_pin_date': this.passwordPinDate,
      'password_pin_lapse': this.passwordPinLapse,
      'password_pin_status': this.passwordPinStatus,
      'password_pin_level': this.passwordPinLevel,
      'password_pin_change': this.passwordPinChange,
      'type': this.type,
      'item_id': this.itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
