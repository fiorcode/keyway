import 'package:flutter/material.dart';
import 'package:keyway/helpers/date_helper.dart';

class ItemViewContainer extends StatelessWidget {
  const ItemViewContainer(this.title, this.content,
      {this.left = '', this.right = 0});

  final String title;
  final String? content;
  final String? left;
  final int? right;

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
          Container(
            height: 24,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: left!.isNotEmpty
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Expanded(
                  child: left!.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.all(2),
                          color: Colors.black,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            clipBehavior: Clip.hardEdge,
                            child: Text(
                              this.title == 'address'
                                  ? this.left!
                                  : DateHelper.ddMMyyyy(left),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      : Container(),
                ),
                Container(width: 32),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    color: Colors.black,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      clipBehavior: Clip.hardEdge,
                      child: Text(
                        this.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(width: 32),
                if (this.title == 'address')
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      color: Colors.black,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        clipBehavior: Clip.hardEdge,
                        child: Text(
                          this.right.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                if (this.title != 'address')
                  Expanded(
                    child: DateHelper.expired(left, right)
                        ? Container(
                            padding: EdgeInsets.all(2),
                            color: Colors.red,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              clipBehavior: Clip.hardEdge,
                              child: Text(
                                'expired',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                  )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                this.content!,
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
