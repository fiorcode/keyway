class Password {
  int passwordId;
  String passwordEnc;
  String passwordIv;
  String strength;
  String hash;

  Password({
    this.passwordId,
    this.passwordEnc = '',
    this.passwordIv = '',
    this.strength = '',
    this.hash = '',
  });

  Password.fromMap(Map<String, dynamic> map) {
    passwordId = map['password_id'];
    passwordEnc = map['password_enc'];
    passwordIv = map['password_iv'];
    strength = map['strength'];
    hash = map['hash'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'password_enc': passwordEnc,
      'password_iv': passwordIv,
      'strength': strength,
      'hash': hash,
    };
    if (passwordId != null) map['password_id'] = passwordId;
    return map;
  }

  Password clone() => Password(
        passwordId: this.passwordId,
        passwordEnc: this.passwordEnc,
        passwordIv: this.passwordIv,
        strength: this.strength,
        hash: this.hash,
      );
}
