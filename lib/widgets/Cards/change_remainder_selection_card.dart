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
                    ChoiceChip(
                      backgroundColor: Colors.grey,
                      selected: widget.alpha.passwordLapse == 32,
                      selectedColor: Colors.white,
                      onSelected: (selected) => selected
                          ? setState(() {
                              widget.alpha.passwordLapse = 32;
                              _custom = false;
                            })
                          : null,
                      label: Text(
                        '32 Days',
                        style: TextStyle(
                          color: widget.alpha.passwordLapse == 32
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: widget.alpha.passwordLapse == 32
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                      elevation: widget.alpha.passwordLapse == 32 ? 8.0 : 0.0,
                    ),
                  if (!_custom)
                    ChoiceChip(
                      backgroundColor: Colors.grey,
                      selected: widget.alpha.passwordLapse == 96,
                      selectedColor: Colors.white,
                      onSelected: (selected) => selected
                          ? setState(() {
                              widget.alpha.passwordLapse = 96;
                              _custom = false;
                            })
                          : null,
                      label: Text(
                        '96 Days',
                        style: TextStyle(
                          color: widget.alpha.passwordLapse == 96
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: widget.alpha.passwordLapse == 96
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                      elevation: widget.alpha.passwordLapse == 96 ? 8.0 : 0.0,
                    ),
                  if (!_custom)
                    ChoiceChip(
                      backgroundColor: Colors.grey,
                      selected: widget.alpha.passwordLapse == 192,
                      selectedColor: Colors.white,
                      onSelected: (selected) => selected
                          ? setState(() {
                              widget.alpha.passwordLapse = 192;
                              _custom = false;
                            })
                          : null,
                      label: Text(
                        '192 Days',
                        style: TextStyle(
                          color: widget.alpha.passwordLapse == 192
                              ? Colors.grey
                              : Colors.white,
                          fontWeight: widget.alpha.passwordLapse == 192
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                      elevation: widget.alpha.passwordLapse == 192 ? 8.0 : 0.0,
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
                          widget.alpha.passwordLapse.toString() + ' Days',
                          style: TextStyle(fontSize: 32),
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
                            value: widget.alpha.passwordLapse.toDouble(),
                            onChanged: (value) => setState(
                              () => widget.alpha.passwordLapse = value.round(),
                            ),
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
