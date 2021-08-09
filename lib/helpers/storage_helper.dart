import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:keyway/helpers/db_helper.dart';

import '../models/depot.dart';

class StorageHelper {
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
    String _path = await devicePath();
    if (_path.isNotEmpty) {
      return await DBHelper.createBackup(_path);
    } else {
      return false;
    }
  }

  static Future<bool> backupToSdCard() async {
    String _path = await sdCardPath();
    if (_path.isNotEmpty) {
      return await DBHelper.createBackup(_path);
    } else {
      return false;
    }
  }

  static Future<File> getDeviceBackup() async {
    String _path = await devicePath();
    if (_path.isEmpty) return null;
    _path = _path + '/keyway/backups/kw_backup.db';
    if (FileSystemEntity.typeSync(_path) != FileSystemEntityType.notFound) {
      return File(_path);
    }
    return null;
  }

  static Future<File> getSdCardBackup() async {
    String _path = await sdCardPath();
    if (_path.isEmpty) return null;
    _path = _path + '/keyway/backups/kw_backup.db';
    if (FileSystemEntity.typeSync(_path) != FileSystemEntityType.notFound) {
      return File(_path);
    }
    return null;
  }

  static Future<List<Depot>> getBackupDepots() async {
    List<String> _paths = await _externalPaths();
    List<Depot> _depots = <Depot>[];
    if (_paths.isNotEmpty) {
      _paths.forEach((path) {
        _depots.add(Depot.factory(path));
        print(path);
      });
    }
    return _depots;
  }

  static Future<List<Depot>> getRestoreDepots() async {
    List<String> _paths = await _externalPaths();
    List<Depot> _depots = <Depot>[];
    if (_paths.isNotEmpty) {
      _paths.forEach((path) {
        String _path = path + '/keyway/backups/kw_backup.db';
        if (FileSystemEntity.typeSync(_path) != FileSystemEntityType.notFound) {
          _depots.add(Depot.factory(_path));
        }
      });
    }
    return _depots;
  }
}
