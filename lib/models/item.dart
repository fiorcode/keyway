import 'package:flutter/material.dart';

abstract class Item {
  int id;
  String title;
  DateTime dateTime; // ???
  String date;
  String shortDate; //REMOVE
  int color = Colors.grey.value;
  int colorLetter = Colors.white.value;
  String tags;

  Item({
    this.id,
    this.title = '',
    this.date = '',
    this.shortDate = '',
    this.color,
    this.colorLetter,
    this.tags = '',
  });

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    shortDate = map['date_short'];
    color = map['color'];
    colorLetter = map['color_letter'];
    tags = map['tags'];
  }

  void addRemoveTag(String tag) {
    if (this.tags.contains('<$tag>')) {
      this.tags = this.tags.replaceAll('<$tag>', '');
    } else {
      this.tags += '<$tag>';
    }
  }
}
