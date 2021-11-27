import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keyway/helpers/date_helper.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:keyway/helpers/storage_helper.dart';
import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/widgets/card/dashboard_card.dart';
import 'package:provider/provider.dart';
import 'items_screen.dart';

class RestoreScreen extends StatefulWidget {
  static const routeName = '/restore';

  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  Icon? _icon;
  File? _fileToRestore;
  FileStat? _fileToRestoreStatus;
  bool _working = false;

  Future<bool> _checkPermissions() async {
    PermissionStatus _status = await Permission.manageExternalStorage.status;
    if (_status.isDenied) {
      PermissionStatus _ps = await Permission.manageExternalStorage
          .request()
          .onError((error, st) => ErrorHelper.errorDialog(context, error));
      if (!_ps.isGranted) return false;
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
        _fileToRestoreStatus = await _fileToRestore!.stat();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'FILE NOT FOUND',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }
      setState(() => _working = false);
    });
  }

  Future<void> _getSdBackup() async {
    await _checkPermissions();
    setState(() => _working = true);
    StorageHelper.getSdCardBackup().then((file) async {
      if (file != null) {
        Color _primary = Theme.of(context).primaryColor;
        _icon = Icon(Icons.sd_card, color: _primary, size: 32);
        _fileToRestore = file;
        _fileToRestoreStatus = await _fileToRestore!.stat();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'FILE NOT FOUND',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }
      setState(() => _working = false);
    });
  }

  Future<void> _getDownloadsBackup() async {
    await _checkPermissions();
    setState(() => _working = true);
    StorageHelper.getDownloadFolderBackup().then((file) async {
      if (file != null) {
        Color _primary = Theme.of(context).primaryColor;
        _icon = Icon(Icons.folder, color: _primary, size: 32);
        _fileToRestore = file;
        _fileToRestoreStatus = await _fileToRestore!.stat();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'FILE NOT FOUND',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 1),
          ),
        );
      }
      setState(() => _working = false);
    });
  }

  Future<void> _restoreBackup(String path) async {
    return DBHelper.restoreBackup(path).then(
      (_) async {
        await Provider.of<CriptoProvider>(context, listen: false)
            .setMasterKey();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ItemsListScreen()),
          ModalRoute.withName(SplashScreen.routeName),
        );
      },
    );
  }

  Future<void> _deleteBackup() async {
    setState(() => _working = true);
    StorageHelper.deleteFile(_fileToRestore!).then((fse) {
      setState(() {
        _fileToRestore = null;
        _fileToRestoreStatus = null;
        _working = false;
      });
    });
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
                    margin: const EdgeInsets.only(top: 16),
                    padding: EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    color: _primary,
                    child: Text(
                      'restore from',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _primary,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              icon:
                                  Icon(Icons.folder, color: _primary, size: 32),
                              title: Text(
                                'Download',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _getDownloadsBackup,
                            ),
                          ],
                        ),
                        if (_fileToRestore != null)
                          Card(
                            elevation: 8.0,
                            color: _back,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(width: 3, color: Colors.grey),
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
                                      Text(
                                          _fileToRestore!.path.split('/').last),
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
                                          child: Text(_fileToRestore!.path)),
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
                                            DateHelper.ddMMyyHm(
                                                _fileToRestoreStatus!.modified),
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
                                            _fileToRestoreStatus!.size
                                                    .toString() +
                                                ' Bytes',
                                          ),
                                        ),
                                      ],
                                    ),
                                  TextButton.icon(
                                    onPressed: _deleteBackup,
                                    icon: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      'DELETE FILE',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_fileToRestore != null)
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
                        if (_fileToRestore != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: _primary),
                              onPressed: () =>
                                  _restoreBackup(_fileToRestore!.path),
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
