import 'package:flutter/material.dart';

// import 'package:keyway/helpers/date_helper.dart';
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
  bool _custom = false;

  @override
  void initState() {
    if (widget.itemPass.lapse != 96 && widget.itemPass.lapse != 320) {
      _custom = true;
    }
    super.initState();
  }

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
            if (!_custom)
              ChoiceChip(
                backgroundColor: Colors.grey,
                selected: widget.itemPass.lapse == -1,
                selectedColor: Colors.white,
                onSelected: (selected) => selected
                    ? setState(() {
                        widget.itemPass.lapse = -1;
                        _custom = false;
                      })
                    : null,
                label: Text(
                  'Never',
                  style: TextStyle(
                    color: widget.itemPass.lapse == -1
                        ? Colors.grey
                        : Colors.white,
                    fontWeight:
                        widget.itemPass.lapse == -1 ? FontWeight.bold : null,
                  ),
                ),
                elevation: widget.itemPass.lapse == -1 ? 8.0 : 0.0,
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
                    fontWeight:
                        widget.itemPass.lapse == 96 ? FontWeight.bold : null,
                  ),
                ),
                elevation: widget.itemPass.lapse == 96 ? 8.0 : 0.0,
              ),
            if (!_custom)
              ChoiceChip(
                backgroundColor: Colors.grey,
                selected: widget.itemPass.lapse == 320,
                selectedColor: Colors.white,
                onSelected: (selected) => selected
                    ? setState(() {
                        widget.itemPass.lapse = 320;
                        _custom = false;
                      })
                    : null,
                label: Text(
                  '320 Days',
                  style: TextStyle(
                    color: widget.itemPass.lapse == 320
                        ? Colors.grey
                        : Colors.white,
                    fontWeight:
                        widget.itemPass.lapse == 320 ? FontWeight.bold : null,
                  ),
                ),
                elevation: widget.itemPass.lapse == 320 ? 8.0 : 0.0,
              ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: _custom,
              selectedColor: Colors.white,
              onSelected: (selected) => setState(() => _custom = selected),
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
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Icon(Icons.calendar_today),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Text(
        //         'Created: ' + DateHelper.shortDate(widget.itemPass.dateTime),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
