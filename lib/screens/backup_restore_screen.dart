import 'dart:io';
import 'package:flutter/material.dart';

import 'package:external_path/external_path.dart';
import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/widgets/loading_scaffold.dart';
import 'package:permission_handler/permission_handler.dart';

// import '../widgets/loading_scaffold.dart';

class BackupRestoreScreen extends StatefulWidget {
  static const routeName = '/backup-restore';

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  Future<List<Widget>> _getStorages;

  // Future<void> getPath_1() async {
  //   final _dbPath = await DBHelper.dbPath();
  //   final _localDB = File('$_dbPath/kw.db');
  //   var path = await ExternalPath.getExternalStorageDirectories();
  //   Directory(path[1] + '/keyway/backups').create().then((_dir) {
  //     _localDB.copySync('${_dir.path}/kw_baskup.db');
  //     List<FileSystemEntity> _list = _dir.listSync();
  //     _list.forEach((f) {
  //       print(f.path);
  //     });
  //   });
  // }

  Future<List<Widget>> _getStoragesAsync() async => await _options();

  Future<List<Widget>> _options() async {
    List<Widget> _cards = <Widget>[];
    // PermissionStatus _status = await Permission.manageExternalStorage.status;
    // if (_status.isDenied) {
    //   if (!(await Permission.manageExternalStorage.request().isGranted))
    //     return _cards;
    // }
    List<String> _paths = await ExternalPath.getExternalStorageDirectories();
    _paths.forEach((p) {
      _cards.add(
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 8,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(width: 3, color: Colors.grey),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[100],
                  Colors.grey[300],
                  Colors.grey[600],
                ],
              ),
            ),
            height: 128,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                p.split('/').last == '0'
                    ? Icon(Icons.phone_iphone, size: 48)
                    : Icon(Icons.sd_card, size: 48),
                Text(p),
              ],
            ),
          ),
        ),
      );
    });
    return _cards;
  }

  @override
  void initState() {
    _getStorages = _getStoragesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getStorages,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.active:
              return LoadingScaffold();
              break;
            case ConnectionState.done:
              if (snap.hasError)
                return Text(snap.error);
              else
                return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).backgroundColor,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Backup to',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ...snap.data
                      ],
                    ),
                  ),
                );
              break;
            default:
              return Text('default');
          }
        });
  }
}
