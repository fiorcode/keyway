import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:keyway/helpers/warning_helper.dart';
import 'package:keyway/providers/drive_provider.dart';
import 'package:keyway/widgets/Cards/backup_status_card.dart';

class BackupScreen extends StatefulWidget {
  static const routeName = '/backup';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  Future _silently;
  DriveProvider _drive;
  SharedPreferences _pref;
  bool _working = false;

  Future<void> _uploadDB() async {
    setState(() => _working = true);
    await _drive.uploadDB();
    setState(() => _working = false);
  }

  Future<void> _downloadDB(BuildContext context) async {
    if (await WarningHelper.downloadWarning(context)) {
      setState(() => _working = true);
      await _drive.downloadDB();
      setState(() => _working = false);
    }
  }

  Future<void> _deleteBackup(BuildContext context) async {
    if (await WarningHelper.deleteBackupWarning(context)) {
      setState(() => _working = true);
      _drive.deleteDriveDB().then((_) => setState(() => _working = false));
    }
  }

  bool _automaticUpdates() {
    bool _au = _pref.getBool('automatic_uploads');
    if (_au != null) return _au;
    _pref.setBool('automatic_uploads', false);
    return false;
  }

  Future<void> _automaticUpdatesSwitch() async {
    setState(() => _working = true);
    bool _au = _pref.getBool('automatic_uploads');
    if (_au != null) {
      if (_au)
        _pref.setBool('automatic_uploads', false);
      else {
        _pref.setBool('automatic_uploads', true);
        _uploadDB();
      }
    }
    setState(() => _working = false);
  }

  void _loadPreferences() async =>
      _pref = await SharedPreferences.getInstance();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actions: [
          _drive.currentUser == null
              ? TextButton.icon(
                  icon: Image(
                    image: AssetImage('assets/google_logo.png'),
                    height: AppBar().preferredSize.height * .50,
                  ),
                  label: Text('Sign in'),
                  onPressed: _drive.handleSignIn,
                )
              : TextButton.icon(
                  icon: Image(
                    image: AssetImage('assets/google_logo.png'),
                    height: AppBar().preferredSize.height * .50,
                  ),
                  label: Text('Sign out'),
                  onPressed: _drive.handleSignOut,
                ),
        ],
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
                  ? Center(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'SIGN IN \nWITH YOUR \nGOOGLE ACCOUNT \nTO \nBACKUP \nYOUR DATA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_working)
                            Center(
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.orange[400],
                              ),
                            ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 32,
                                right: 32,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      width: 92,
                                      height: 92,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              _drive.currentUser.photoUrl,
                                            ),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  BackupStatusCard(drive: _drive),
                                  SizedBox(height: 8),
                                  Card(
                                    color: Colors.white,
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 3,
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Switch(
                                            activeColor: Colors.green,
                                            value: _automaticUpdates(),
                                            onChanged: (_) =>
                                                _automaticUpdatesSwitch(),
                                          ),
                                          Text(
                                            'Automatic uploads',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    width: 256,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        primary: Colors.white,
                                      ),
                                      onPressed: _uploadDB,
                                      icon: Icon(
                                        Icons.cloud_upload,
                                        color: Theme.of(context).primaryColor,
                                        size: 32,
                                      ),
                                      label: Text(
                                        'Upload database',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_drive.fileFound)
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      width: 256,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          primary: Colors.white,
                                        ),
                                        onPressed: () => _downloadDB(context),
                                        icon: Icon(
                                          Icons.cloud_download,
                                          color: Theme.of(context).primaryColor,
                                          size: 32,
                                        ),
                                        label: Text(
                                          'Download database',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_drive.fileFound && !_working)
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      width: 256,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          primary: Colors.red,
                                        ),
                                        onPressed: () => _deleteBackup(context),
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        label: Text(
                                          'Delete database',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
              break;
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
