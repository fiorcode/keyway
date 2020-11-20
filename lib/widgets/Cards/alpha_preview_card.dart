import 'package:flutter/material.dart';
import 'package:keyway/widgets/grey_scale_picker.dart';

import '../../models/item.dart';
import '../color_picker.dart';

class AlphaPreviewCard extends StatefulWidget {
  AlphaPreviewCard(this.alpha);

  final Alpha alpha;

  @override
  _AlphaPreviewCardState createState() => _AlphaPreviewCardState();
}

class _AlphaPreviewCardState extends State<AlphaPreviewCard> {
  _setColor(int color) {
    setState(() {
      widget.alpha.color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          shadowColor: widget.alpha.repeated == 'y'
              ? Colors.red
              : widget.alpha.expired == 'y'
                  ? Colors.orange
                  : Colors.green,
          elevation: 8,
          shape: StadiumBorder(),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.all(4),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor:
                  widget.alpha.color == null || widget.alpha.color == 0
                      ? Colors.grey
                      : Color(widget.alpha.color),
              child: Text(
                widget.alpha.title != null ?? widget.alpha.title.isNotEmpty
                    ? widget.alpha.title.substring(0, 1).toUpperCase()
                    : 'T',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              widget.alpha.title != null ? widget.alpha.title : 'Title',
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
                      child: Icon(
                        Icons.copy,
                        color: Colors.green,
                        size: 24,
                      ),
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
                      child: Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.green,
                        size: 24,
                      ),
                      heroTag: null,
                      onPressed: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        ColorPicker(widget.alpha.color, _setColor),
        SizedBox(height: 12),
        GreyScalePicker(widget.alpha.color, _setColor),
      ],
    );
  }
}
