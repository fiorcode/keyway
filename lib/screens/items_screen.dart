import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/error_helper.dart';
import '../providers/cripto_provider.dart';
import '../providers/item_provider.dart';
import '../screens/alpha_screen.dart';
import '../screens/dashboard_screen.dart';
import '../widgets/unlock_container.dart';
import '../widgets/Cards/alpha_locked_card.dart';
import '../widgets/Cards/alpha_unlocked_card.dart';

class ItemsListScreen extends StatefulWidget {
  static const routeName = '/items';

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  ItemProvider items;
  CriptoProvider cripto;
  bool _unlocking = false;
  Future getItems;

  _lockSwitch() => setState(() => _unlocking = !_unlocking);

  Future<void> _getItems() async => await items.fetchAndSetItems();

  onReturn() {
    getItems = _getItems();
    setState(() {});
  }

  @override
  void initState() {
    cripto = Provider.of<CriptoProvider>(context, listen: false);
    items = Provider.of<ItemProvider>(context, listen: false);
    getItems = _getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cripto = Provider.of<CriptoProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: cripto.locked
            ? null
            : IconButton(
                icon: Icon(Icons.widgets),
                onPressed: () => Navigator.of(context)
                    .pushNamed(DashboardScreen.routeName)
                    .then((_) => onReturn()),
              ),
        title: cripto.locked
            ? IconButton(
                icon: Icon(
                  Icons.lock_outline,
                  color: _unlocking ? Colors.orange : Colors.red,
                ),
                // onPressed: cripto.locked ? _lockSwitch : null,
                onPressed: () {
                  cripto.unlock('Qwe123!');
                  setState(() {});
                },
              )
            : items.items.length > 10
                ? IconButton(
                    icon: Icon(Icons.search, color: Colors.green),
                    onPressed: null,
                  )
                : IconButton(
                    icon: Icon(Icons.lock_open_sharp, color: Colors.green),
                    onPressed: () {
                      cripto.lock();
                      setState(() {});
                    },
                  ),
        actions: cripto.locked
            ? null
            : [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AlphaScreen.routeName)
                      .then((_) => onReturn()),
                ),
              ],
      ),
      body: FutureBuilder(
        future: getItems,
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
                    items.items.length <= 0
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width / 2,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.width / 4,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      decoration: BoxDecoration(
                                        color: Colors.orange[200],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Icon(
                                      Icons.vpn_key_sharp,
                                      size: 64,
                                      color: Colors.orange[800],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    'HAVE A KEY,\nSTART ENCRIPTING',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(8),
                            itemCount: items.items.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1),
                                child: cripto.locked
                                    ? AlphaLockedCard(alpha: items.items[i])
                                    : AlphaUnlockedCard(
                                        alpha: items.items[i],
                                        onReturn: onReturn,
                                      ),
                              );
                            },
                          ),
                    if (_unlocking && cripto.locked)
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
