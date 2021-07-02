import 'package:flutter/material.dart';

import 'package:keyway/models/cpe.dart';

class CpeSelectionCard extends StatefulWidget {
  const CpeSelectionCard(this.cpe);

  final Cpe cpe;

  @override
  _CpeSelectionCardState createState() => _CpeSelectionCardState();
}

class _CpeSelectionCardState extends State<CpeSelectionCard> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.cpe.titles[0].title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    widget.cpe.cpe23Uri,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child:
                        Text('Last modified: ${widget.cpe.lastModifiedDate}'),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: _selected,
              onChanged: (selected) => setState(() => _selected = selected),
              checkColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
