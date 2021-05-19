import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/username.dart';
import '../models/password.dart';
import '../models/item_password.dart';
import '../models/pin.dart';
import '../models/longText.dart';
import '../models/device.dart';

class PresetsWrap extends StatelessWidget {
  const PresetsWrap({Key key, @required this.item, this.refreshScreen})
      : super(key: key);

  final Item item;
  final Function refreshScreen;

  void _usernameSwitch() {
    item.username = item.username != null ? null : Username();
    refreshScreen();
  }

  void _passwordSwitch() {
    item.password = item.password != null ? null : Password();
    item.itemPassword = item.itemPassword != null ? null : ItemPassword();
    refreshScreen();
  }

  void _pinSwitch() {
    item.pin = item.pin != null ? null : Pin();
    refreshScreen();
  }

  void _longTextSwitch() {
    item.longText = item.longText != null ? null : LongText();
    refreshScreen();
  }

  void _deviceSwitch() {
    item.device = item.device != null ? null : Device();
    refreshScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      child: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor:
                    item.username != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.account_circle,
                  size: item.username != null ? 32 : 24,
                  color: item.username != null ? Colors.grey : Colors.white,
                ),
                elevation: item.username != null ? 8 : 0,
                heroTag: null,
                onPressed: _usernameSwitch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor:
                    item.password != null ? Colors.white : Colors.grey,
                child: Text(
                  '*',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: item.password != null ? 32 : 24,
                    fontWeight: FontWeight.bold,
                    color: item.password != null ? Colors.grey : Colors.white,
                  ),
                ),
                elevation: item.password != null ? 8 : 0,
                heroTag: null,
                onPressed: _passwordSwitch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor: item.pin != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.dialpad,
                  size: item.pin != null ? 32 : 24,
                  color: item.pin != null ? Colors.grey : Colors.white,
                ),
                elevation: item.pin != null ? 8 : 0,
                heroTag: null,
                onPressed: _pinSwitch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor:
                    item.longText != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.notes_rounded,
                  size: item.longText != null ? 32 : 24,
                  color: item.longText != null ? Colors.grey : Colors.white,
                ),
                elevation: item.longText != null ? 8 : 0,
                heroTag: null,
                onPressed: _longTextSwitch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor:
                    item.device != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.router,
                  size: item.device != null ? 32 : 24,
                  color: item.device != null ? Colors.grey : Colors.white,
                ),
                elevation: item.device != null ? 8 : 0,
                heroTag: null,
                onPressed: _deviceSwitch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
