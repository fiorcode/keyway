import 'package:flutter/material.dart';

class TagChip extends StatefulWidget {
  TagChip(this.label, this.selected);

  final String label;
  final bool selected;
  @override
  _TagChipState createState() => _TagChipState();
}

class _TagChipState extends State<TagChip> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: widget.selected ? Colors.white : Colors.grey,
      label: Text(widget.label),
    );
  }
}
