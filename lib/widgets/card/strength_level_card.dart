import 'package:flutter/material.dart';

class StrengthLevelCard extends StatelessWidget {
  StrengthLevelCard(this.score);

  final int? score;

  Color _shadowColor() {
    switch (score) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: _shadowColor(),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: score == 0 ? Colors.red : Colors.red[200],
                border: score == 0
                    ? Border.all(width: 2, color: Colors.red[600]!)
                    : null,
              ),
              height: 32,
              padding: EdgeInsets.all(2),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'VERY\nWEAK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: score == 0 ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: score == 1 ? Colors.orange : Colors.orange[200],
                border: score == 1
                    ? Border.all(
                        width: 2,
                        color: Colors.orange[600]!,
                      )
                    : null,
              ),
              height: 32,
              padding: EdgeInsets.all(2),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'WEAK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: score == 1 ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: score == 2 ? Colors.yellow : Colors.yellow[200],
                border: score == 2
                    ? Border.all(
                        width: 2,
                        color: Colors.yellow[600]!,
                      )
                    : null,
              ),
              height: 32,
              padding: EdgeInsets.all(2),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'REGULAR',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: score == 2 ? Colors.grey : Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: score == 3 ? Colors.lightGreen : Colors.lightGreen[200],
                border: score == 3
                    ? Border.all(
                        width: 2,
                        color: Colors.lightGreen[600]!,
                      )
                    : null,
              ),
              height: 32,
              padding: EdgeInsets.all(2),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'STRONG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: score == 3 ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: score == 4 ? Colors.green : Colors.green[200],
                border: score == 4
                    ? Border.all(
                        width: 2,
                        color: Colors.green[600]!,
                      )
                    : null,
              ),
              height: 32,
              padding: EdgeInsets.all(2),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'VERY\nSTRONG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: score == 4 ? Colors.white : Colors.white38,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
