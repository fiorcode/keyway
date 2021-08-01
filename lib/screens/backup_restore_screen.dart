import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../helpers/storage_helper.dart';
import '../models/depot.dart';
import '../widgets/loading_scaffold.dart';

class BackupRestoreScreen extends StatefulWidget {
  static const routeName = '/backup-restore';

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  Future<List<Depot>> _getDepots;
  List<Depot> _depots;

  // PermissionStatus _status = await Permission.manageExternalStorage.status;
  // if (_status.isDenied) {
  //   if (!(await Permission.manageExternalStorage.request().isGranted))
  //     return _cards;
  // }

  Future<List<Depot>> _getDepotsAsync() async =>
      await StorageHelper.getDepots();

  @override
  void initState() {
    _getDepots = _getDepotsAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDepots,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.active:
              return LoadingScaffold();
              break;
            case ConnectionState.done:
              if (snap.hasError)
                return Text(snap.error);
              else {
                _depots = snap.data;
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
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _depots.length,
                            itemBuilder: (ctx, i) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 8,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  side:
                                      BorderSide(width: 3, color: Colors.grey),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _depots[i].icon,
                                      Text(_depots[i].title),
                                      Text(_depots[i].path),
                                      Text(_depots.length.toString()),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                );
              }
              break;
            default:
              return Text('default');
          }
        });
  }
}
