import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/item_provider.dart';
import '../widgets/empty_items.dart';

class NotesListScreen extends StatefulWidget {
  static const routeName = '/notes';

  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  ItemProvider _item;
  Future _getNotesAsync;

  Future<void> _getNotes() async => await _item.fetchNotes();

  @override
  void didChangeDependencies() {
    _item = Provider.of<ItemProvider>(context);
    _getNotesAsync = _getNotes();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder(
        future: _getNotesAsync,
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
                return _item.notes.length <= 0
                    ? EmptyItems()
                    : DataTable(
                        columnSpacing: 8,
                        columns: [
                          DataColumn(label: Text('id')),
                          DataColumn(label: Text('note_enc')),
                          DataColumn(label: Text('note_iv')),
                        ],
                        rows: _item.notes
                            .map(
                              (n) => DataRow(
                                cells: [
                                  DataCell(Container(
                                    width: 16,
                                    child: Center(
                                        child: Text(n.longTextId.toString())),
                                  )),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          n.longTextEnc,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      width: 92,
                                      child: Center(
                                        child: Text(
                                          n.longTextIv,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
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
