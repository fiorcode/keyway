import 'dart:io';

import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'package:http/io_client.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:googleapis/drive/v3.dart' as api;
import 'package:google_sign_in/google_sign_in.dart';

class DriveProvider with ChangeNotifier {
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;
  api.FileList _fileList;
  bool _fileFound = false;
  DateTime _modifiedDate;
  DateTime _lastCheck;

  GoogleSignInAccount get currentUser => _currentUser;
  bool get fileFound => _fileFound;
  DateTime get modifiedDate => _modifiedDate;

  // int get fileCount => _fileList.files.length;

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
    _googleSignIn = GoogleSignIn(scopes: [api.DriveApi.DriveAppdataScope]);
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) => _currentUser = account);
    await _googleSignIn.signInSilently();
    _currentUser = _googleSignIn.currentUser;
    notifyListeners();
  }

  Future<api.DriveApi> _getApi() async {
    Map<String, String> _headers = await _currentUser.authHeaders;
    return api.DriveApi(GoogleHttpClient(_headers));
  }

  Future<api.FileList> _getFileList() async {
    api.DriveApi drive = await _getApi();
    return drive.files.list(spaces: 'appDataFolder', $fields: '*');
  }

  Future<api.File> _getDB() async {
    api.File _db;
    _fileList = await _getFileList();
    _fileList.files.forEach((f) async {
      if (f.name == 'kw.db') _db = f;
    });
    return _db;
  }

  Future checkStatus() async {
    try {
      if (_lastCheck != null) {
        var secSinceLastCheck =
            _lastCheck.difference(DateTime.now()).inSeconds.abs();
        if (secSinceLastCheck < 15) return;
      }
      api.File _db = await _getDB();
      if (_db != null) {
        _fileFound = true;
        _modifiedDate = _db.modifiedTime.toLocal();
        _lastCheck = DateTime.now().toLocal();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future downloadDB() async {
    try {
      api.File _db = await _getDB();
      if (_db != null) {
        api.DriveApi drive = await _getApi();
        api.Media _file = await drive.files.get(
          _db.id,
          downloadOptions: api.DownloadOptions.FullMedia,
        );
        final dbPath = await sql.getDatabasesPath();
        final localFile = File('$dbPath/kw.db');
        List<int> dataStore = [];
        _file.stream.listen(
          (data) => dataStore.insertAll(dataStore.length, data),
          onDone: () => localFile.writeAsBytesSync(dataStore, flush: true),
          onError: (error) => throw error,
        );
      }
    } catch (error) {
      throw error;
    }
  }

  Future uploadDB() async {
    try {
      final _dbPath = await sql.getDatabasesPath();
      final _localDB = File('$_dbPath/kw.db');

      api.File _db = await _getDB();

      api.File _fileToUpload = api.File();
      api.Media _media = api.Media(_localDB.openRead(), _localDB.lengthSync());

      api.DriveApi _drive = await _getApi();

      if (_db == null) {
        _fileToUpload.name = 'kw.db';
        _fileToUpload.parents = ["appDataFolder"];
        await _drive.files.create(_fileToUpload, uploadMedia: _media);
      } else {
        await _drive.files.update(_fileToUpload, _db.id, uploadMedia: _media);
      }
      _db = await _getDB();
      _fileFound = _db != null;
      _modifiedDate = _db.modifiedTime.toLocal();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future deleteDB() async {
    try {
      api.File _db = await _getDB();
      api.DriveApi drive = await _getApi();
      if (_db != null) await drive.files.delete(_db.id);
      _db = await _getDB();
      if (_db == null) {
        _fileFound = false;
        _lastCheck = DateTime.now();
      }
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
