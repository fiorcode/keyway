import 'package:keyway/helpers/date_helper.dart';

class Pin {
  int? pinId;
  String pinEnc = '';
  String pinIv = '';
  String pinDate = '';
  int pinLapse = 0;
  String pinStatus = '';

  String pinDec = '';

  bool get empty => this.pinEnc.isEmpty && this.pinIv.isEmpty;

  Pin({
    this.pinId,
    this.pinEnc = '',
    this.pinIv = '',
    this.pinDate = '',
    this.pinLapse = 320,
    this.pinStatus = '<active>',
    this.pinDec = '***clear***',
  });

  bool get repeatWarning => !this.pinStatus.contains('<no-warning>');
  bool get expired {
    if (this.pinLapse == 0) {
      return false;
    }
    return DateHelper.expired(pinDate, pinLapse);
  }

  void repeatWarningSwitch() {
    if (repeatWarning)
      this.pinStatus = this.pinStatus + '<no-warning>';
    else
      this.pinStatus = this.pinStatus.replaceAll('<no-warning>', '');
  }

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
        pinDec: this.pinDec,
        pinIv: this.pinIv,
        pinDate: this.pinDate,
        pinLapse: this.pinLapse,
        pinStatus: this.pinStatus,
      );

  bool notEqual(Pin? p) {
    if (p == null) return true;
    if (this.pinId != p.pinId) return true;
    if (this.pinEnc != p.pinEnc) return true;
    if (this.pinIv != p.pinIv) return true;
    if (this.pinDate != p.pinDate) return true;
    if (this.pinLapse != p.pinLapse) return true;
    if (this.pinStatus != p.pinStatus) return true;
    return false;
  }

  void clearPinDec() => this.pinDec = '***clear***';
}
