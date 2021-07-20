import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/cripto_provider.dart';

class RestoreScreen extends StatefulWidget {
  static const routeName = '/restore';

  @override
  _RestoreScreenState createState() => _RestoreScreenState();
}

class _RestoreScreenState extends State<RestoreScreen> {
  // CriptoProvider _cripto;
  // bool _working = false;
  Future<void> _searchBacks;

  // Future<void> _searchBacksAsync() async {}

  // @override
  // void initState() {
  //   _cripto = Provider.of<CriptoProvider>(context, listen: false);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder(
        future: _searchBacks,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.done:
              return Center(
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
