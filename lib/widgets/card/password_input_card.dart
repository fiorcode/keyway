import 'package:flutter/material.dart';
import 'package:keyway/helpers/error_helper.dart';

import 'package:keyway/helpers/password_helper.dart';
import 'package:keyway/models/item.dart';
import 'package:keyway/widgets/card/password_add_edit_card.dart';
import 'package:keyway/widgets/card/strength_level_card.dart';
import 'package:keyway/widgets/text_field/password_text_field.dart';

class PasswordInputCard extends StatefulWidget {
  const PasswordInputCard(this.ctrler, this.item);

  final TextEditingController? ctrler;
  final Item? item;

  @override
  _PasswordInputCardState createState() => _PasswordInputCardState();
}

class _PasswordInputCardState extends State<PasswordInputCard> {
  bool _loadingRandomPass = false;

  Future<void> _loadRandomPassword() async {
    setState(() => _loadingRandomPass = true);
    widget.ctrler!.text = (await PasswordHelper.dicePassword()
            .onError((error, st) => ErrorHelper.errorDialog(context, error)))
        .password!;
    setState(() => _loadingRandomPass = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PasswordTextField(
                    widget.ctrler,
                    () => this.setState(() {}),
                  ),
                ),
                _loadingRandomPass
                    ? CircularProgressIndicator()
                    : IconButton(
                        icon: Icon(Icons.bolt),
                        onPressed: _loadRandomPassword,
                      ),
              ],
            ),
            if (widget.ctrler!.text.isNotEmpty)
              StrengthLevelCard(
                PasswordHelper.evaluate(
                  widget.ctrler!.text,
                  password: widget.item!.password,
                ),
              ),
            if (widget.ctrler!.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PasswordAddEditCard(widget.item!.itemPassword!),
              ),
            if (widget.ctrler!.text.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Password repeated warning',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Switch(
                      activeColor: Colors.green,
                      value: widget.item!.itemPassword!.repeatWarning,
                      onChanged: (_) => setState(() =>
                          widget.item!.itemPassword!.repeatWarningSwitch())),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
