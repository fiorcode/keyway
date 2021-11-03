class Password {
  int? passwordId;
  String? passwordEnc;
  String? passwordIv;
  String? passwordStrength;
  String? passwordHash;

  String passwordDec = '';

  Password({
    this.passwordId,
    this.passwordEnc = '',
    this.passwordIv = '',
    this.passwordStrength = '',
    this.passwordHash = '',
    this.passwordDec = '***clear***',
  });

  Password.fromMap(Map<String, dynamic> map) {
    passwordId = map['password_id'];
    passwordEnc = map['password_enc'];
    passwordIv = map['password_iv'];
    passwordStrength = map['password_strength'];
    passwordHash = map['password_hash'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'password_enc': passwordEnc,
      'password_iv': passwordIv,
      'password_strength': passwordStrength,
      'password_hash': passwordHash,
    };
    if (passwordId != null) map['password_id'] = passwordId;
    return map;
  }

  Password clone() => Password(
        passwordId: this.passwordId,
        passwordEnc: this.passwordEnc,
        passwordDec: this.passwordDec,
        passwordIv: this.passwordIv,
        passwordStrength: this.passwordStrength,
        passwordHash: this.passwordHash,
      );

  bool notEqual(Password? p) {
    if (p == null) return true;
    if (this.passwordHash != p.passwordHash) return true;
    if (this.passwordIv != p.passwordIv) return true;
    if (this.passwordEnc != p.passwordEnc) return true;
    return false;
  }

  void clearPasswordDec() => this.passwordDec = '***clear***';
}
