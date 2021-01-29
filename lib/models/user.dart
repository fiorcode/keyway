class User {
  int id;
  String name, surname;
  String encMK, mkIV;

  User({this.name, this.surname, this.encMK, this.mkIV});

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    surname = map['surname'];
    encMK = map['encrypted_mk'];
    mkIV = map['mk_iv'];
  }
}
