class Password {
  int passwordId;
  String passwordEnc;
  String passwordIv;
  String passwordDate;
  int passwordLapse;
  String passwordStatus;
  String strength;
  String hash;

  Password({
    this.passwordId,
    this.passwordEnc = '',
    this.passwordIv = '',
    this.passwordLapse = 320,
    this.passwordStatus = '',
    this.strength = '',
    this.hash = '',
  });

  Password.fromMap(Map<String, dynamic> map) {
    passwordId = map['password_id'];
    passwordEnc = map['password_enc'];
    passwordIv = map['password_iv'];
    passwordDate = map['password_date'];
    passwordLapse = map['password_lapse'];
    passwordStatus = map['password_status'];
    strength = map['strength'];
    hash = map['hash'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'password_enc': passwordEnc,
      'password_iv': passwordIv,
      'password_date': passwordDate,
      'password_lapse': passwordLapse,
      'password_status': passwordStatus,
      'strength': strength,
      'hash': hash,
    };
    if (passwordId != null) map['password_id'] = passwordId;
    return map;
  }
}
