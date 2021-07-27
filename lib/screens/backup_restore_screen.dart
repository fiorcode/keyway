import 'dart:io';
import 'package:flutter/material.dart';

import 'package:external_path/external_path.dart';
import 'package:keyway/helpers/db_helper.dart';
import 'package:permission_handler/permission_handler.dart';

// import '../widgets/loading_scaffold.dart';

class BackupRestoreScreen extends StatefulWidget {
  static const routeName = '/backup-restore';

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  Future<void> getPath_1() async {
    PermissionStatus status = await Permission.manageExternalStorage.status;
    if (status.isDenied) {
      if (!(await Permission.manageExternalStorage.request().isGranted)) return;
    }
    final _dbPath = await DBHelper.dbPath();
    final _localDB = File('$_dbPath/kw.db');
    var path = await ExternalPath.getExternalStorageDirectories();
    Directory(path[1] + '/keyway/backups').create().then((_dir) {
      _localDB.copySync('${_dir.path}/kw_baskup.db');
      List<FileSystemEntity> _list = _dir.listSync();
      _list.forEach((f) {
        print(f.path);
      });
    });
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
