import 'package:flutter/material.dart';

abstract class Item {
  int id;
  String title;
  String date;

  Item(this.id, this.title, this.date);

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
  }
}

class AlphaItem extends Item {
  String username;
  String password;
  String pin;
  String ip;
  int color = Colors.grey.value;

  AlphaItem({
    int id,
    String title,
    this.username,
    this.password,
    this.pin,
    this.ip,
    this.color,
    String date,
  }) : super(id, title, date);

  AlphaItem.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    username = map['username'];
    password = map['password'];
    pin = map['pin'];
    ip = map['ip'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'username': username,
      'password': password,
      'pin': pin,
      'ip': ip,
      'date': DateTime.now().toUtc().toIso8601String(),
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
