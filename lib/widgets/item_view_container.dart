import 'package:flutter/material.dart';

class ItemViewContainer extends StatelessWidget {
  const ItemViewContainer(this.title, this.content);

  final String title;
  final String content;

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
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 4,
            ),
            color: Colors.black,
            child: Text(
              this.title,
              style: TextStyle(color: Colors.white),
            ),
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
