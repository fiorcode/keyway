class Pin {
  int pinId;
  String pinEnc;
  String pinIv;
  String pinDate;
  int pinLapse;
  String pinStatus;
  DateTime dateTime;

  Pin({
    this.pinId,
    this.pinEnc = '',
    this.pinIv = '',
    this.pinDate,
    this.pinLapse = 320,
    this.pinStatus = '',
  });

  Pin.fromMap(Map<String, dynamic> map) {
    pinId = map['pin_id'];
    pinEnc = map['pin_enc'];
    pinIv = map['pin_iv'];
    pinDate = map['pin_date'];
    pinLapse = map['pin_lapse'];
    pinStatus = map['pin_status'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'pin_enc': pinEnc,
      'pin_iv': pinIv,
      'pin_date': pinDate,
      'pin_lapse': pinLapse,
      'pin_status': pinStatus,
    };
    if (pinId != null) map['pin_id'] = pinId;
    return map;
  }

  Pin clone() => Pin(
        pinId: this.pinId,
        pinEnc: this.pinEnc,
        pinIv: this.pinIv,
        pinDate: this.pinDate,
        pinLapse: this.pinLapse,
        pinStatus: this.pinStatus,
      );
}
