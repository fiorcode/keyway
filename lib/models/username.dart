class Username {
  String username, usernameIV, usernameHash;

  Username(this.username, this.usernameIV, {this.usernameHash});

  Username.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    usernameIV = map['username_iv'];
    usernameHash = map['username_hash'];
  }
}
