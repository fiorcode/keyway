import 'package:flutter/material.dart';

class PresetsWrap extends StatelessWidget {
  const PresetsWrap({
    Key key,
    @required this.username,
    @required this.password,
    @required this.pin,
    @required this.device,
    @required this.longText,
    @required this.usernameSwitch,
    @required this.passwordSwitch,
    @required this.pinSwitch,
    @required this.longTextSwitch,
    @required this.deviceSwitch,
  }) : super(key: key);

  final bool username;
  final bool password;
  final bool pin;
  final bool device;
  final bool longText;
  final Function usernameSwitch;
  final Function passwordSwitch;
  final Function pinSwitch;
  final Function longTextSwitch;
  final Function deviceSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              backgroundColor: username ? Colors.white : Colors.grey,
              child: Icon(
                Icons.account_circle,
                size: username ? 32 : 24,
                color: username ? Colors.grey : Colors.white,
              ),
              elevation: username ? 8 : 0,
              heroTag: null,
              onPressed: usernameSwitch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              backgroundColor: password ? Colors.white : Colors.grey,
              child: Text(
                '*',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: password ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: password ? Colors.grey : Colors.white,
                ),
              ),
              elevation: password ? 8 : 0,
              heroTag: null,
              onPressed: passwordSwitch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              backgroundColor: pin ? Colors.white : Colors.grey,
              child: Icon(
                Icons.dialpad,
                size: pin ? 32 : 24,
                color: pin ? Colors.grey : Colors.white,
              ),
              elevation: pin ? 8 : 0,
              heroTag: null,
              onPressed: pinSwitch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              backgroundColor: longText ? Colors.white : Colors.grey,
              child: Icon(
                Icons.notes_rounded,
                size: longText ? 32 : 24,
                color: longText ? Colors.grey : Colors.white,
              ),
              elevation: longText ? 8 : 0,
              heroTag: null,
              onPressed: longTextSwitch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              backgroundColor: device ? Colors.white : Colors.grey,
              child: Icon(
                Icons.router,
                size: device ? 32 : 24,
                color: device ? Colors.grey : Colors.white,
              ),
              elevation: device ? 8 : 0,
              heroTag: null,
              onPressed: deviceSwitch,
            ),
          ),
        ],
      ),
    );
  }
}
