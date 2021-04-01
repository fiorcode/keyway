import 'package:flutter/material.dart';

import 'package:keyway/models/alpha.dart';
import '../Pickers/color_alpha_picker.dart';
import '../Pickers/letter_blue_color_picker.dart';
import '../Pickers/letter_color_alpha_picker.dart';
import '../Pickers/letter_green_color_picker.dart';
import '../Pickers/letter_red_color_picker.dart';
import '../Pickers/red_color_picker.dart';
import '../Pickers/green_color_picker.dart';
import '../Pickers/blue_color_picker.dart';

class AlphaPreviewCard extends StatefulWidget {
  AlphaPreviewCard(this.alpha);

  final Alpha alpha;

  @override
  _AlphaPreviewCardState createState() => _AlphaPreviewCardState();
}

class _AlphaPreviewCardState extends State<AlphaPreviewCard> {
  Color _fillColor = Colors.grey;
  Color _fontColor = Colors.white;
  bool _editingBackground = true;

  _setFillColor(int color) {
    widget.alpha.color = color;
    setState(() => _fillColor = Color(color));
  }

  _setFontColor(int color) {
    widget.alpha.colorLetter = color;
    setState(() => _fontColor = Color(color));
  }

  void _editingSwitch() =>
      setState(() => _editingBackground = !_editingBackground);

  @override
  void initState() {
    if (widget.alpha.color >= 0) _fillColor = Color(widget.alpha.color);
    if (widget.alpha.colorLetter >= 0)
      _fontColor = Color(widget.alpha.colorLetter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 3,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.format_color_fill,
                        color: _editingBackground ? Colors.grey : Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 4.0,
                        primary:
                            _editingBackground ? Colors.white : Colors.grey,
                      ),
                      label: Text(
                        'Fill',
                        style: TextStyle(
                          color:
                              _editingBackground ? Colors.grey : Colors.white,
                        ),
                      ),
                      onPressed: _editingBackground ? () {} : _editingSwitch,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.format_color_text,
                        color: !_editingBackground ? Colors.grey : Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: !_editingBackground ? 4.0 : 0,
                        primary:
                            !_editingBackground ? Colors.white : Colors.grey,
                      ),
                      label: Text(
                        'Font Color',
                        style: TextStyle(
                          color:
                              !_editingBackground ? Colors.grey : Colors.white,
                        ),
                      ),
                      onPressed: !_editingBackground ? () {} : _editingSwitch,
                    ),
                  ),
                ),
              ],
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 8,
              shape: StadiumBorder(),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(4),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: _fillColor,
                  child: Text(
                    widget.alpha.title.isEmpty
                        ? 'T'
                        : widget.alpha.title.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: _fontColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  widget.alpha.title.isEmpty ? 'Title' : widget.alpha.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                onTap: null,
                trailing: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: FloatingActionButton(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        size: 24,
                        color: Colors.grey,
                      ),
                      heroTag: null,
                      onPressed: null,
                    ),
                  ),
                ),
              ),
            ),
            _editingBackground
                ? RedColorPicker(_fillColor, _setFillColor)
                : LetterRedColorPicker(_fontColor, _setFontColor),
            _editingBackground
                ? GreenColorPicker(_fillColor, _setFillColor)
                : LetterGreenColorPicker(_fontColor, _setFontColor),
            _editingBackground
                ? BlueColorPicker(_fillColor, _setFillColor)
                : LetterBlueColorPicker(_fontColor, _setFontColor),
            _editingBackground
                ? ColorAlphaPicker(_fillColor, _setFillColor)
                : LetterColorAlphaPicker(_fontColor, _setFontColor),
          ],
        ),
      ),
    );
  }
}
