import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/date_helper.dart';
import '../helpers/db_helper.dart';
import '../helpers/storage_helper.dart';
import '../screens/items_screen.dart';
import '../widgets/card/dashboard_card.dart';

class BackupRestoreScreen extends StatefulWidget {
  static const routeName = '/backup-restore';

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  Icon _icon;
  File _fileToRestore;
  FileStat _fileToRestoreStatus;

  bool _working = false;

  Future<bool> _checkPermissions() async {
    PermissionStatus _status = await Permission.manageExternalStorage.status;
    if (_status.isDenied) {
      if (!(await Permission.manageExternalStorage.request().isGranted))
        return false;
    }
    return true;
  }

  Future<void> _getDeviceBackup() async {
    await _checkPermissions();
    Color _primary = Theme.of(context).primaryColor;
    _icon = Icon(Icons.phone_iphone, color: _primary, size: 32);
    setState(() => _working = true);
    StorageHelper.getDeviceBackup().then((file) async {
      if (file != null) {
        _fileToRestore = file;
        _fileToRestoreStatus = await _fileToRestore.stat();
      }
      setState(() => _working = false);
    });
  }

  Future<void> _getSdBackup() async {
    await _checkPermissions();
    Color _primary = Theme.of(context).primaryColor;
    _icon = Icon(Icons.sd_card, color: _primary, size: 32);
    setState(() => _working = true);
    StorageHelper.getSdCardBackup().then((file) async {
      if (file != null) {
        _fileToRestore = file;
        _fileToRestoreStatus = await _fileToRestore.stat();
      }
      setState(() => _working = false);
    });
  }

  Future<void> _getDownloadsBackup() async {
    await _checkPermissions();
    Color _primary = Theme.of(context).primaryColor;
    _icon = Icon(Icons.download, color: _primary, size: 32);
    setState(() => _working = true);
    StorageHelper.getSdCardBackup().then((file) async {
      if (file != null) {
        _fileToRestore = file;
        _fileToRestoreStatus = await _fileToRestore.stat();
      }
      setState(() => _working = false);
    });
  }

  Future<void> _createBackup(String path) async {
    String _path = path + '/keyway/backups';
    DBHelper.createBackup(_path).then((_) {
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

  @override
  void initState() {
    _fileToRestore = null;
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
                          physics: NeverScrollableScrollPhysics(),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Image.asset('assets/error.png', height: 40),
                              Expanded(
                                child: Text(
                                  'Restore action will overwrite your actual database',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.1,
                          mainAxisSpacing: 8,
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          children: [
                            DashboardCard(
                              icon: Icon(Icons.system_update,
                                  color: _primary, size: 32),
                              title: Text(
                                'Device',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _getDeviceBackup,
                            ),
                            DashboardCard(
                              icon: Icon(Icons.sim_card_download,
                                  color: _primary, size: 32),
                              title: Text(
                                'SD Card',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _getSdBackup,
                            ),
                            DashboardCard(
                              icon: Icon(Icons.download,
                                  color: _primary, size: 32),
                              title: Text(
                                'Downloads',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _getDownloadsBackup,
                            ),
                          ],
                        ),
                        if (_fileToRestore != null)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _icon,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'File name: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(_fileToRestore.path.split('/').last),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Path: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(_fileToRestore.path)),
                                    ],
                                  ),
                                  if (_fileToRestoreStatus != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Last modified: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            DateHelper.shortDate(
                                                _fileToRestoreStatus.modified),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (_fileToRestoreStatus != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Size: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _fileToRestoreStatus.size
                                                    .toString() +
                                                ' Bytes',
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (_fileToRestore != null)
                                    Row(
                                      children: [
                                        Expanded(child: SizedBox()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        if (_fileToRestore != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed: () =>
                                  _restoreBackup(_fileToRestore.path),
                              child: Text(
                                'RESTORE',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
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
