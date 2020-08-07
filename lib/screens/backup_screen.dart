import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'package:http/io_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

class BackupScreen extends StatefulWidget {
  static const routeName = '/backup';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;
  FileList _fileList;
  File _db;

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
    _googleSignIn = GoogleSignIn(scopes: [DriveApi.DriveAppdataScope]);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _downloadData();
      }
    });
    _googleSignIn.signInSilently();
    _currentUser = _googleSignIn.currentUser;
  }

  Future<void> _downloadData() async {
    var client = GoogleHttpClient(await _currentUser.authHeaders);
    var drive = DriveApi(client);
    drive.files.list(spaces: 'appDataFolder').then((value) {
      _fileList = value;
      _fileList.files.forEach((f) {
        if (f.name == 'kw.db') _db = f;
        print(f.id);
      });
    });
  }

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
              const SizedBox(height: 24),
              if (_currentUser == null)
                RaisedButton(
                  onPressed: () {
                    _handleSignIn().then((_) => _downloadData());
                  },
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
