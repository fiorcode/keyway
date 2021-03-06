import 'package:flutter/material.dart';

import 'package:keyway/models/tag.dart';

class TagAddScreen extends StatelessWidget {
  static const routeName = '/tag-add';

  TagAddScreen(this.tagsInDB);

  final List<Tag> tagsInDB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [TextField(), Wrap()],
        ),
      ),
    );
  }
}
