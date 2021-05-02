class Device {
  int deviceId;
  String type;
  String vendor;
  String product;
  String version;
  String updateCode;

  Device({
    this.deviceId,
    this.type = '',
    this.product = '',
    this.version = '',
    this.updateCode = '',
  });

  Device.fromMap(Map<String, dynamic> map) {
    deviceId = map['device_id'];
    type = map['type'];
    vendor = map['vendor'];
    product = map['product'];
    version = map['version'];
    updateCode = map['update_code'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'type': type,
      'vendor': vendor,
      'product': product,
      'version': version,
      'update_code': updateCode,
    };
    if (deviceId != null) map['device_id'] = deviceId;
    return map;
  }
}
