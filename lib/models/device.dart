class Device {
  int deviceId;
  String type;
  String vendor;
  String product;
  String version;
  String updateCode;
  int fkCpe23uriId;

  Device({
    this.deviceId,
    this.type = '',
    this.vendor = '',
    this.product = '',
    this.version = '',
    this.updateCode = '',
    this.fkCpe23uriId,
  });

  Device.fromMap(Map<String, dynamic> map) {
    deviceId = map['device_id'];
    type = map['type'];
    vendor = map['vendor'];
    product = map['product'];
    version = map['version'];
    updateCode = map['update_code'];
    fkCpe23uriId = map['fk_cpe23uri_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'type': type,
      'vendor': vendor,
      'product': product,
      'version': version,
      'update_code': updateCode,
      'fk_cpe23uri_id': fkCpe23uriId,
    };
    if (deviceId != null) map['device_id'] = deviceId;
    return map;
  }

  Device clone() => Device(
        deviceId: this.deviceId,
        type: this.type,
        vendor: this.vendor,
        product: this.product,
        version: this.version,
        updateCode: this.updateCode,
        fkCpe23uriId: this.fkCpe23uriId,
      );
}
