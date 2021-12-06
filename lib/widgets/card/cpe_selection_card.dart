import 'package:flutter/material.dart';

import 'package:keyway/models/api/nist/cpe.dart';

class CpeSelectionCard extends StatefulWidget {
  const CpeSelectionCard(this.cpe, this.addRemoveCpe);

  final Cpe? cpe;
  final Function addRemoveCpe;

  @override
  _CpeSelectionCardState createState() => _CpeSelectionCardState();
}

class _CpeSelectionCardState extends State<CpeSelectionCard> {
  bool _selected = false;

  void _onTap() {
    setState(() => _selected = !_selected);
    widget.addRemoveCpe(widget.cpe);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _selected ? 8.0 : 0.0,
      child: InkWell(
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.cpe!.titles![0].title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    if (_selected) Icon(Icons.check_circle, color: Colors.green)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Type'),
                    SizedBox(width: 8.0),
                    Text(
                      widget.cpe!.type,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Trademark'),
                    SizedBox(width: 8.0),
                    Text(
                      widget.cpe!.trademark,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Model'),
                    SizedBox(width: 8.0),
                    Flexible(
                      child: Text(
                        widget.cpe!.model,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (widget.cpe!.hasVulns)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bug_report, color: Colors.red),
                      Text(
                        'Vulnerabilities reported',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
