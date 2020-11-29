import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:keyway/providers/drive_provider.dart';

class BackupStatusCard extends StatefulWidget {
  const BackupStatusCard({Key key, this.drive}) : super(key: key);
  final DriveProvider drive;

  @override
  _BackupStatusCardState createState() => _BackupStatusCardState();
}

class _BackupStatusCardState extends State<BackupStatusCard> {
  Future _status;

  _checkStatus() async =>
      await Provider.of<DriveProvider>(context, listen: false).checkStatus();

  @override
  void initState() {
    _status = _checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              elevation: 8,
              shadowColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  width: 3,
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
              elevation: 8,
              shadowColor: widget.drive.fileFound ? Colors.green : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  width: 4,
                  color: widget.drive.fileFound ? Colors.green : Colors.red,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      widget.drive.fileFound
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      color: widget.drive.fileFound ? Colors.green : Colors.red,
                      size: 64,
                    ),
                    Text(
                      widget.drive.fileFound ? 'File Found' : 'File Not Found',
                      style: TextStyle(
                        color:
                            widget.drive.fileFound ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.drive.fileFound
                          ? 'Last time uploaded: ${dateFormat.format(widget.drive.modifiedDate)}'
                          : 'Last time uploaded: Never',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
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
