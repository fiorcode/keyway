import 'package:flutter/material.dart';

class PresetsWrap extends StatelessWidget {
  const PresetsWrap({
    Key key,
    @required this.username,
    @required this.password,
    @required this.pin,
    @required this.ip,
    @required this.longText,
    @required this.usernameSwitch,
    @required this.passwordSwitch,
    @required this.pinSwitch,
    @required this.ipSwitch,
    @required this.longTextSwitch,
  }) : super(key: key);

  final bool username;
  final bool password;
  final bool pin;
  final bool ip;
  final bool longText;
  final Function usernameSwitch;
  final Function passwordSwitch;
  final Function pinSwitch;
  final Function ipSwitch;
  final Function longTextSwitch;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: <Widget>[
        FloatingActionButton(
          backgroundColor: username ? Colors.white : Colors.grey,
          child: Icon(
            Icons.account_circle,
            size: username ? 32 : 24,
            color: username ? Colors.grey : Colors.white,
          ),
          elevation: username ? 8 : 0,
          heroTag: null,
          onPressed: usernameSwitch,
        ),
        FloatingActionButton(
          backgroundColor: password ? Colors.white : Colors.grey,
          child: Text(
            '*',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: password ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: password ? Colors.grey : Colors.white,
            ),
          ),
          elevation: password ? 8 : 0,
          heroTag: null,
          onPressed: passwordSwitch,
        ),
        FloatingActionButton(
          backgroundColor: pin ? Colors.white : Colors.grey,
          child: Icon(
            Icons.dialpad,
            size: pin ? 32 : 24,
            color: pin ? Colors.grey : Colors.white,
          ),
          elevation: pin ? 8 : 0,
          heroTag: null,
          onPressed: pinSwitch,
        ),
        FloatingActionButton(
          backgroundColor: ip ? Colors.white : Colors.grey,
          child: Icon(
            Icons.language,
            size: ip ? 32 : 24,
            color: ip ? Colors.grey : Colors.white,
          ),
          elevation: ip ? 8 : 0,
          heroTag: null,
          onPressed: ipSwitch,
        ),
        FloatingActionButton(
          backgroundColor: longText ? Colors.white : Colors.grey,
          child: Icon(
            Icons.notes_rounded,
            size: longText ? 32 : 24,
            color: longText ? Colors.grey : Colors.white,
          ),
          elevation: longText ? 8 : 0,
          heroTag: null,
          onPressed: longTextSwitch,
        ),
      ],
    );
  }
}
