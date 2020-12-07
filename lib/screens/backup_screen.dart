import 'package:flutter/material.dart';
import 'package:keyway/helpers/warning_helper.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/drive_provider.dart';
import 'package:keyway/widgets/Cards/backup_status_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupScreen extends StatefulWidget {
  static const routeName = '/backup';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  Future _silently;
  DriveProvider _drive;
  SharedPreferences _pref;

  void _loadPreferences() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future<void> _trySilently() async => await _drive.trySignInSilently();

  @override
  void initState() {
    _loadPreferences();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _drive = Provider.of<DriveProvider>(context, listen: true);
    _silently = _trySilently();
    super.didChangeDependencies();
  }

  Widget _setAppBarTitle() {
    return _drive.currentUser != null ?? _drive.currentUser.photoUrl != null
        ? CircleAvatar(
            backgroundImage: NetworkImage(_drive.currentUser.photoUrl),
            radius: AppBar().preferredSize.height * .40,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: _setAppBarTitle(),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _silently,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.done:
              return _drive.currentUser == null
                  ? NoSignedInBody(drive: _drive)
                  : SignedInBody(drive: _drive, pref: _pref);
              break;
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}

class SignedInBody extends StatefulWidget {
  const SignedInBody({
    Key key,
    @required this.drive,
    @required this.pref,
  }) : super(key: key);

  final DriveProvider drive;
  final SharedPreferences pref;

  @override
  _SignedInBodyState createState() => _SignedInBodyState();
}

class _SignedInBodyState extends State<SignedInBody> {
  bool _working = false;

  Future<void> _uploadDB() async {
    setState(() => _working = true);
    await widget.drive.uploadDB();
    setState(() => _working = false);
  }

  Future<void> _downloadDB(BuildContext context) async {
    if (await WarningHelper.downloadWarning(context)) {
      setState(() => _working = true);
      await widget.drive.downloadDB();
      setState(() => _working = false);
    }
  }

  Future<void> _deleteBackup(BuildContext context) async {
    if (await WarningHelper.deleteBackupWarning(context)) {
      setState(() => _working = true);
      await widget.drive.deleteDriveDB();
      setState(() => _working = false);
    }
  }

  bool _automaticUpdates() {
    bool _au = widget.pref.getBool('AutomaticUploads');
    if (_au != null) return _au;
    widget.pref.setBool('AutomaticUploads', false);
    return false;
  }

  Future<void> _automaticUpdatesSwitch() async {
    bool _au = widget.pref.getBool('AutomaticUploads');
    if (_au != null) {
      if (_au)
        widget.pref.setBool('AutomaticUploads', false);
      else {
        widget.pref.setBool('AutomaticUploads', true);
        _uploadDB();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image(
                  image: AssetImage('assets/drive_logo.png'),
                  height: 92,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BackupStatusCard(drive: widget.drive),
                  ),
                  if (_working)
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.orange[400],
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Automatic uploads'),
                      Switch(
                        activeColor: Theme.of(context).primaryColor,
                        value: _automaticUpdates(),
                        onChanged: (_) => _automaticUpdatesSwitch(),
                      ),
                    ],
                  ),
                  if (!widget.pref.getBool('AutomaticUploads') && !_working)
                    ButtonTheme(
                      height: 48,
                      child: RaisedButton.icon(
                        color: Colors.orange[400],
                        onPressed: _uploadDB,
                        icon: Icon(
                          Icons.upload_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        label: Text(
                          'Upload',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        shape: StadiumBorder(),
                      ),
                    ),
                ],
              ),
              Column(
                children: [
                  if (widget.drive.fileFound && !_working)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.blue[900],
                            heroTag: null,
                            onPressed: () => _downloadDB(context),
                            child: Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          SizedBox(width: 16),
                          FloatingActionButton(
                            backgroundColor: Colors.red,
                            heroTag: null,
                            onPressed: () => _deleteBackup(context),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  RaisedButton(
                    onPressed: () => widget.drive.handleSignOut(),
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
                ],
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
