import 'dart:async';
import 'dart:io';

import 'package:googleapis/drive/v3.dart' as dApi;
import "package:http/http.dart" as http;
import "package:http/io_client.dart";
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sqflite/sqflite.dart' as sql;

// const _clientId =
//     '51420250153-m16q6i98hbjc2unavf5lo4raov95rds7.apps.googleusercontent.com';

class SignInDemo extends StatefulWidget {
  static const routeName = '/sign-in';

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: [dApi.DriveApi.DriveAppdataScope]);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _uploadFileToGoogleDrive();
      }
    });
    _googleSignIn.signInSilently();
  }

  _uploadFileToGoogleDrive() async {
    try {
      dApi.File fileToUpload = dApi.File();
      fileToUpload.name = 'kw.db';
      fileToUpload.parents = ["appDataFolder"];

      final dbPath = await sql.getDatabasesPath();
      final localFile = File('$dbPath/kw.db');

      final client = GoogleHttpClient(await _currentUser.authHeaders);
      final drive = dApi.DriveApi(client);

      await drive.files.create(
        fileToUpload,
        uploadMedia: dApi.Media(
          localFile.openRead(),
          localFile.lengthSync(),
        ),
      );
      _listGoogleDriveFiles();
      _deleteGoogleDriveFiles();
    } catch (error) {}
  }

  Future<void> _listGoogleDriveFiles() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = dApi.DriveApi(client);
    drive.files.list(spaces: 'appDataFolder').then((value) {
      var list = value;
      list.files.forEach((f) {
        print(f.id);
      });
    });
  }

  Future<void> _deleteGoogleDriveFiles() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = dApi.DriveApi(client);
    drive.files.list(spaces: 'appDataFolder').then((value) {
      var list = value;
      for (var i = 0; i < list.files.length; i++) {
        print("Id: ${list.files[i].id} DELETED");
        drive.files.delete(list.files[i].id);
      }
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            // leading: GoogleUserCircleAvatar(
            //   identity: _currentUser,
            // ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          RaisedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
          RaisedButton(
            child: const Text('UPLOAD FILE'),
            onPressed: _uploadFileToGoogleDrive,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sign In'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
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
