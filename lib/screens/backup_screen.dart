import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import 'package:http/io_client.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:googleapis/drive/v3.dart' as dAPI;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/items_screen.dart';

class BackupScreen extends StatefulWidget {
  static const routeName = '/backup';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;
  dAPI.FileList _fileList;

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      _currentUser = _googleSignIn.currentUser;
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(scopes: [dAPI.DriveApi.DriveAppdataScope]);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    _currentUser = _googleSignIn.currentUser;
  }

  Future _downloadDB() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = dAPI.DriveApi(client);
    drive.files.list(spaces: 'appDataFolder').then((value) {
      _fileList = value;
      _fileList.files.forEach((f) async {
        if (f.name == 'kw.db') {
          dAPI.Media file = await drive.files.get(
            f.id,
            downloadOptions: dAPI.DownloadOptions.FullMedia,
          );
          print(f.id);
          final dbPath = await sql.getDatabasesPath();
          final localFile = File('$dbPath/kw.db');
          List<int> dataStore = [];
          file.stream.listen((data) {
            dataStore.insertAll(dataStore.length, data);
          }, onDone: () {
            localFile.writeAsBytes(dataStore);
          }, onError: (error) {
            print("Some Error");
          });
        }
      });
    });
  }

  Future<void> _uploadDB() async {
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

  Future<void> _deleteDB() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = dAPI.DriveApi(client);
    drive.files.list(spaces: 'appDataFolder').then((value) {
      value.files.forEach((f) {
        if (f.name == 'kw.db') drive.files.delete(f.id);
        print('${f.id} DELETED');
      });
    });
  }

  _deleteLocalDB() async =>
      Provider.of<ItemProvider>(context, listen: false).removeItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_currentUser == null)
                Text(
                  'SIGN IN WITH \nYOUR \nGOOGLE ACCOUNT \nAND \nRESTORE YOUR DATA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              if (_currentUser == null) const SizedBox(height: 24),
              if (_currentUser == null)
                RaisedButton(
                  onPressed: () => _handleSignIn(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/google_logo.png'),
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              if (_currentUser != null)
                RaisedButton(
                  onPressed: _uploadDB,
                  child: Text('Upload Database'),
                ),
              if (_currentUser != null)
                RaisedButton(
                  onPressed: () async {
                    await _downloadDB();
                    Provider.of<CriptoProvider>(context, listen: false)
                        .setMasterKey();
                    Navigator.of(context)
                        .pushReplacementNamed(ItemsListScreen.routeName);
                  },
                  child: Text('Download Database'),
                ),
              if (_currentUser != null)
                RaisedButton(
                  onPressed: () {
                    Provider.of<CriptoProvider>(context, listen: false)
                        .setMasterKey();
                    Navigator.of(context)
                        .pushReplacementNamed(ItemsListScreen.routeName);
                  },
                  child: Text('GO'),
                ),
              if (_currentUser != null)
                RaisedButton(
                  onPressed: _deleteDB,
                  child: Text(
                    'Delete Database',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_currentUser != null)
                RaisedButton(
                  onPressed: () {
                    _deleteLocalDB();
                  },
                  child: Text(
                    'Delete Local Database',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (_currentUser != null)
                RaisedButton(
                  onPressed: () => _handleSignOut(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/google_logo.png'),
                          height: 32,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.red[800]),
                          ),
                        )
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
            ],
          ),
        ),
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
