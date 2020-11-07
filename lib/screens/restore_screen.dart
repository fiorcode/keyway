import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/drive_provider.dart';
import '../widgets/no_signed_in_body.dart';
import '../widgets/restore_body.dart';

class RestoreScreen extends StatefulWidget {
  static const routeName = '/restore';

  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  Future trySignInSilently;

  Future _trySignInSilently() async {
    DriveProvider drive = Provider.of<DriveProvider>(context, listen: false);
    return drive.trySignInSilently();
  }

  @override
  void initState() {
    trySignInSilently = _trySignInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    trySignInSilently = _trySignInSilently();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: FutureBuilder(
        future: trySignInSilently,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasError)
              return ErrorHelper.errorBody(snap.error);
            else
              return Consumer<DriveProvider>(
                child: NoSignedInBody(),
                builder: (ctx, dp, ch) =>
                    dp.currentUser == null ? ch : RestoreBody(),
              );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
