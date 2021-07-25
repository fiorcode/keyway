import 'dart:io';
import 'package:flutter/material.dart';

import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

// import '../widgets/loading_scaffold.dart';

class BackupRestoreScreen extends StatefulWidget {
  static const routeName = '/backup-restore';

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  Future<void> getPath_1() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        var path = await ExternalPath.getExternalStorageDirectories();
        // print(path);
        Directory _dir = Directory(path[0]);
        List<FileSystemEntity> _list = _dir.listSync();
        _list.forEach((f) {
          print(f.path);
        });
        // _dir = Directory(path[1]);
        // _list = _dir.listSync();
        // _list.forEach((f) {
        //   print(f.path);
        // });
      }
    } else {
      var path = await ExternalPath.getExternalStorageDirectories();
      // print(path);
      Directory _dir = Directory('/storage/emulated/0/Download');
      List<FileSystemEntity> _list = _dir.listSync();
      _list.forEach((f) {
        print(f.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getPath_1();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
