import 'package:flutter/material.dart';
import 'package:keyway/helpers/date_helper.dart';

class ItemViewContainer extends StatelessWidget {
  const ItemViewContainer(this.title, this.content,
      {this.date = '', this.lapse = 0});

  final String title;
  final String content;
  final String date;
  final int lapse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 92,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3.0,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: date.isNotEmpty
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              date.isNotEmpty
                  ? Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        color: Colors.black,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            DateHelper.ddMMyyyy(date),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Expanded(child: Container()),
              Container(width: 32),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 4,
                  ),
                  color: Colors.black,
                  child: Text(
                    this.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Container(width: 32),
              DateHelper.expired(date, lapse)
                  ? Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                        color: Colors.red,
                        child: Text(
                          'Expired',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    )
                  : Expanded(child: Container()),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                this.content,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
