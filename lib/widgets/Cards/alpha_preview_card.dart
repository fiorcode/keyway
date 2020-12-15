import 'package:flutter/material.dart';

import '../../models/item.dart';
import '../color_alpha_picker.dart';
import '../red_color_picker.dart';
import '../green_color_picker.dart';
import '../blue_color_picker.dart';

class AlphaPreviewCard extends StatefulWidget {
  AlphaPreviewCard(this.alpha);

  final Alpha alpha;

  @override
  _AlphaPreviewCardState createState() => _AlphaPreviewCardState();
}

class _AlphaPreviewCardState extends State<AlphaPreviewCard> {
  Color _color;

  _setColor(int color) {
    setState(() => _color = Color(color));
    widget.alpha.color = color;
  }

  @override
  void initState() {
    if (_color == null) _color = Color(widget.alpha.color);
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
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 8,
              shape: StadiumBorder(),
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(4),
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: _color == null ? Colors.grey : _color,
                  child: Text(
                    widget.alpha.title.isEmpty
                        ? 'T'
                        : widget.alpha.title.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  widget.alpha.title.isEmpty ? 'Title' : widget.alpha.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                onTap: null,
                trailing: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: FloatingActionButton(
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.copy, size: 24),
                          heroTag: null,
                          onPressed: null,
                        ),
                      ),
                      SizedBox(width: 4),
                      SizedBox(
                        height: 48,
                        width: 48,
                        child: FloatingActionButton(
                          backgroundColor: Colors.grey[200],
                          child: Icon(Icons.remove_red_eye_outlined, size: 24),
                          heroTag: null,
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: 24),
            // ColorPicker(widget.alpha.color, _setColor),
            SizedBox(height: 12),
            RedColorPicker(_color, _setColor),
            SizedBox(height: 12),
            GreenColorPicker(_color, _setColor),
            SizedBox(height: 12),
            BlueColorPicker(_color, _setColor),
            SizedBox(height: 12),
            ColorAlphaPicker(_color, _setColor)
            // GreyScalePicker(widget.alpha.color, _setColor),
          ],
        ),
      ),
    );
  }
}
