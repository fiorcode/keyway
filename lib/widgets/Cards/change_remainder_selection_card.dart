import 'package:flutter/material.dart';

import 'package:keyway/models/alpha.dart';

class ChangeReminderSelectionCard extends StatefulWidget {
  const ChangeReminderSelectionCard({Key key, this.alpha}) : super(key: key);

  final Alpha alpha;

  @override
  _ChangeReminderSelectionCardState createState() =>
      _ChangeReminderSelectionCardState();
}

class _ChangeReminderSelectionCardState
    extends State<ChangeReminderSelectionCard> {
  bool _changeReminder = true;
  bool _custom = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Change reminder'),
                Switch(
                  activeColor: Colors.green,
                  value: _changeReminder,
                  onChanged: (value) => setState(() {
                    _changeReminder = value;
                    if (value)
                      widget.alpha.passwordLapse = 320;
                    else
                      widget.alpha.passwordLapse = -1;
                  }),
                ),
              ],
            ),
            if (_changeReminder)
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12.0,
                children: [
                  if (!_custom)
                    OutlinedButton(
                      onPressed: () => setState(() {
                        widget.alpha.passwordLapse = 32;
                        _custom = false;
                      }),
                      child: Text(
                        '32 Days',
                        style: TextStyle(
                          color: widget.alpha.passwordLapse == 32
                              ? Colors.grey
                              : Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.alpha.passwordLapse == 32
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  if (!_custom)
                    OutlinedButton(
                      onPressed: () => setState(() {
                        widget.alpha.passwordLapse = 96;
                        _custom = false;
                      }),
                      child: Text(
                        '96 Days',
                        style: TextStyle(
                          color: widget.alpha.passwordLapse == 96
                              ? Colors.grey
                              : Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.alpha.passwordLapse == 96
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  if (!_custom)
                    OutlinedButton(
                      onPressed: () => setState(() {
                        widget.alpha.passwordLapse = 192;
                        _custom = false;
                      }),
                      child: Text(
                        '192 Days',
                        style: TextStyle(
                          color: widget.alpha.passwordLapse == 192
                              ? Colors.grey
                              : Colors.white,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: widget.alpha.passwordLapse == 192
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  OutlinedButton(
                    onPressed: () => setState(() => _custom = !_custom),
                    child: Text('Custom'),
                  ),
                  if (_custom)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.alpha.passwordLapse} Days',
                          style: TextStyle(fontSize: 20),
                        ),
                        InkWell(
                          child: Icon(Icons.plus_one),
                          onTap: () => setState(
                            () {
                              widget.alpha.passwordLapse =
                                  widget.alpha.passwordLapse + 1;
                            },
                          ),
                          onLongPress: () => setState(
                            () {
                              widget.alpha.passwordLapse =
                                  widget.alpha.passwordLapse + 10;
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
