import 'package:flutter/material.dart';

class CheckBoard extends StatelessWidget {
  CheckBoard({@required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        IconLabel(
          label: 'a-z',
          logic: password.contains(RegExp(r'[a-z]')) ? true : false,
        ),
        IconLabel(
          label: 'A-Z',
          logic: password.contains(RegExp(r'[A-Z]')) ? true : false,
        ),
        IconLabel(
          label: '0-9',
          logic: password.contains(RegExp(r'[0-9]')) ? true : false,
        ),
        IconLabel(
          label: '!@#\$%^&',
          logic: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
              ? true
              : false,
        ),
        IconLabel(
          label: '+16 Lenght',
          logic: password.length >= 6 ? true : false,
        ),
      ],
      spacing: 8,
    );
  }
}

class IconLabel extends StatelessWidget {
  const IconLabel({
    Key key,
    @required this.label,
    @required this.logic,
  }) : super(key: key);

  final String label;
  final bool logic;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: logic
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.cancel, color: Colors.red),
      label: Text(
        label,
        style: TextStyle(
          color: logic ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
