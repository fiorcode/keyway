class Username {
  int usernameId;
  String usernameEnc;
  String usernameIv;

  Username({
    this.usernameId,
    this.usernameEnc = '',
    this.usernameIv = '',
  });

  Username.fromMap(Map<String, dynamic> map) {
    usernameId = map['username_id'];
    usernameEnc = map['username_enc'];
    usernameIv = map['username_iv'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'username_enc': usernameEnc,
      'username_iv': usernameIv,
    };
    if (usernameId != null) map['username_id'] = usernameId;
    return map;
  }
}
