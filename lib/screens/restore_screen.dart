import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cripto_provider.dart';
import '../providers/drive_provider.dart';
import 'items_screen.dart';
import '../widgets/Cards/backup_status_card.dart';

class RestoreScreen extends StatefulWidget {
  static const routeName = '/restore';

  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  Future _silently;
  CriptoProvider _cripto;
  DriveProvider _drive;
  bool _working = false;

  Future<void> _trySilently() async => await _drive.trySignInSilently();

  _restore() async {
    setState(() => _working = true);
    DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
    drive.downloadDB().then((value) {
      _cripto.setMasterKey();
      setState(() => _working = false);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(ItemsListScreen.routeName, (route) => false);
    });
  }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context, listen: false);
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
                          'SIGN IN \nWITH YOUR \nGOOGLE ACCOUNT \nTO \nRESTORE \nYOUR DATA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.all(32),
                      children: [
                        if (_working)
                          Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.orange[400],
                            ),
                          ),
                        Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                  _drive.currentUser.photoUrl,
                                ),
                                fit: BoxFit.scaleDown),
                          ),
                        ),
                        SizedBox(height: 16),
                        BackupStatusCard(drive: _drive),
                        SizedBox(height: 32),
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
                              onPressed: _restore,
                              icon: Icon(
                                Icons.cloud_download,
                                color: Theme.of(context).primaryColor,
                                size: 32,
                              ),
                              label: Text(
                                'Restore database',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
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
