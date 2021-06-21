class Username {
  int usernameId;
  String usernameEnc;
  String usernameIv;
  String usernameHash;

  Username({
    this.usernameId,
    this.usernameEnc = '',
    this.usernameIv = '',
    this.usernameHash = '',
  });

  Username.fromMap(Map<String, dynamic> map) {
    usernameId = map['username_id'];
    usernameEnc = map['username_enc'];
    usernameIv = map['username_iv'];
    usernameHash = map['username_hash'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'username_enc': usernameEnc,
      'username_iv': usernameIv,
      'username_hash': usernameHash,
    };
    if (usernameId != null) map['username_id'] = usernameId;
    return map;
  }

  Username clone() => Username(
        usernameId: this.usernameId,
        usernameEnc: this.usernameEnc,
        usernameIv: this.usernameIv,
        usernameHash: this.usernameHash,
      );
}
