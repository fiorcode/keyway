import 'package:flutter/material.dart';

import '../../models/item.dart';
import '../picker/red_color_picker.dart';
import '../picker/green_color_picker.dart';
import '../picker/blue_color_picker.dart';
import '../picker/color_alpha_picker.dart';
import '../picker/letter_red_color_picker.dart';
import '../picker/letter_green_color_picker.dart';
import '../picker/letter_blue_color_picker.dart';
import '../picker/letter_color_alpha_picker.dart';

class ItemPreviewCard extends StatefulWidget {
  ItemPreviewCard(this.item);

  final Item? item;

  @override
  _ItemPreviewCardState createState() => _ItemPreviewCardState();
}

class _ItemPreviewCardState extends State<ItemPreviewCard> {
  Color _fillColor = Colors.grey;
  Color _fontColor = Colors.white;
  bool _setting = false;
  bool _editingBackground = true;

  _setFillColor(int color) {
    widget.item!.avatarColor = color;
    setState(() => _fillColor = Color(color));
  }

  _setFontColor(int color) {
    widget.item!.avatarLetterColor = color;
    setState(() => _fontColor = Color(color));
  }

  void _editingSwitch() =>
      setState(() => _editingBackground = !_editingBackground);

  @override
  void initState() {
    if (widget.item!.avatarColor! >= 0)
      _fillColor = Color(widget.item!.avatarColor!);
    if (widget.item!.avatarLetterColor! >= 0)
      _fontColor = Color(widget.item!.avatarLetterColor!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Preview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
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
                widget.item!.title.isEmpty
                    ? 'T'
                    : widget.item!.title.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: _fontColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.item!.title.isEmpty ? 'Title' : widget.item!.title,
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
                  child: Icon(Icons.tune, size: 24, color: Colors.grey),
                  heroTag: null,
                  onPressed: () => setState(() => _setting = !_setting),
                ),
              ),
            ),
          ),
        ),
        if (_setting)
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
                      primary: _editingBackground ? Colors.white : Colors.grey,
                    ),
                    label: Text(
                      'Fill',
                      style: TextStyle(
                        color: _editingBackground ? Colors.grey : Colors.white,
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
                      primary: !_editingBackground ? Colors.white : Colors.grey,
                    ),
                    label: Text(
                      'Font',
                      style: TextStyle(
                        color: !_editingBackground ? Colors.grey : Colors.white,
                      ),
                    ),
                    onPressed: !_editingBackground ? () {} : _editingSwitch,
                  ),
                ),
              ),
            ],
          ),
        if (_setting)
          _editingBackground
              ? RedColorPicker(_fillColor, _setFillColor)
              : LetterRedColorPicker(_fontColor, _setFontColor),
        if (_setting)
          _editingBackground
              ? GreenColorPicker(_fillColor, _setFillColor)
              : LetterGreenColorPicker(_fontColor, _setFontColor),
        if (_setting)
          _editingBackground
              ? BlueColorPicker(_fillColor, _setFillColor)
              : LetterBlueColorPicker(_fontColor, _setFontColor),
        if (_setting)
          _editingBackground
              ? ColorAlphaPicker(_fillColor, _setFillColor)
              : LetterColorAlphaPicker(_fontColor, _setFontColor),
      ],
    );
  }
}
