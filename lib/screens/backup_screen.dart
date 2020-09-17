import 'package:flutter/material.dart';
import 'package:keyway/providers/drive_provider.dart';

import 'package:provider/provider.dart';
import "package:http/http.dart" as http;
import 'package:http/io_client.dart';

class BackupScreen extends StatefulWidget {
  static const routeName = '/backup';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  // Future _downloadDB() async {
  //   var client = GoogleHttpClient(await _currentUser.authHeaders);
  //   var drive = dAPI.DriveApi(client);
  //   await drive.files.list(spaces: 'appDataFolder').then((value) {
  //     _fileList = value;
  //     _fileList.files.forEach((f) async {
  //       if (f.name == 'kw.db') {
  //         dAPI.Media file = await drive.files.get(
  //           f.id,
  //           downloadOptions: dAPI.DownloadOptions.FullMedia,
  //         );
  //         print(f.id);
  //         final dbPath = await sql.getDatabasesPath();
  //         final localFile = File('$dbPath/kw.db');
  //         List<int> dataStore = [];
  //         file.stream.listen((data) {
  //           dataStore.insertAll(dataStore.length, data);
  //         }, onDone: () {
  //           localFile.writeAsBytesSync(dataStore, flush: true);
  //           Provider.of<CriptoProvider>(context, listen: false).setMasterKey();
  //           Navigator.of(context)
  //               .pushReplacementNamed(ItemsListScreen.routeName);
  //         }, onError: (error) {
  //           print("Some Error");
  //         });
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
    drive.trySignInSilently();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: FutureBuilder(
        future: drive.trySignInSilently(),
        builder: (ctx, snap) => snap.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<DriveProvider>(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
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
                      RaisedButton(
                        onPressed: () => drive.handleSignIn(),
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
                    ],
                  ),
                ),
                builder: (ctx, dp, ch) => dp.currentUser == null
                    ? ch
                    : SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      color: Colors.lightGreen[800],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.cloud_download,
                                              size: 64,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Download your data from your personal drive cloud.',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            FlatButton(
                                              onPressed: drive.downloadDB,
                                              child: const Text(
                                                'DOWNLOAD',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Last download: 01/01/2020',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.lightBlue[800],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.cloud_upload,
                                              size: 64,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Upload your data on your personal drive cloud.',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: drive.uploadDB,
                                              child: const Text(
                                                'UPLOAD',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Last upload: 01/01/2020',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Card(
                                      color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                              size: 64,
                                            ),
                                            Text(
                                              'Delete your data from your personal drive cloud.',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.6),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            FlatButton(
                                              onPressed: () {},
                                              child: Text(
                                                'DELETE',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: () => drive.handleSignOut(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                            image: AssetImage(
                                                'assets/google_logo.png'),
                                            height: 32,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'Sign Out',
                                              style: TextStyle(
                                                  color: Colors.red[800]),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
