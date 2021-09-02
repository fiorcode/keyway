import 'package:keyway/models/api/nist/cpe.dart';

class Cpe23uri {
  int cpe23uriId;
  String value;
  int deprecated;
  String lastModifiedDate;
  String title;
  String ref;
  String refType;
  String lastTracking;

  List<String> vulnerabilities;

  Cpe23uri({
    this.cpe23uriId,
    this.value = '',
    this.deprecated = 0,
    this.lastModifiedDate = '',
    this.title = '',
    this.ref = '',
    this.refType = '',
    this.lastTracking = '',
  });

  Cpe23uri.fromCpe(Cpe cpe) {
    this.value = cpe.cpe23Uri;
    this.lastModifiedDate = cpe.lastModifiedDate;
    this.title = cpe.titles.isEmpty ? '' : cpe.titles.first.title;
    this.ref = cpe.refs.isEmpty ? '' : cpe.refs.first.ref;
    this.refType = cpe.refs.isEmpty ? '' : cpe.refs.first.type;
    this.vulnerabilities = cpe.vulnerabilities;
  }

  Cpe23uri.fromMap(Map<String, dynamic> map) {
    this.cpe23uriId = map['cpe23uri_id'];
    this.value = map['value'];
    this.deprecated = map['deprecated'];
    this.lastModifiedDate = map['last_modified_date'];
    this.title = map['title'];
    this.ref = map['ref'];
    this.refType = map['ref_type'];
    this.lastTracking = map['last_tracking'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'value': this.value,
      'deprecated': this.deprecated,
      'last_modified_date': this.lastModifiedDate,
      'title': this.title,
      'ref': this.ref,
      'ref_type': this.refType,
      'last_tracking': this.lastTracking,
    };
    if (cpe23uriId != null) map['cpe23uri_id'] = cpe23uriId;
    return map;
  }

  bool equal(Cpe23uri cpe) {
    if (this.cpe23uriId != cpe.cpe23uriId) return false;
    if (this.value != cpe.value) return false;
    return true;
  }
}
