import 'package:flutter/material.dart';

import 'package:keyway/models/address.dart';

class AddressCard extends StatefulWidget {
  const AddressCard(
    this.address,
    this.addressCtrler,
    this.protocolCtrler,
    this.portCtrler,
  );

  final Address address;
  final TextEditingController addressCtrler;
  final TextEditingController protocolCtrler;
  final TextEditingController portCtrler;

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  Map<String, int> _protocols = {
    'HTTPS': 443,
    'SFTP': 22,
    'SSH': 22,
    'SMTP': 25,
    'HTTP': 80,
    'Telnet': 23,
    'DNS': 53,
    'TFTP': 69,
    'LDAP': 389,
    'SMB': 445,
  };

  TextInputType _type = TextInputType.url;
  bool _inputMode = false;
  int _protocolIndex = 0;

  //TODO: onChange functions

  void _inputSwitch() {
    FocusScope.of(context).unfocus();
    setState(() => _type == TextInputType.url
        ? _type = TextInputType.number
        : _type = TextInputType.url);
  }

  void _inputModeSwitch() => setState(() => _inputMode = !_inputMode);

  void _protocolSwitch() {
    setState(() {
      if (_protocolIndex == _protocols.length - 1)
        _protocolIndex = 0;
      else
        _protocolIndex += 1;
    });
    widget.protocolCtrler.text = _protocols.keys.elementAt(_protocolIndex);
    widget.address.addressProtocol = widget.protocolCtrler.text.toLowerCase();
    widget.portCtrler.text =
        _protocols.values.elementAt(_protocolIndex).toString();
    widget.address.addressPort = int.parse(widget.portCtrler.text);
  }

  @override
  void initState() {
    widget.protocolCtrler.text = _protocols.keys.elementAt(_protocolIndex);
    widget.address.addressProtocol = widget.protocolCtrler.text.toLowerCase();
    widget.portCtrler.text =
        _protocols.values.elementAt(_protocolIndex).toString();
    widget.address.addressPort = int.parse(widget.portCtrler.text);
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
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_inputMode)
                  IconButton(
                    onPressed: _protocolSwitch,
                    icon: Icon(Icons.change_circle_outlined,
                        color: Colors.grey, size: 32),
                  ),
                Text(
                  'Protocol',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
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
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          backgroundColor: Colors.grey,
                          selected: true,
                          selectedColor: Colors.grey[200],
                          onSelected: (_) {},
                          label: Text(
                            _protocols.keys.elementAt(_protocolIndex),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          elevation: 8.0,
                        ),
                      ),
                Text(
                  'Port',
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
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          backgroundColor: Colors.grey,
                          selected: true,
                          selectedColor: Colors.grey[200],
                          onSelected: (_) {},
                          label: Text(
                            _protocols.values
                                .elementAt(_protocolIndex)
                                .toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          elevation: 8.0,
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
