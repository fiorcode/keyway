import 'package:flutter/material.dart';

import '../models/cve.dart';
import '../helpers/error_helper.dart';
import '../widgets/empty_items.dart';
import '../widgets/loading_scaffold.dart';

class VulnerabilitiesListScreen extends StatefulWidget {
  static const routeName = '/cves-list';

  @override
  _VulnerabilitiesListScreenState createState() =>
      _VulnerabilitiesListScreenState();
}

class _VulnerabilitiesListScreenState extends State<VulnerabilitiesListScreen> {
  Future<void>? _getCves;
  List<Cve> _cves = <Cve>[];

  bool _working = false;

  Future<void> _getCvesAsync() async => _cves = [];
  // await Provider.of<NistProvider>(context, listen: false).fetchCves();

  // void _onReturn() {
  //   _getCves = _getCvesAsync();
  //   setState(() {});
  // }

  // void _goToCveView(Item i) {
  //   if (Provider.of<CriptoProvider>(context, listen: false).locked) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text('Please unlock'),
  //         duration: Duration(seconds: 1),
  //       ),
  //     );
  //     return;
  //   }
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ItemViewScreen(item: i),
  //     ),
  //   ).then((_) => _onReturn());
  // }

  @override
  void initState() {
    _getCves = _getCvesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // CriptoProvider _cripto = Provider.of<CriptoProvider>(context);
    Color _primary = Theme.of(context).primaryColor;
    Color _back = Theme.of(context).backgroundColor;
    return FutureBuilder(
        future: _getCves,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.waiting:
              return LoadingScaffold();
            case ConnectionState.done:
              if (snap.hasError)
                return ErrorHelper.errorScaffold(snap.error);
              else {
                return Scaffold(
                  backgroundColor: _back,
                  appBar: AppBar(
                    backgroundColor: _back,
                    iconTheme: IconThemeData(color: _primary),
                    centerTitle: true,
                    actionsIconTheme: IconThemeData(color: _primary),
                  ),
                  body: Stack(children: [
                    _cves.length < 1
                        ? EmptyItems()
                        : Column(
                            children: [
                              if (_working) LinearProgressIndicator(),
                              // Expanded(
                              //   child: ListView.builder(
                              //     key: UniqueKey(),
                              //     padding: EdgeInsets.all(12.0),
                              //     shrinkWrap: true,
                              //     itemCount: _cves.length,
                              //     itemBuilder: (ctx, i) {
                              // return ItemLockedCard(item: _cves[i]);
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                  ]),
                );
              }
            default:
              return LoadingScaffold();
          }
        });
  }
}
