class Cpe23uri {
  int cpe23uriId;
  String value;
  int deprecated;
  String lastModifiedDate;
  String title;
  String ref;
  String refType;

  Cpe23uri({
    this.cpe23uriId,
    this.value = '',
    this.deprecated = 0,
    this.lastModifiedDate = '',
    this.title = '',
    this.ref = '',
    this.refType = '',
  });

  Cpe23uri.fromMap(Map<String, dynamic> map) {
    cpe23uriId = map['cpe23uri_id'];
    value = map['value'];
    deprecated = map['deprecated'];
    lastModifiedDate = map['last_modified_date'];
    title = map['title'];
    ref = map['ref'];
    refType = map['ref_type'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'value': value,
      'deprecated': deprecated,
      'last_modified_date': lastModifiedDate,
      'title': title,
      'ref': ref,
      'ref_type': refType,
    };
    if (cpe23uriId != null) map['cpe23uri_id'] = cpe23uriId;
    return map;
  }
}
