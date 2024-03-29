import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/error_helper.dart';
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
  Icon? _icon;
  File? _fileToRestore;
  FileStat? _fileToRestoreStatus;
  bool _working = false;

  Future<bool> _externalStoragePermission() async {
    PermissionStatus _status = await Permission.manageExternalStorage.status
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    if (_status.isDenied) {
      PermissionStatus _ps = await Permission.manageExternalStorage
          .request()
          .onError((error, st) => _onError(error));
      if (!(_ps.isGranted)) return false;
    }
    return true;
  }

  Future<bool> _storagePermission() async {
    PermissionStatus _status = await Permission.storage.status
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    if (_status.isDenied) {
      PermissionStatus _ps = await Permission.storage
          .request()
          .onError((error, st) => _onError(error));
      if (!(_ps.isGranted)) return false;
    }
    return true;
  }

  Future<void> _backupToDevice() async {
    await _storagePermission();
    StorageHelper.backupToDevice().then((succeed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: succeed ? Colors.green : Colors.red,
          content: Text(
            succeed ? 'DONE!' : 'SOMETHING WENT WRONG',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }).onError((error, st) => _onError(error));
  }

  Future<void> _backupToSdCard() async {
    StorageHelper.backupToSdCard().then((succeed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: succeed ? Colors.green : Colors.red,
          content: Text(
            succeed ? 'DONE!' : 'SOMETHING WENT WRONG \n\n no SD card?',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 1),
        ),
      );
    }).onError((error, st) => _onError(error));
  }

  Future<void> _backupToMail() async {
    await _storagePermission();
    StorageHelper.backupToDevice().then((succeed) {
      if (succeed) {
        StorageHelper.getDeviceBackup().then((file) async {
          if (file != null) {
            final Email _email = Email(
              body: 'Keyway Backup',
              subject: 'Keyway Backup',
              recipients: ['lperezfiorentino@vialidad.gob.ar'],
              attachmentPaths: [file.path],
              isHTML: false,
            );
            await FlutterEmailSender.send(_email)
                .onError((error, st) => _onError(error));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text('Email sent!', textAlign: TextAlign.center),
                duration: Duration(seconds: 1),
              ),
            );
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
        }).onError((error, st) => _onError(error));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('SOMETHING WENT WRONG', textAlign: TextAlign.center),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });
  }

  Future<void> _getDeviceBackup() async {
    await _storagePermission().onError((error, st) => _onError(error));
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
    }).onError((error, st) => _onError(error));
  }

  Future<void> _getSdBackup() async {
    await _externalStoragePermission().onError((error, st) => _onError(error));
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
    }).onError((error, st) => _onError(error));
  }

  Future<void> _getDownloadsBackup() async {
    await _externalStoragePermission().onError((error, st) => _onError(error));
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
    }).onError((error, st) => _onError(error));
  }

  Future<void> _restoreBackup(String path) async {
    return DBHelper.restoreBackup(path)
        .then(
          (_) => Navigator.popUntil(
            context,
            ModalRoute.withName(ItemsListScreen.routeName),
          ),
        )
        .onError((error, st) => _onError(error));
  }

  Future<void> _deleteBackup() async {
    setState(() => _working = true);
    StorageHelper.deleteFile(_fileToRestore!).then((fse) {
      setState(() {
        _fileToRestore = null;
        _fileToRestoreStatus = null;
        _working = false;
      });
    }).onError((error, st) => ErrorHelper.errorDialog(context, error));
  }

  dynamic _onError(Object? error) {
    setState(() => _working = false);
    return ErrorHelper.errorDialog(context, error);
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
                              onTap: () => _backupToDevice(),
                            ),
                            DashboardCard(
                              icon: Icon(Icons.sd_card,
                                  color: _primary, size: 32),
                              title: Text(
                                'SD Card',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _backupToSdCard,
                            ),
                            DashboardCard(
                              icon:
                                  Icon(Icons.email, color: _primary, size: 32),
                              title: Text(
                                'E-Mail',
                                style: TextStyle(color: _primary, fontSize: 12),
                              ),
                              onTap: _backupToMail,
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
