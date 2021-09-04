class Cve {
  int cveId;
  String cve;
  String assigner;
  String referencesUrl;
  String descriptions;
  String publishedDate;
  String lastModifiedDate;
  int fkCveImpactV3Id;

  Cve({
    this.cveId,
    this.cve = '',
    this.assigner = '',
    this.referencesUrl = '',
    this.descriptions = '',
    this.publishedDate = '',
    this.lastModifiedDate = '',
    this.fkCveImpactV3Id,
  });

  Cve.fromMap(Map<String, dynamic> map) {
    cveId = map['cve_id'];
    cve = map['cve'];
    assigner = map['assigner'];
    referencesUrl = map['references_url'];
    descriptions = map['descriptions'];
    publishedDate = map['published_date'];
    lastModifiedDate = map['last_modified_date'];
    fkCveImpactV3Id = map['fk_cve_impact_v3_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'cve': cve,
      'assigner': assigner,
      'references_url': referencesUrl,
      'descriptions': descriptions,
      'published_date': publishedDate,
      'last_modified_date': lastModifiedDate,
      'fk_cve_impact_v3_id': fkCveImpactV3Id,
    };
    if (cveId != null) map['cve_id'] = cveId;
    return map;
  }
}
