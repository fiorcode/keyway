import 'package:flutter/material.dart';

import 'package:keyway/models/address.dart';

class AddressCard extends StatefulWidget {
  const AddressCard(
    this.address,
    this.addressCtrler,
    this.protocolCtrler,
    this.portCtrler,
  );

  final Address? address;
  final TextEditingController? addressCtrler;
  final TextEditingController? protocolCtrler;
  final TextEditingController? portCtrler;

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  Map<String, int> _protocols = {
    'https': 443,
    'sftp': 22,
    'ssh': 22,
    'smtp': 25,
    'http': 80,
    'telnet': 23,
    'dns': 53,
    'tftp': 69,
    'ldap': 389,
    'smb': 445,
  };
  TextInputType _type = TextInputType.url;
  bool _inputMode = false;
  int? _index;

  void _inputSwitch() {
    FocusScope.of(context).unfocus();
    setState(() => _type == TextInputType.url
        ? _type = TextInputType.number
        : _type = TextInputType.url);
  }

  void _inputModeSwitch() => setState(() {
        _inputMode = !_inputMode;
        widget.protocolCtrler!.clear();
        widget.portCtrler!.clear();
      });

  void _protocolSwitch() {
    setState(() {
      if (_index == _protocols.length - 1)
        _index = 0;
      else
        _index = _index! + 1;
    });
    _loadPresets();
  }

  void _loadPresets() {
    widget.address!.addressProtocol = _protocols.keys.elementAt(_index!);
    widget.address!.addressPort = _protocols.values.elementAt(_index!);
  }

  void _loadItemValues() {
    if (_protocols.containsKey(widget.address!.addressProtocol)) {
      int i = 0;
      _protocols.forEach((key, value) {
        if (key == widget.address!.addressProtocol) {
          _index = i;
        }
        i += 1;
      });
    } else {
      _inputMode = true;
    }
  }

  @override
  void initState() {
    if (widget.address!.addressProtocol!.isEmpty) {
      _index = 0;
      _loadPresets();
    } else {
      _loadItemValues();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              autocorrect: false,
              keyboardType: _type,
              controller: widget.addressCtrler,
              decoration: InputDecoration(
                hintText: 'Address',
                suffixIcon: _type == TextInputType.url
                    ? IconButton(
                        onPressed: _inputSwitch,
                        icon: Icon(Icons.dialpad_outlined, color: Colors.grey),
                      )
                    : IconButton(
                        onPressed: _inputSwitch,
                        icon: Icon(Icons.keyboard_outlined, color: Colors.grey),
                      ),
              ),
              textAlign: TextAlign.center,
              onChanged: (_) {},
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_inputMode)
                  IconButton(
                    onPressed: _protocolSwitch,
                    icon: Icon(Icons.change_circle_outlined,
                        color: Colors.grey, size: 32),
                  ),
                _inputMode
                    ? Container(
                        width: 128,
                        child: TextField(
                          autocorrect: false,
                          controller: widget.protocolCtrler,
                          decoration: InputDecoration(hintText: 'Protocol'),
                          textAlign: TextAlign.center,
                          onChanged: (_) {},
                        ),
                      )
                    : Text(
                        _protocols.keys.elementAt(_index!).toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                Text(
                  ' : ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                _inputMode
                    ? Container(
                        width: 64,
                        child: TextField(
                          autocorrect: false,
                          controller: widget.portCtrler,
                          decoration: InputDecoration(hintText: 'Port'),
                          textAlign: TextAlign.center,
                          onChanged: (_) {},
                        ),
                      )
                    : Text(
                        _protocols.values.elementAt(_index!).toString(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                IconButton(
                  onPressed: _inputModeSwitch,
                  icon: Icon(Icons.edit_outlined, color: Colors.grey, size: 32),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
