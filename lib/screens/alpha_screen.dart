import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/models/item.dart';
import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/screens/keyhole_screen.dart';
import 'package:keyway/widgets/TextFields/ip_text_field.dart';
import 'package:keyway/widgets/TextFields/password_text_field.dart';
import 'package:keyway/widgets/TextFields/pin_text_field.dart';
import 'package:keyway/widgets/TextFields/title_text_field.dart';
import 'package:keyway/widgets/TextFields/username_text_field.dart';

class AlphaScreen extends StatefulWidget {
  static const routeName = '/alpha';

  @override
  _AlphaScreenState createState() => _AlphaScreenState();
}

class _AlphaScreenState extends State<AlphaScreen> {
  final _titleCtrler = TextEditingController();
  final _userCtrler = TextEditingController();
  final _passCtrler = TextEditingController();
  final _pinCtrler = TextEditingController();
  final _ipCtrler = TextEditingController();

  _save() async {
    try {
      if (_titleCtrler.text.isEmpty) return;
      CriptoProvider _cProv =
          Provider.of<CriptoProvider>(context, listen: false);
      AlphaItem _item = AlphaItem(
        title: _titleCtrler.text,
        username: _userCtrler.text.isEmpty
            ? ''
            : await _cProv.doCrypt(_userCtrler.text),
        password: _passCtrler.text.isEmpty
            ? ''
            : await _cProv.doCrypt(_passCtrler.text),
        pin: _pinCtrler.text.isEmpty
            ? ''
            : await _cProv.doCrypt(_pinCtrler.text),
        ip: _ipCtrler.text.isEmpty ? '' : await _cProv.doCrypt(_ipCtrler.text),
      );
      ItemProvider _iProv = Provider.of<ItemProvider>(context, listen: false);
      _iProv.addAlpha(_item);
    } catch (error) {}
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cProv = Provider.of<CriptoProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_outline),
            onPressed: () {
              try {
                if (_cProv.locked)
                  Navigator.of(context).pushNamed(KeyholeScreen.routeName);
                else
                  _save();
              } catch (error) {}
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                child: TitleTextField(_titleCtrler),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: UsernameTextField(_userCtrler),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PasswordTextField(_passCtrler),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PinTextField(_pinCtrler),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: IpTextField(_ipCtrler),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
