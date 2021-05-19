import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/username.dart';
import '../../providers/cripto_provider.dart';
import '../../providers/item_provider.dart';

class UserListCard extends StatefulWidget {
  const UserListCard(this.ctrler, this.userListSwitch, this.selectUsername);

  final TextEditingController ctrler;
  final Function userListSwitch;
  final Function selectUsername;

  @override
  _UserListCardState createState() => _UserListCardState();
}

class _UserListCardState extends State<UserListCard> {
  ItemProvider _items;
  Future<List<Username>> _getUsernames;

  Future<List<Username>> _usernamesList() async => await _items.getUsers();

  @override
  void initState() {
    _items = Provider.of<ItemProvider>(context, listen: false);
    _getUsernames = _usernamesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cripto =
        Provider.of<CriptoProvider>(context, listen: false);
    return FutureBuilder(
      future: _getUsernames,
      builder: (ctx, snap) {
        switch (snap.connectionState) {
          case ConnectionState.done:
            return Container(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Card(
                      color: Colors.grey[200],
                      clipBehavior: Clip.antiAlias,
                      elevation: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon: Icon(Icons.close_rounded),
                              color: Colors.grey,
                              onPressed: widget.userListSwitch,
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              children: [
                                ...snap.data.map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.grey[200],
                                            Colors.grey[100],
                                            Colors.white,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () => widget.selectUsername(
                                            _cripto.doDecrypt(
                                                e.usernameEnc, e.usernameIv)),
                                        child: Text(
                                          _cripto.doDecrypt(
                                              e.usernameEnc, e.usernameIv),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
