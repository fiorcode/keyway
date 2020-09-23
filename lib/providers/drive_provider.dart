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
  bool _fileFound = false;
  DateTime _modifiedDate;
  DateTime _lastCheck;

  GoogleSignInAccount get currentUser => _currentUser;
  bool get fileFound => _fileFound;
  DateTime get modifiedDate => _modifiedDate;

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
        if (secSinceLastCheck < 15) return;
      }
      var client = GoogleHttpClient(await _currentUser.authHeaders);
      var drive = dAPI.DriveApi(client);
      dAPI.FileList _fileList =
          await drive.files.list(spaces: 'appDataFolder', $fields: '*');
      _fileList.files.forEach((f) {
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
      dAPI.File fileToUpload = dAPI.File();
      fileToUpload.name = 'kw.db';
      fileToUpload.parents = ["appDataFolder"];

      final dbPath = await sql.getDatabasesPath();
      final localFile = File('$dbPath/kw.db');

      final client = GoogleHttpClient(await _currentUser.authHeaders);
      final drive = dAPI.DriveApi(client);

      await drive.files.create(
        fileToUpload,
        uploadMedia: dAPI.Media(
          localFile.openRead(),
          localFile.lengthSync(),
        ),
      );
    } catch (error) {}
  }

  Future<void> deleteDB() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = dAPI.DriveApi(client);
    drive.files.list(spaces: 'appDataFolder').then((value) {
      value.files.forEach((f) {
        if (f.name == 'kw.db') drive.files.delete(f.id);
      });
    });
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
