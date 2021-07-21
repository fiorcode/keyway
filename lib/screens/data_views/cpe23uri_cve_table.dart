import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class Cpe23uriCveTableScreen extends StatefulWidget {
  static const routeName = '/cpe23uri-cve-table';

  @override
  _Cpe23uriCveTableScreenState createState() => _Cpe23uriCveTableScreenState();
}

class _Cpe23uriCveTableScreenState extends State<Cpe23uriCveTableScreen> {
  ItemProvider _item;
  Future<void> _getCpe23uriCves;

  Future<void> _getCpe23uriCvesAsync() async => await _item.fetchCpe23uriCves();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getCpe23uriCves = _getCpe23uriCvesAsync();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('cpe23uri_cve table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getCpe23uriCves,
        builder: (ctx, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return Center(child: Text('none'));
            case (ConnectionState.waiting):
              return Center(child: CircularProgressIndicator());
            case (ConnectionState.done):
              if (snap.hasError)
                return ErrorHelper.errorBody(snap.error);
              else
                return _item.cpe23uriCves.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _item.cpe23uriCves.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('fk_cpe23uri_id: '),
                                  Text(
                                    _item.cpe23uriCves[i].fkCpe23uriId
                                        .toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('fk_cve_id: '),
                                  Text(
                                    _item.cpe23uriCves[i].fkCveId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        separatorBuilder: (ctx, i) =>
                            Divider(color: Colors.black),
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
