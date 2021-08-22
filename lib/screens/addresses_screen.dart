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
  Future<void> _getAddresses;

  Future<void> _getAddressesAsync() => _item.fetchAddresses();

  Future<void> _deleteAddress(Address a) async {
    await _item.deleteAddress(a);
    _getAddresses = _getAddressesAsync();
    setState(() {});
  }

  @override
  void initState() {
    _item = Provider.of<ItemProvider>(context, listen: false);
    _getAddresses = _getAddressesAsync();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CriptoProvider _cripto =
        Provider.of<CriptoProvider>(context, listen: false);
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
                    itemCount: _item.addresses.length,
                    itemBuilder: (ctx, i) {
                      return Card(
                        child: ListTile(
                          leading: Text(_item.addresses[i].addressProtocol),
                          title:
                              Text(_cripto.decryptAddress(_item.addresses[i])),
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
