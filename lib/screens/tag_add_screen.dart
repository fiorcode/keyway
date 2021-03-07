import 'package:flutter/material.dart';

import '../widgets/TextFields/tag_text_field.dart';

class TagAddScreen extends StatelessWidget {
  static const routeName = '/tag-add';

  TagAddScreen({this.tagsChips});

  final List<Widget> tagsChips;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: TagTextField(),
              ),
              Wrap(children: tagsChips),
            ],
          ),
        ),
      ),
    );
  }
}
