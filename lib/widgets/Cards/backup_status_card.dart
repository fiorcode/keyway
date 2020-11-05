import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:keyway/providers/drive_provider.dart';

class BackupStatusCard extends StatefulWidget {
  @override
  _BackupStatusCardState createState() => _BackupStatusCardState();
}

class _BackupStatusCardState extends State<BackupStatusCard> {
  Future _status;
  bool _working = false;

  _work(Future f) async {
    setState(() => _working = true);
    await f;
    setState(() => _working = false);
  }

  _checkStatus() async {
    DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
    await drive.checkStatus();
  }

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
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 6,
              shadowColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  width: 2,
                  color: Colors.orange,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        Text('Working...',
                            style: TextStyle(color: Colors.orange)),
                        SizedBox(height: 8),
                        Text(
                          'Last time uploaded: -',
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          case (ConnectionState.done):
            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 6,
              shadowColor: drive.fileFound ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  width: 2,
                  color: drive.fileFound ? Colors.green : Colors.red,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Icon(
                          drive.fileFound ? Icons.cloud_done : Icons.cloud_off,
                          color: drive.fileFound ? Colors.green : Colors.red,
                          size: 64,
                        ),
                        Text(
                          drive.fileFound ? 'File Found' : 'File Not Found',
                          style: TextStyle(
                            color: drive.fileFound ? Colors.green : Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          drive.fileFound
                              ? 'Last time uploaded: ${dateFormat.format(drive.modifiedDate)}'
                              : 'Last time uploaded: Never',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          children: [
                            FlatButton(
                              onPressed: () => _work(drive.uploadDB()),
                              child: Text(
                                'UPLOAD',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            if (drive.fileFound)
                              FlatButton(
                                onPressed: () => _work(drive.downloadDB()),
                                child: Text(
                                  'DOWNLOAD',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            if (drive.fileFound)
                              FlatButton(
                                onPressed: () => _work(drive.deleteDB()),
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
                  if (_working) LinearProgressIndicator(minHeight: 6),
                ],
              ),
            );
          default:
            return Center(child: Text('default'));
        }
      },
    );
  }
}
