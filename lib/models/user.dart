class User {
  String encMk, mkIv;

  User({this.encMk, this.mkIv});

  User.fromMap(Map<String, dynamic> map) {
    encMk = map['mk_enc'];
    mkIv = map['mk_iv'];
  }
}
