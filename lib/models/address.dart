import 'package:keyway/models/device.dart';

class Address {
  int addressId;
  String protocol;
  String value;
  int port;
  int fkDeviceId;

  Device device;

  Address.factory() {
    this.protocol = '';
    this.value = '';
    this.port = 0;
    this.device = Device();
  }

  Address({
    this.addressId,
    this.protocol = '',
    this.value = '',
    this.port = 0,
    this.fkDeviceId,
    this.device,
  });

  Address.fromMap(Map<String, dynamic> map) {
    addressId = map['address_id'];
    protocol = map['protocol'];
    value = map['value'];
    port = map['port'];
    fkDeviceId = map['fk_device_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'protocol': protocol,
      'value': value,
      'port': port,
      'fk_device_id': fkDeviceId,
    };
    if (addressId != null) map['address_id'] = addressId;
    return map;
  }

  Address clone() => Address(
        addressId: this.addressId,
        protocol: this.protocol,
        value: this.value,
        port: this.port,
        fkDeviceId: this.fkDeviceId,
      );
}
