import 'package:keyway/models/device.dart';

class Adress {
  int adressId;
  String protocol;
  String value;
  int port;
  int fkDeviceId;

  Device device;

  Adress.factory() {
    this.protocol = '';
    this.value = '';
    this.port = 0;
    this.device = Device();
  }

  Adress({
    this.adressId,
    this.protocol = '',
    this.value = '',
    this.port = 0,
    this.fkDeviceId,
    this.device,
  });

  Adress.fromMap(Map<String, dynamic> map) {
    adressId = map['adress_id'];
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
    if (adressId != null) map['adress_id'] = adressId;
    return map;
  }

  Adress clone() => Adress(
        adressId: this.adressId,
        protocol: this.protocol,
        value: this.value,
        port: this.port,
        fkDeviceId: this.fkDeviceId,
      );
}
