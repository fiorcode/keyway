import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';
import 'package:keyway/helpers/password_helper.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:provider/provider.dart';

import '../../helpers/date_helper.dart';
import '../../models/item.dart';

class ItemLockedCard extends StatefulWidget {
  const ItemLockedCard({Key? key, this.item}) : super(key: key);

  final Item? item;

  @override
  _ItemLockedCardState createState() => _ItemLockedCardState();
}

class _ItemLockedCardState extends State<ItemLockedCard> {
  bool _pin = false;

  Color _setAvatarLetterColor() {
    Color _color = Color(widget.item!.avatarColor!);
    double bgDelta =
        _color.red * 0.299 + _color.green * 0.587 + _color.blue * 0.114;
    return (255 - bgDelta > 105)
        ? Colors.white.withAlpha(192)
        : Colors.black.withAlpha(192);
  }

  _onTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Unlock first, please.',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _passwordPin(BuildContext context) async {
    _pin = !_pin;
    if (_pin)
      widget.item!.title = Random.secure().nextInt(9999).toString();
    else {
      widget.item!.title = (await PasswordHelper.dicePassword()
              .onError((error, st) => ErrorHelper.errorDialog(context, error)))
          .password!;
    }
    Provider.of<ItemProvider>(context, listen: false)
        .updateItem(widget.item!)
        .onError((error, st) => ErrorHelper.errorDialog(context, error));
    setState(() {});
  }

  @override
  void initState() {
    if (widget.item!.cleartext) {
      if (!widget.item!.title.contains(RegExp(r'[a-zA-Z]'))) _pin = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.grey[700],
      elevation: 8,
      shape: StadiumBorder(),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.all(4),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: widget.item!.avatarColor != null
              ? Color(widget.item!.avatarColor!).withAlpha(192)
              : Colors.grey,
          child: widget.item!.cleartext
              ? Icon(Icons.flash_on)
              : Text(
                  widget.item!.title.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _setAvatarLetterColor(),
                  ),
                ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                widget.item!.title,
                maxLines: 1,
                softWrap: true,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
            ),
            Text(DateHelper.ddMMyyHm(widget.item!.date)),
          ],
        ),
        onTap: () => _onTap(context),
        trailing: Padding(
          padding: const EdgeInsets.all(4.0),
          child: widget.item!.cleartext
              ? SizedBox(
                  height: 48,
                  width: 48,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey[100],
                    child: Icon(
                      _pin ? Icons.password : Icons.pin,
                      color: Colors.grey,
                      size: 24,
                    ),
                    heroTag: null,
                    onPressed: () => _passwordPin(context),
                  ),
                )
              : Icon(Icons.lock, color: Colors.red),
        ),
      ),
    );
  }
}
