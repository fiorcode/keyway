import 'package:flutter/material.dart';
import 'package:keyway/helpers/date_helper.dart';
import 'package:provider/provider.dart';

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
    return FutureBuilder(
      future: _status,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
            return Center(child: Text('none'));
          case (ConnectionState.waiting):
            return Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.orange,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Colors.orange,
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
              ),
            );
          case (ConnectionState.done):
            return Card(
              color: Colors.white,
              elevation: 8,
              clipBehavior: Clip.antiAlias,
              shadowColor: widget.drive.fileFound ? Colors.green : Colors.red,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Drive File Status',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(
                        widget.drive.fileFound
                            ? Icons.cloud_done
                            : Icons.cloud_off,
                        color:
                            widget.drive.fileFound ? Colors.green : Colors.red,
                        size: 64,
                      ),
                      Text(
                        widget.drive.fileFound
                            ? 'File Found!'
                            : 'File Not Found!',
                        style: TextStyle(
                          color: widget.drive.fileFound
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.drive.fileFound)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Date: ${DateHelper.shortDate(widget.drive.modifiedDate)}',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                    ],
                  ),
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
