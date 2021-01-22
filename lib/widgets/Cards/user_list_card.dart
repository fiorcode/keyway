import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:keyway/models/item.dart';
import 'package:provider/provider.dart';

import '../../providers/cripto_provider.dart';

class UserListCard extends StatelessWidget {
  const UserListCard(
      this.ctrler, this.userListSwitch, this.list, this.selectUsername);

  final TextEditingController ctrler;
  final Function userListSwitch;
  final Function selectUsername;
  final List<Username> list;

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cripto =
        Provider.of<CriptoProvider>(context, listen: false);
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(64),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
              ),
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
                      onPressed: userListSwitch,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      children: [
                        ...list.map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: FlatButton(
                                onPressed: () => selectUsername(_cripto
                                    .doDecrypt(e.username, e.usernameIV)),
                                child: Text(
                                  _cripto.doDecrypt(e.username, e.usernameIV),
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
  }
}
