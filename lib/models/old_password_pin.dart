class OldPasswrodPin {
  int id;
  String passwordPin;
  String passwordPinIv;
  String passwordPinHash;
  String passwordPinDate;
  String passwordPinLevel;
  String type;
  int itemId;

  OldPasswrodPin({
    this.id,
    this.passwordPin,
    this.passwordPinIv,
    this.passwordPinHash,
    this.passwordPinDate,
    this.passwordPinLevel,
    this.type,
    this.itemId,
  });

  OldPasswrodPin.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.passwordPin = map['password_pin'];
    this.passwordPinIv = map['password_pin_iv'];
    this.passwordPinHash = map['password_pin_hash'];
    this.passwordPinDate = map['password_pin_date'];
    this.passwordPinLevel = map['password_pin_level'];
    this.type = map['type'];
    this.itemId = map['item_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'password_pin': this.passwordPin,
      'password_pin_iv': this.passwordPinIv,
      'password_pin_hash': this.passwordPinHash,
      'password_pin_date': this.passwordPinDate,
      'password_pin_level': this.passwordPinLevel,
      'type': this.type,
      'item_id': this.itemId,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
