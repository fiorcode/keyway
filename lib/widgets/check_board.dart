import 'package:flutter/material.dart';

import '../helpers/password_helper.dart';

class CheckBoard extends StatelessWidget {
  CheckBoard({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        IconLabel(
          label: 'a-z',
          logic: PasswordHelper.hasLow(password),
        ),
        IconLabel(
          label: 'A-Z',
          logic: PasswordHelper.hasUpp(password),
        ),
        IconLabel(
          label: '0-9',
          logic: PasswordHelper.hasNum(password),
        ),
        IconLabel(
          label: '!@#%&<>',
          logic: PasswordHelper.hasSpec(password),
        ),
        IconLabel(
          label: '+16 Lenght',
          logic: PasswordHelper.minLong(password),
        ),
      ],
      spacing: 8,
    );
  }
}

class IconLabel extends StatelessWidget {
  const IconLabel({
    Key? key,
    required this.label,
    required this.logic,
  }) : super(key: key);

  final String label;
  final bool logic;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: logic
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.cancel, color: Colors.red),
      backgroundColor: logic ? Colors.green[100] : Colors.red[100],
      label: Text(
        label,
        style: TextStyle(
          color: logic ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
