import 'package:flutter/material.dart';

import 'package:keyway/helpers/date_helper.dart';
import 'package:keyway/models/item_password.dart';

class PasswordChangeReminderCard extends StatefulWidget {
  const PasswordChangeReminderCard({Key key, this.itemPass}) : super(key: key);

  final ItemPassword itemPass;

  @override
  _PasswordChangeReminderCardState createState() =>
      _PasswordChangeReminderCardState();
}

class _PasswordChangeReminderCardState
    extends State<PasswordChangeReminderCard> {
  bool _changeReminder = true;
  bool _custom = false;

  @override
  void initState() {
    if (widget.itemPass.lapse != 32 &&
        widget.itemPass.lapse != 96 &&
        widget.itemPass.lapse != 192) {
      _custom = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 3,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              activeColor: Colors.green,
              value: _changeReminder,
              onChanged: (value) => setState(() {
                _changeReminder = value;
                if (value) {
                  _custom = false;
                  widget.itemPass.lapse = 192;
                } else {
                  widget.itemPass.lapse = -1;
                }
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Password change reminder',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            if (_changeReminder)
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12.0,
                children: [
                  if (!_custom)
                    ChoiceChip(
                      backgroundColor: Colors.grey,
                      selected: widget.itemPass.lapse == 32,
                      selectedColor: Colors.white,
                      onSelected: (selected) => selected
                          ? setState(() {
                              widget.itemPass.lapse = 32;
                              _custom = false;
                            })
                          : null,
                      label: Text(
                        '32 Days',
                        style: TextStyle(
                          color: widget.itemPass.lapse == 32
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: widget.itemPass.lapse == 32
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                      elevation: widget.itemPass.lapse == 32 ? 8.0 : 0.0,
                    ),
                  if (!_custom)
                    ChoiceChip(
                      backgroundColor: Colors.grey,
                      selected: widget.itemPass.lapse == 96,
                      selectedColor: Colors.white,
                      onSelected: (selected) => selected
                          ? setState(() {
                              widget.itemPass.lapse = 96;
                              _custom = false;
                            })
                          : null,
                      label: Text(
                        '96 Days',
                        style: TextStyle(
                          color: widget.itemPass.lapse == 96
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: widget.itemPass.lapse == 96
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                      elevation: widget.itemPass.lapse == 96 ? 8.0 : 0.0,
                    ),
                  if (!_custom)
                    ChoiceChip(
                      backgroundColor: Colors.grey,
                      selected: widget.itemPass.lapse == 192,
                      selectedColor: Colors.white,
                      onSelected: (selected) => selected
                          ? setState(() {
                              widget.itemPass.lapse = 192;
                              _custom = false;
                            })
                          : null,
                      label: Text(
                        '192 Days',
                        style: TextStyle(
                          color: widget.itemPass.lapse == 192
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: widget.itemPass.lapse == 192
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                      elevation: widget.itemPass.lapse == 192 ? 8.0 : 0.0,
                    ),
                  ChoiceChip(
                    backgroundColor: Colors.grey,
                    selected: _custom,
                    selectedColor: Colors.white,
                    onSelected: (selected) =>
                        setState(() => _custom = selected),
                    label: Text(
                      'Custom',
                      style: TextStyle(
                        color: _custom ? Colors.grey : Colors.white,
                        fontWeight: _custom ? FontWeight.bold : null,
                      ),
                    ),
                    elevation: _custom ? 8.0 : 0.0,
                  ),
                  if (_custom)
                    Column(
                      children: [
                        SizedBox(height: 8),
                        Text(
                          widget.itemPass.lapse.toString() + ' Days',
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
                            value: widget.itemPass.lapse.toDouble(),
                            onChanged: (value) => setState(
                              () => widget.itemPass.lapse = value.round(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Created: ' +
                        DateHelper.shortDate(widget.itemPass.dateTime),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
