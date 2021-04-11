import 'package:flutter/material.dart';

abstract class Item {
  int id;
  String title;
  String date;
  int color = Colors.grey.value;
  int colorLetter = Colors.white.value;
  String font;
  String tags;

  Item({
    this.id,
    this.title = '',
    this.date = '',
    this.color,
    this.colorLetter,
    this.font = '',
    this.tags = '',
  });

  Item.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    date = map['date'];
    color = map['color'];
    colorLetter = map['color_letter'];
    font = map['font'];
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
