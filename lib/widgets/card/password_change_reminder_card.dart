import 'package:flutter/material.dart';

// import 'package:keyway/helpers/date_helper.dart';
import 'package:keyway/models/item_password.dart';

class PasswordChangeReminderCard extends StatefulWidget {
  const PasswordChangeReminderCard(this.itemPass, {Key? key}) : super(key: key);

  final ItemPassword itemPass;

  @override
  _PasswordChangeReminderCardState createState() =>
      _PasswordChangeReminderCardState();
}

class _PasswordChangeReminderCardState
    extends State<PasswordChangeReminderCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Password change reminder',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12.0,
          children: [
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: widget.itemPass.noLapse,
              selectedColor: Colors.grey[200],
              onSelected: (selected) => selected
                  ? setState(() => widget.itemPass.passwordLapse = 0)
                  : setState(() => widget.itemPass.passwordLapse = 320),
              label: Text(
                'Never',
                style: TextStyle(
                  color: widget.itemPass.noLapse ? Colors.grey : Colors.white,
                  fontWeight: widget.itemPass.noLapse ? FontWeight.bold : null,
                ),
              ),
              elevation: widget.itemPass.noLapse ? 8.0 : 0.0,
            ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: widget.itemPass.passwordLapse == 96,
              selectedColor: Colors.grey[200],
              onSelected: (selected) => selected
                  ? setState(() => widget.itemPass.passwordLapse = 96)
                  : setState(() => widget.itemPass.passwordLapse = 320),
              label: Text(
                '96 Days',
                style: TextStyle(
                  color: widget.itemPass.passwordLapse == 96
                      ? Colors.grey
                      : Colors.white,
                  fontWeight: widget.itemPass.passwordLapse == 96
                      ? FontWeight.bold
                      : null,
                ),
              ),
              elevation: widget.itemPass.passwordLapse == 96 ? 8.0 : 0.0,
            ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: widget.itemPass.passwordLapse == 320,
              selectedColor: Colors.grey[200],
              onSelected: (selected) => selected
                  ? setState(() => widget.itemPass.passwordLapse = 320)
                  : setState(() => widget.itemPass.passwordLapse = 0),
              label: Text(
                '320 Days',
                style: TextStyle(
                  color: widget.itemPass.passwordLapse == 320
                      ? Colors.grey
                      : Colors.white,
                  fontWeight: widget.itemPass.passwordLapse == 320
                      ? FontWeight.bold
                      : null,
                ),
              ),
              elevation: widget.itemPass.passwordLapse == 320 ? 8.0 : 0.0,
            ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: widget.itemPass.customLapse,
              selectedColor: Colors.grey[200],
              onSelected: (selected) {
                setState(() => widget.itemPass.passwordLapse = 1);
              },
              label: Text(
                'Custom',
                style: TextStyle(
                  color:
                      widget.itemPass.customLapse ? Colors.grey : Colors.white,
                  fontWeight:
                      widget.itemPass.customLapse ? FontWeight.bold : null,
                ),
              ),
              elevation: widget.itemPass.customLapse ? 8.0 : 0.0,
            ),
            if (widget.itemPass.customLapse)
              Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    widget.itemPass.passwordLapse.toString() + ' Days',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: 364,
                      value: widget.itemPass.passwordLapse!.toDouble(),
                      onChanged: (value) => setState(
                        () => widget.itemPass.passwordLapse = value.round(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
