import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/drive_provider.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/items_screen.dart';

class RestoreBody extends StatefulWidget {
  @override
  _RestoreBodyState createState() => _RestoreBodyState();
}

class _RestoreBodyState extends State<RestoreBody> {
  Future _status;
  bool _downloading = false;

  _restore() async {
    setState(() {
      _downloading = true;
      DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
      CriptoProvider cripto =
          Provider.of<CriptoProvider>(context, listen: false);
      drive.downloadDB().then((value) {
        _downloading = false;
        cripto.setMasterKey();
        Navigator.of(context).pushNamedAndRemoveUntil(
            ItemsListScreen.routeName, (route) => false);
      });
    });
  }

  _checkStatus() async =>
      await Provider.of<DriveProvider>(context, listen: false).checkStatus();

  @override
  void initState() {
    _status = _checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
    DateFormat dateFormat = DateFormat('dd/MM/yyyy H:mm');
    return FutureBuilder(
      future: _status,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
            return Center(child: Text('none'));
          case (ConnectionState.waiting):
            return LinearProgressIndicator();
          case (ConnectionState.done):
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.white70,
                      height: 128,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Image.asset(
                          'assets/drive_logo.png',
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white54,
                      height: 64,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Icon(
                          drive.fileFound ? Icons.cloud_done : Icons.cloud_off,
                          color: drive.fileFound ? Colors.green : Colors.red,
                          size: 64,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white30,
                      height: 32,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          drive.fileFound ? 'File Found!' : 'File Not Found!',
                          style: TextStyle(
                            color: drive.fileFound ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white12,
                      height: 16,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ],
                ),
                _downloading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: drive.fileFound ? Colors.green : Colors.grey,
                        ),
                        child: Text(
                          drive.fileFound ? 'Restore' : 'Setup a password',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: drive.fileFound
                            ? _restore
                            : () => Navigator.of(context).pop(),
                      ),
                drive.fileFound
                    ? Text(
                        'File uploaded on ${dateFormat.format(drive.modifiedDate)}',
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : SizedBox(height: 16),
              ],
            );
          default:
            return Center(child: Text('default'));
        }
      },
    );
  }
}
