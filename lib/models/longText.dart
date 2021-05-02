class LongText {
  int longTextId;
  String longTextEnc;
  String longTextIv;

  LongText({
    this.longTextId,
    this.longTextEnc = '',
    this.longTextIv = '',
  });

  LongText.fromMap(Map<String, dynamic> map) {
    longTextId = map['long_text_id'];
    longTextEnc = map['long_text_enc'];
    longTextIv = map['long_text_iv'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'long_text_enc': longTextEnc,
      'long_text_iv': longTextIv,
    };
    if (longTextId != null) map['long_text_id'] = longTextId;
    return map;
  }
}
