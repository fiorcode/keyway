import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/username.dart';
import '../models/password.dart';
import '../models/item_password.dart';
import '../models/pin.dart';
import '../models/note.dart';
import '../models/address.dart';
import '../models/product.dart';

class PresetsList extends StatelessWidget {
  const PresetsList({this.item, this.updateScreen});

  final Item item;
  final Function updateScreen;

  void _usernameSwitch() {
    item.username = item.username != null ? null : Username();
    updateScreen();
  }

  void _passwordSwitch() {
    item.password = item.password != null ? null : Password();
    item.itemPassword = item.itemPassword != null ? null : ItemPassword();
    updateScreen();
  }

  void _pinSwitch() {
    item.pin = item.pin != null ? null : Pin();
    updateScreen();
  }

  void _longTextSwitch() {
    item.note = item.note != null ? null : Note();
    updateScreen();
  }

  void _addressSwitch() {
    item.address = item.address != null ? null : Address();
    updateScreen();
  }

  void _productSwitch() {
    item.product = item.product != null ? null : Product();
    updateScreen();
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
                  Icons.account_box,
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
                child: Icon(
                  Icons.password,
                  size: item.password != null ? 32 : 24,
                  color: item.password != null ? Colors.grey : Colors.white,
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
                  Icons.pin,
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
                backgroundColor: item.note != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.notes_rounded,
                  size: item.note != null ? 32 : 24,
                  color: item.note != null ? Colors.grey : Colors.white,
                ),
                elevation: item.note != null ? 8 : 0,
                heroTag: null,
                onPressed: _longTextSwitch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor:
                    item.address != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.http,
                  size: item.address != null ? 32 : 24,
                  color: item.address != null ? Colors.grey : Colors.white,
                ),
                elevation: item.address != null ? 8 : 0,
                heroTag: null,
                onPressed: _addressSwitch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FloatingActionButton(
                backgroundColor:
                    item.product != null ? Colors.white : Colors.grey,
                child: Icon(
                  Icons.router,
                  size: item.product != null ? 32 : 24,
                  color: item.product != null ? Colors.grey : Colors.white,
                ),
                elevation: item.product != null ? 8 : 0,
                heroTag: null,
                onPressed: _productSwitch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
