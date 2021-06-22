import 'package:flutter/material.dart';

class DeviceAddScreen extends StatefulWidget {
  static const routeName = '/device';

  @override
  _DeviceAddScreenState createState() => _DeviceAddScreenState();
}

class _DeviceAddScreenState extends State<DeviceAddScreen> {
  final _trademarkCtrler = TextEditingController();
  final _modelCtrler = TextEditingController();
  final _versionCtrler = TextEditingController();

  final _trademarkFocusNode = FocusNode();
  final _modelFocusNode = FocusNode();
  final _versionFocusNode = FocusNode();

  bool _somethingToSave = false;

  void _save() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        actions: [
          if (_somethingToSave)
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _save,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _trademarkCtrler,
              focusNode: _trademarkFocusNode,
              decoration: InputDecoration(hintText: 'Trademark'),
            ),
            TextField(
              controller: _modelCtrler,
              focusNode: _modelFocusNode,
              decoration: InputDecoration(hintText: 'Model'),
            ),
            TextField(
              controller: _versionCtrler,
              focusNode: _versionFocusNode,
              decoration: InputDecoration(hintText: 'Version'),
            ),
          ],
        ),
      ),
    );
  }
}
