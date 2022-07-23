import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:keyway/helpers/db_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageHelper {
  static Future<FileSystemEntity> deleteFile(File f) => f.delete();

  static Future<List<String>> _externalPaths() async =>
      await ExternalPath.getExternalStorageDirectories();

  static Future<String> sdCardPath() async {
    String _path = '';
    List<String> _paths = await _externalPaths();
    if (_paths.isNotEmpty) {
      _paths.forEach((path) {
        if (path.split('/').last.contains('-')) _path = path;
      });
    }
    return _path;
  }

  static Future<String> devicePath() async {
    String _path = '';
    List<String> _paths = await _externalPaths();
    if (_paths.isNotEmpty) {
      _paths.forEach((path) {
        if (path.contains('/emulated/')) _path = path;
      });
    }
    return _path;
  }

  static Future<bool> backupToDevice() async {
    checkPermission();
    String _path = await devicePath();
    if (_path.isNotEmpty) {
      return DBHelper.createBackup(_path);
    } else {
      return false;
    }
  }

  static Future<bool> backupToSdCard() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();
    String _path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    if (_path.isNotEmpty) {
      return await DBHelper.createBackup(_path, backupPath: false);
    } else {
      return false;
    }
  }

  static Future<File?> getDeviceBackup() async {
    checkPermission();
    String _path = await devicePath();
    if (_path.isEmpty) return null;
    _path = _path + '/keyway/backups/kw_backup.db';
    if (FileSystemEntity.typeSync(_path) != FileSystemEntityType.notFound) {
      return File(_path);
    }
    return null;
  }

  static Future<File?> getSdCardBackup() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) await Permission.manageExternalStorage.request();
    String _path = await sdCardPath();
    if (_path.isEmpty) return null;
    _path = _path + '/keyway/backups/kw_backup.db';
    if (FileSystemEntity.typeSync(_path) != FileSystemEntityType.notFound) {
      return File(_path);
    }
    return null;
  }

  static Future<File?> getDownloadFolderBackup() async {
    checkPermission();
    String _path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    if (_path.isEmpty) return null;
    _path = _path + '/kw_backup.db';
    if (FileSystemEntity.typeSync(_path) != FileSystemEntityType.notFound) {
      return File(_path);
    }
    return null;
  }

  static Future<void> checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) await Permission.storage.request();
  }
}
