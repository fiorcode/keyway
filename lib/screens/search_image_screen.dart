import 'package:flutter/material.dart';

class SearchImageScreen extends StatefulWidget {
  static const routeName = '/search-image';

  @override
  _SearchImageScreenState createState() => _SearchImageScreenState();
}

class _SearchImageScreenState extends State<SearchImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: TextField(),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Container(),
    );
  }
}
