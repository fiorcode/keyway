import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/db_helper.dart';
import '../helpers/storage_helper.dart';
import '../models/depot.dart';
import '../screens/items_screen.dart';
import '../widgets/card/dashboard_card.dart';

class BackupRestoreScreen extends StatefulWidget {
  static const routeName = '/backup-restore';

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  Future<List<Depot>> _getBackupDepots;
  Future<List<Depot>> _getRestoreDepots;
  List<Depot> _backupDepots;
  List<Depot> _restoreDepots;
  File _devBackup;
  bool _working = false;

  Future<bool> _checkPermissions() async {
    PermissionStatus _status = await Permission.manageExternalStorage.status;
    if (_status.isDenied) {
      if (!(await Permission.manageExternalStorage.request().isGranted))
        return false;
    }
    return true;
  }

  Future<List<Depot>> _getBackupDepotsAsync() async {
    if (await _checkPermissions()) {
      return await StorageHelper.getBackupDepots();
    }
    return <Depot>[];
  }

  Future<List<Depot>> _getRestoreDepotsAsync() async {
    if (await _checkPermissions()) {
      return await StorageHelper.getRestoreDepots();
    }
    return <Depot>[];
  }

  Future<void> _searchDeviceBackup() async {
    if (_devBackup != null) {
      setState(() => _devBackup = null);
      return;
    }
    setState(() => _working = true);
    StorageHelper.getDeviceBackup().then((file) {
      _devBackup = file;
      setState(() => _working = false);
    });
  }

  Future<void> _createBackup(String path) async {
    String _path = path + '/keyway/backups';
    DBHelper.createBackup(_path).then((_) {
      _getRestoreDepots = _getRestoreDepotsAsync();
      setState(() {});
    });
  }

  Future<void> _restoreBackup(String path) async {
    return DBHelper.restoreBackup(path).then(
      (_) => Navigator.popUntil(
        context,
        ModalRoute.withName(ItemsListScreen.routeName),
      ),
    );
  }

  void _goTo(BuildContext context, String route) =>
      Navigator.of(context).pushNamed(route);

  @override
  void initState() {
    _getBackupDepots = _getBackupDepotsAsync();
    _getRestoreDepots = _getRestoreDepotsAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color _primary = Theme.of(context).primaryColor;
    Color _back = Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: _back,
      appBar: AppBar(
        backgroundColor: _back,
        iconTheme: IconThemeData(color: _primary),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_working) LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    color: Colors.grey,
                    child: Text(
                      'backup to',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.1,
                          mainAxisSpacing: 8,
                          padding: EdgeInsets.all(16.0),
                          children: [
                            DashboardCard(
                              icon: Icon(Icons.phone_iphone,
                                  color: _primary, size: 32),
                              title: Text(
                                'Device',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              // goTo: () => _goTo(context, DataScreen.routeName),
                            ),
                            DashboardCard(
                              icon: Icon(Icons.sd_card,
                                  color: _primary, size: 32),
                              title: Text(
                                'SD Card',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              // goTo: () => _goTo(context, BackupRestoreScreen.routeName),
                            ),
                            DashboardCard(
                              icon:
                                  Icon(Icons.email, color: _primary, size: 32),
                              title: Text(
                                'E-Mail',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              // goTo: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    color: Colors.red,
                    child: Text(
                      'restore from',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.1,
                          mainAxisSpacing: 8,
                          padding: EdgeInsets.all(16.0),
                          children: [
                            DashboardCard(
                              icon: Icon(Icons.phone_iphone,
                                  color: _primary, size: 32),
                              title: Text(
                                'Device',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _searchDeviceBackup,
                            ),
                            DashboardCard(
                              icon: Icon(Icons.sd_card,
                                  color: _primary, size: 32),
                              title: Text(
                                'SD Card',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              // goTo: () => _goTo(context, BackupRestoreScreen.routeName),
                            ),
                          ],
                        ),
                        if (_devBackup != null)
                          Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_iphone,
                                  color: _primary,
                                  size: 24,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'File name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(_devBackup.path.split('/').last),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Path: '),
                                          Expanded(
                                              child: Text(_devBackup.path)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          child: Row(
                            children: [
                              Image.asset('assets/error.png', height: 40),
                              Expanded(
                                child: Text(
                                  'Any of this actions will overwrite your actual database',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
