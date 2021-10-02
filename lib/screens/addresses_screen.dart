import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:keyway/providers/cripto_provider.dart';
import 'package:keyway/providers/item_provider.dart';
import 'package:keyway/models/address.dart';
import 'package:keyway/widgets/loading_scaffold.dart';

class AddressesScreen extends StatefulWidget {
  static const routeName = '/addresses';

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  ItemProvider _item;
  Future<List<Address>> _getAddresses;
  List<Address> _addresses;

  Future<void> _getAddressesAsync() async {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _addresses = await _item.fetchAddresses();
    await Future.forEach(_addresses, (a) async {
      await Provider.of<CriptoProvider>(context).decryptAddress(a);
    });
  }

  Future<void> _deleteAddress(Address a) async {
    _item = Provider.of<ItemProvider>(context, listen: false);
    await _item.deleteAddress(a);
    _getAddresses = _getAddressesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _getAddresses = _getAddressesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: FutureBuilder(
          future: _getAddresses,
          builder: (ctx, snap) {
            switch (snap.connectionState) {
              case ConnectionState.waiting:
                return LoadingScaffold();
                break;
              case ConnectionState.done:
                return ListView.builder(
                    padding: EdgeInsets.all(12.0),
                    itemCount: _addresses.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Text(_item.addresses[i].addressProtocol),
                          title: Text(_item.addresses[i].addressDec),
                          subtitle:
                              Text(_item.addresses[i].addressPort.toString()),
                          trailing: IconButton(
                            onPressed: () => _deleteAddress(_item.addresses[i]),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ),
                      );
                    });
              default:
                return Text('default');
            }
          }),
    );
  }
}
