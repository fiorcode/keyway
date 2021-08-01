import 'package:flutter/material.dart';

class Depot {
  String path;
  String title;
  Icon icon;

  Depot.factory(this.path) {
    this.path = path;
    _assemble();
  }

  Depot({this.path, this.title, this.icon});

  void _assemble() {
    if (path != null) {
      if (path.contains('/emulated')) {
        this.title = 'Device';
        this.icon = Icon(Icons.phone_iphone, size: 48);
      } else {
        this.title = 'SD Card';
        this.icon = Icon(Icons.sd_card, size: 48);
      }
    } else {
      this.title = '';
      this.icon = Icon(Icons.help, size: 48);
    }
  }
}
