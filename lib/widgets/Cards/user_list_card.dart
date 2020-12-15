import 'dart:ui';
import 'package:flutter/material.dart';

class UserListCard extends StatelessWidget {
  const UserListCard(this.ctrler, this.function, this.list);

  final TextEditingController ctrler;
  final Function function;
  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(64),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: 8,
              shape: RoundedRectangleBorder(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: Icon(Icons.close_rounded), onPressed: () {}),
                  Expanded(
                    child: ListView(
                      children: [...list.map((e) => Text(e))],
                      // children: [
                      //   Text('One'),
                      //   Text('Two'),
                      //   Text('Three'),
                      //   Text('Four'),
                      //   Text('Five'),
                      //   Text('Six'),
                      // ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
