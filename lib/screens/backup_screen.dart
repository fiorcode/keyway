import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/drive_provider.dart';
import 'package:keyway/widgets/backup_status_card.dart';

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
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image(
            image: AssetImage('assets/drive_logo.png'),
            height: 92,
          ),
          Text(
            'GOOGLE DRIVE \nFILE \nSTATUS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          BackupStatusCard(),
          Center(
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
                  borderRadius: BorderRadius.circular(32)),
            ),
          ),
        ],
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'SIGN IN \nWITH YOUR \nGOOGLE ACCOUNT \nAND \nRESTORE \nYOUR DATA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
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
