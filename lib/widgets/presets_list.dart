import 'package:flutter/material.dart';

import '../models/item.dart';

class PresetsList extends StatelessWidget {
  const PresetsList({
    this.item,
    this.usernameSwitch,
    this.passwordSwitch,
    this.pinSwitch,
    this.noteSwitch,
    this.addressSwitch,
    this.productSwitch,
  });

  final Item item;
  final Function usernameSwitch;
  final Function passwordSwitch;
  final Function pinSwitch;
  final Function noteSwitch;
  final Function addressSwitch;
  final Function productSwitch;

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
                onPressed: usernameSwitch,
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
                onPressed: passwordSwitch,
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
                onPressed: pinSwitch,
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
                onPressed: noteSwitch,
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
                onPressed: addressSwitch,
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
                onPressed: productSwitch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
