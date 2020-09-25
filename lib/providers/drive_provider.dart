import 'dart:io';

import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'package:http/io_client.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:googleapis/drive/v3.dart' as dAPI;
import 'package:google_sign_in/google_sign_in.dart';

class DriveProvider with ChangeNotifier {
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;
  dAPI.FileList _fileList;
  bool _fileFound = false;
  DateTime _modifiedDate;
  DateTime _lastCheck;

  int _fileCount;

  GoogleSignInAccount get currentUser => _currentUser;
  bool get fileFound => _fileFound;
  DateTime get modifiedDate => _modifiedDate;

  int get fileCount => _fileCount;

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      _currentUser = _googleSignIn.currentUser;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future handleSignOut() async {
    await _googleSignIn.disconnect();
    notifyListeners();
  }

  Future trySignInSilently() async {
    _googleSignIn = GoogleSignIn(scopes: [dAPI.DriveApi.DriveAppdataScope]);
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) => _currentUser = account);
    await _googleSignIn.signInSilently();
    _currentUser = _googleSignIn.currentUser;
    notifyListeners();
  }

  Future checkStatus() async {
    try {
      if (_lastCheck != null) {
        var secSinceLastCheck =
            _lastCheck.difference(DateTime.now()).inSeconds.abs();
        if (secSinceLastCheck < 3) return;
      }
      var client = GoogleHttpClient(await _currentUser.authHeaders);
      var drive = dAPI.DriveApi(client);
      _fileList = await drive.files.list(spaces: 'appDataFolder', $fields: '*');
      _fileCount = 0;
      _fileList.files.forEach((f) {
        _fileCount++;
        print('${f.name}: ${f.modifiedTime.toString()}');
        if (f.name == 'kw.db') {
          _fileFound = true;
          _modifiedDate = f.modifiedTime;
          _lastCheck = DateTime.now();
          notifyListeners();
        }
      });
    } catch (error) {
      throw error;
    }
  }

  Future<bool> downloadDB() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = dAPI.DriveApi(client);
    await drive.files.list(spaces: 'appDataFolder').then((value) {
      dAPI.FileList _fileList = value;
      _fileList.files.forEach((f) async {
        if (f.name == 'kw.db') {
          dAPI.Media file = await drive.files.get(
            f.id,
            downloadOptions: dAPI.DownloadOptions.FullMedia,
          );
          final dbPath = await sql.getDatabasesPath();
          final localFile = File('$dbPath/kw.db');
          List<int> dataStore = [];
          file.stream.listen((data) {
            dataStore.insertAll(dataStore.length, data);
          }, onDone: () {
            localFile.writeAsBytesSync(dataStore, flush: true);
            return true;
          }, onError: (error) {
            print("Some Error");
            return false;
          });
        }
      });
    });
    return false;
  }

  Future<void> uploadDB() async {
    try {
      dAPI.File _fileToUpload = dAPI.File();
      _fileToUpload.name = 'kw.db';
      _fileToUpload.parents = ["appDataFolder"];

      final _dbPath = await sql.getDatabasesPath();
      final _localFile = File('$_dbPath/kw.db');

      final _client = GoogleHttpClient(await _currentUser.authHeaders);
      final _drive = dAPI.DriveApi(_client);

      dAPI.FileList _fileList;
      _fileList = await _drive.files.list(
        spaces: 'appDataFolder',
        $fields: '*',
      );
      if (_fileList.files.length == 0) {
        await _drive.files.create(
          _fileToUpload,
          uploadMedia: dAPI.Media(
            _localFile.openRead(),
            _localFile.lengthSync(),
          ),
        );
      } else {
        _fileList.files.forEach(
          (f) async {
            if (f.name == 'kw.db') {
              dAPI.File _file = await _drive.files.update(
                dAPI.File(),
                f.id,
                uploadMedia: dAPI.Media(
                  _localFile.openRead(),
                  _localFile.lengthSync(),
                ),
              );
              _fileFound = true;
              _modifiedDate = _file.modifiedTime;
            }
          },
        );
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteDB() async {
    try {
      var client = GoogleHttpClient(await _currentUser.authHeaders);
      var drive = dAPI.DriveApi(client);
      drive.files.list(spaces: 'appDataFolder').then((value) {
        value.files.forEach((f) {
          if (f.name == 'kw.db') drive.files.delete(f.id);
        });
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
