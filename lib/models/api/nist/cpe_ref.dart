class CpeRef {
  final String? ref;
  final String? type;

  CpeRef(this.ref, this.type);

  factory CpeRef.fromJson(Map<String, dynamic> parsedJson) =>
      CpeRef(parsedJson['ref'], parsedJson['type']);
}
