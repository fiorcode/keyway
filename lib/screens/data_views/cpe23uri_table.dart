import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/widgets/empty_items.dart';

class Cpe23uriTableScreen extends StatefulWidget {
  static const routeName = '/cpe23uri-table';

  @override
  _Cpe23uriTableScreenState createState() => _Cpe23uriTableScreenState();
}

class _Cpe23uriTableScreenState extends State<Cpe23uriTableScreen> {
  late ItemProvider _item;
  Future? _getCpe23uris;

  Future<void> _getCpe23urisAsync() async =>
      await Provider.of<ItemProvider>(context).fetchCpe23uris();

  @override
  void initState() {
    _getCpe23uris = _getCpe23urisAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _item = Provider.of<ItemProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text('cpe23uri table', style: TextStyle(color: Colors.grey)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getCpe23uris,
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
                return _item.cpe23uris.length <= 0
                    ? EmptyItems()
                    : ListView.separated(
                        itemCount: _item.cpe23uris.length,
                        itemBuilder: (ctx, i) => ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('id: '),
                                  Text(
                                    _item.cpe23uris[i].cpe23uriId.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('value: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].value!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('deprecated: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].deprecated == null
                                          ? 'null'
                                          : _item.cpe23uris[i].deprecated
                                              .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('last_modified_date: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].lastModifiedDate ==
                                              null
                                          ? 'null'
                                          : _item
                                              .cpe23uris[i].lastModifiedDate!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('title: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('ref: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].ref == null
                                          ? 'null'
                                          : _item.cpe23uris[i].ref!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('ref_type: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].refType == null
                                          ? 'null'
                                          : _item.cpe23uris[i].refType!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('last_tracking: '),
                                  Expanded(
                                    child: Text(
                                      _item.cpe23uris[i].lastTracking == null
                                          ? 'null'
                                          : _item.cpe23uris[i].lastTracking!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
            default:
              return Center(child: Text('default'));
          }
        },
      ),
    );
  }
}
