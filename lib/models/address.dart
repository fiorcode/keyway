class Address {
  int addressId;
  String addressEnc;
  String addressIv;
  String addressProtocol;
  int addressPort;

  Address.factory() {
    this.addressEnc = '';
    this.addressIv = '';
    this.addressProtocol = 'https';
    this.addressPort = 443;
  }

  Address({
    this.addressId,
    this.addressEnc = '',
    this.addressIv = '',
    this.addressProtocol = 'https',
    this.addressPort = 443,
  });

  Address.fromMap(Map<String, dynamic> map) {
    addressId = map['address_id'];
    addressEnc = map['address_enc'];
    addressIv = map['address_iv'];
    addressProtocol = map['address_protocol'];
    addressPort = map['address_port'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'address_enc': addressEnc,
      'address_iv': addressIv,
      'address_protocol': addressProtocol,
      'address_port': addressPort,
    };
    if (addressId != null) map['address_id'] = addressId;
    return map;
  }

  Address clone() => Address(
        addressId: this.addressId,
        addressEnc: this.addressEnc,
        addressIv: this.addressIv,
        addressProtocol: this.addressProtocol,
        addressPort: this.addressPort,
      );
}
