class Cpe23uriCve {
  int fkCpe23uriId;
  int fkCveId;

  Cpe23uriCve(this.fkCpe23uriId, this.fkCveId);

  Cpe23uriCve.fromMap(Map<String, dynamic> map) {
    fkCpe23uriId = map['fk_cpe23uri_id'];
    fkCveId = map['fk_cve_id'];
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fk_cpe23uri_id': fkCpe23uriId,
        'fk_cve_id': fkCveId,
      };
}
