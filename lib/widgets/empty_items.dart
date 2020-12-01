import 'dart:math';

import 'package:flutter/material.dart';

class EmptyItems extends StatelessWidget {
  List<Widget> _characters() {
    List<Widget> _list = List<Widget>();
    double _randomDouble;
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@';
    for (int i = 0; i < 129; i++) {
      _randomDouble = Random().nextDouble() * 64;
      _list.add(
        Text(
          _chars.substring(_randomDouble.toInt(), _randomDouble.toInt() + 1),
          style: TextStyle(fontSize: _randomDouble + 12, color: Colors.black12),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      );
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _characters(),
          ),
          Image.asset(
            'assets/empty.png',
            width: MediaQuery.of(context).size.width * .6,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
