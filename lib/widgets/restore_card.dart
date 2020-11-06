import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/drive_provider.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/screens/items_screen.dart';

class RestoreCard extends StatefulWidget {
  @override
  _RestoreCardState createState() => _RestoreCardState();
}

class _RestoreCardState extends State<RestoreCard> {
  Future _status;

  _restore(DriveProvider drive) async {
    CriptoProvider cripto = Provider.of<CriptoProvider>(context, listen: false);
    await drive.downloadDB().then((_) async {
      await cripto.setMasterKey();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(ItemsListScreen.routeName, (route) => false);
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(height: 16),
                    Icon(
                      drive.fileFound ? Icons.cloud_done : Icons.cloud_off,
                      color: drive.fileFound ? Colors.green : Colors.red,
                      size: 128,
                    ),
                    Text(
                      drive.fileFound ? 'File Found' : 'File Not Found',
                      style: TextStyle(
                        color: drive.fileFound ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 16),
                    if (drive.fileFound)
                      RaisedButton.icon(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        onPressed: () => _restore(drive),
                        icon: Icon(Icons.restore, color: Colors.green),
                        label: Text(
                          'RESTORE',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    SizedBox(height: 8),
                    if (drive.fileFound)
                      Text(
                        'Uploaded: ${dateFormat.format(drive.modifiedDate)}',
                        style: TextStyle(color: Colors.black54),
                      ),
                  ],
                ),
              ),
            );
          default:
            return Center(child: Text('default'));
        }
      },
    );
  }
}
