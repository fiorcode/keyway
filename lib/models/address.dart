import 'package:keyway/models/product.dart';

class Address {
  int addressId;
  String protocol;
  String value;
  int port;
  int fkProductId;

  Product product;

  Address.factory() {
    this.protocol = '';
    this.value = '';
    this.port = 0;
    this.product = Product();
  }

  Address({
    this.addressId,
    this.protocol = '',
    this.value = '',
    this.port = 0,
    this.fkProductId,
    this.product,
  });

  Address.fromMap(Map<String, dynamic> map) {
    addressId = map['address_id'];
    protocol = map['protocol'];
    value = map['value'];
    port = map['port'];
    fkProductId = map['fk_product_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'protocol': protocol,
      'value': value,
      'port': port,
      'fk_product_id': fkProductId,
    };
    if (addressId != null) map['address_id'] = addressId;
    return map;
  }

  Address clone() => Address(
        addressId: this.addressId,
        protocol: this.protocol,
        value: this.value,
        port: this.port,
        fkProductId: this.fkProductId,
      );
}
