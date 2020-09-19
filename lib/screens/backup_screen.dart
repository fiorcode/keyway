import 'package:flutter/material.dart';
import 'package:keyway/providers/drive_provider.dart';

import 'package:provider/provider.dart';

class BackupScreen extends StatefulWidget {
  static const routeName = '/backup';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
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
            ? Center(child: CircularProgressIndicator())
            : Consumer<DriveProvider>(
                child: NoSignedInBody(drive: drive),
                builder: (ctx, dp, ch) =>
                    dp.currentUser == null ? ch : SignedInBody(drive: drive),
              ),
      ),
    );
  }
}

class SignedInBody extends StatelessWidget {
  const SignedInBody({
    Key key,
    @required this.drive,
  }) : super(key: key);

  final DriveProvider drive;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/drive_logo.png'),
                      height: 96,
                    ),
                    SizedBox(height: 16),
                    Card(
                      elevation: 6,
                      shadowColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(width: 1, color: Colors.green),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Google Drive File Status',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Icon(
                              Icons.cloud_done,
                              color: Colors.green,
                              size: 64,
                            ),
                            const Text(
                              'File Found',
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceEvenly,
                              spacing: 2,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.black54,
                                ),
                                const Text(
                                  'Last time uploaded: 27/09/2020',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  onPressed: null,
                                  child: Text(
                                    'UPLOAD',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: null,
                                  child: Text(
                                    'DOWNLOAD',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: null,
                                  child: Text(
                                    'DELETE',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  onPressed: () => drive.handleSignOut(),
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
                            style: TextStyle(color: Colors.red),
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
    );
  }
}

class NoSignedInBody extends StatelessWidget {
  const NoSignedInBody({
    Key key,
    @required this.drive,
  }) : super(key: key);

  final DriveProvider drive;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
