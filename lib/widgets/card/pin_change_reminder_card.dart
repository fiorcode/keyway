import 'package:flutter/material.dart';

import '../../models/pin.dart';

class PinChangeReminderCard extends StatefulWidget {
  const PinChangeReminderCard({Key? key, this.pin}) : super(key: key);

  final Pin? pin;

  @override
  _PinChangeReminderCardState createState() => _PinChangeReminderCardState();
}

class _PinChangeReminderCardState extends State<PinChangeReminderCard> {
  bool _custom = false;

  @override
  void initState() {
    if (widget.pin!.pinLapse != 96 && widget.pin!.pinLapse != 320) {
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
          'PIN change reminder',
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
              selected: widget.pin!.pinLapse == 0,
              selectedColor: Colors.grey[200],
              onSelected: (selected) => selected
                  ? setState(() {
                      widget.pin!.pinLapse = 0;
                      _custom = false;
                    })
                  : null,
              label: Text(
                'Never',
                style: TextStyle(
                  color: widget.pin!.pinLapse == 0 ? Colors.grey : Colors.white,
                  fontWeight:
                      widget.pin!.pinLapse == 0 ? FontWeight.bold : null,
                ),
              ),
              elevation: widget.pin!.pinLapse == 0 ? 8.0 : 0.0,
            ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: widget.pin!.pinLapse == 96,
              selectedColor: Colors.grey[200],
              onSelected: (selected) => selected
                  ? setState(() {
                      widget.pin!.pinLapse = 96;
                      _custom = false;
                    })
                  : null,
              label: Text(
                '96 Days',
                style: TextStyle(
                  color:
                      widget.pin!.pinLapse == 96 ? Colors.grey : Colors.white,
                  fontWeight:
                      widget.pin!.pinLapse == 96 ? FontWeight.bold : null,
                ),
              ),
              elevation: widget.pin!.pinLapse == 96 ? 8.0 : 0.0,
            ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: widget.pin!.pinLapse == 320,
              selectedColor: Colors.grey[200],
              onSelected: (selected) => selected
                  ? setState(() {
                      widget.pin!.pinLapse = 320;
                      _custom = false;
                    })
                  : null,
              label: Text(
                '320 Days',
                style: TextStyle(
                  color:
                      widget.pin!.pinLapse == 320 ? Colors.grey : Colors.white,
                  fontWeight:
                      widget.pin!.pinLapse == 320 ? FontWeight.bold : null,
                ),
              ),
              elevation: widget.pin!.pinLapse == 320 ? 8.0 : 0.0,
            ),
            ChoiceChip(
              backgroundColor: Colors.grey,
              selected: _custom,
              selectedColor: Colors.grey[200],
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
                    widget.pin!.pinLapse.toString() + ' Days',
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
                      value: widget.pin!.pinLapse.toDouble(),
                      onChanged: (value) => setState(
                        () => widget.pin!.pinLapse = value.round(),
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
