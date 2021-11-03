class Username {
  int? usernameId;
  String? usernameEnc;
  String? usernameIv;
  String? usernameHash;

  String usernameDec = '';

  Username({
    this.usernameId,
    this.usernameEnc = '',
    this.usernameIv = '',
    this.usernameHash = '',
    this.usernameDec = '***clear***',
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
        usernameDec: this.usernameDec,
        usernameIv: this.usernameIv,
        usernameHash: this.usernameHash,
      );

  bool notEqual(Username? u) {
    if (u == null) return true;
    if (this.usernameHash != u.usernameHash) return true;
    if (this.usernameEnc != u.usernameEnc) return true;
    if (this.usernameIv != u.usernameIv) return true;
    return false;
  }

  void clearUsernameDec() => this.usernameDec = '***clear***';
}
