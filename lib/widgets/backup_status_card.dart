import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:keyway/providers/drive_provider.dart';

class BackupStatusCard extends StatefulWidget {
  @override
  _BackupStatusCardState createState() => _BackupStatusCardState();
}

class _BackupStatusCardState extends State<BackupStatusCard> {
  @override
  Widget build(BuildContext context) {
    DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
    return FutureBuilder(
      future: drive.checkStatus(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snap.hasError) {
          return Center(
            child: Text(
              snap.error.toString(),
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else {
          return Card(
            elevation: 6,
            shadowColor: drive.fileFound ? Colors.green : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                width: 2,
                color: drive.fileFound ? Colors.green : Colors.red,
              ),
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
                    'Last time uploaded: ${drive.modifiedDate.day}/${drive.modifiedDate.month}/${drive.modifiedDate.year}',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        onPressed: null,
                        child: Text(
                          'UPLOAD',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                      if (drive.fileFound)
                        FlatButton(
                          onPressed: null,
                          child: Text(
                            'DOWNLOAD',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      if (drive.fileFound)
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
          );
        }
      },
    );
  }
}
