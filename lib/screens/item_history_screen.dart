import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/helpers/date_helper.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/widgets/empty_items.dart';
import 'package:keyway/widgets/unlock_container.dart';

class ItemHistoryScreen extends StatefulWidget {
  static const routeName = '/item-history';
  const ItemHistoryScreen({Key key, this.itemId}) : super(key: key);

  final int itemId;

  @override
  _ItemHistoryScreenState createState() => _ItemHistoryScreenState();
}

class _ItemHistoryScreenState extends State<ItemHistoryScreen> {
  ItemProvider _items;
  CriptoProvider _cripto;
  bool _unlocking = false;
  Future _getItemOlds;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItemHistory() async =>
      await _items.fetchItemAndOldPasswords(widget.itemId);

  // void _delete(OldPasswrodPin old) async {
  //   await _items.deleteOldPassPin(old);
  //   _getItemOlds = _getItemHistory();
  //   setState(() {});
  // }

  @override
  void didChangeDependencies() {
    _cripto = Provider.of<CriptoProvider>(context);
    _items = Provider.of<ItemProvider>(context, listen: false);
    _getItemOlds = _getItemHistory();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: _cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                // onPressed: cripto.locked ? _lockSwitch : null,
                onPressed: () => _cripto.unlock('Qwe123!'),
              )
            : _items.items.length > 10
                ? IconButton(
                    icon: Icon(Icons.search, color: Colors.green),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(Icons.lock_open_sharp, color: Colors.green),
                    onPressed: () => _cripto.lock(),
                  ),
      ),
      body: FutureBuilder(
        future: _getItemOlds,
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
                return Stack(
                  children: [
                    _items.itemAndOldPasswords.length <= 0
                        ? EmptyItems()
                        : ListView.separated(
                            padding: EdgeInsets.all(12.0),
                            itemCount: _items.itemAndOldPasswords.length,
                            itemBuilder: (ctx, i) {
                              return ListTile(
                                // leading: Chip(
                                //   label: Text(
                                //     _df.format(
                                //       DateTime.parse(
                                //         _items.itemOlds[i].passwordPinDate,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                title: Text(
                                  _cripto.doDecrypt(
                                    _items.itemAndOldPasswords[i].password
                                        .passwordEnc,
                                    _items.itemAndOldPasswords[i].password
                                        .passwordIv,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 16),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateHelper.shortDate(
                                              _items.itemAndOldPasswords[i]
                                                  .itemPassword.passwordDate,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: SizedBox(
                                  height: 48,
                                  width: 48,
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.red[300],
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    heroTag: null,
                                    onPressed: () {},
                                    // _delete(_items.itemHistory[i]),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          ),
                    if (_unlocking && _cripto.locked)
                      UnlockContainer(_lockSwitch),
                  ],
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
