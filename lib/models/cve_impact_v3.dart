class CveImpactV3 {
  String cveImpactV3Id;
  num exploitabilityScore;
  num impactScore;
  String attackVector;
  String attackComplexity;
  String privilegesRequired;
  String userInteraction;
  String scope;
  String confidentialityImpact;
  String integrityImpact;
  String availabilityImpact;
  num baseScore;
  num baseSeverity;

  CveImpactV3({
    this.cveImpactV3Id,
    this.exploitabilityScore = 0,
    this.impactScore = 0,
    this.attackVector = '',
    this.attackComplexity = '',
    this.privilegesRequired = '',
    this.userInteraction = '',
    this.scope = '',
    this.confidentialityImpact = '',
    this.integrityImpact = '',
    this.availabilityImpact = '',
    this.baseScore = 0,
    this.baseSeverity = 0,
  });

  CveImpactV3.fromMap(Map<String, dynamic> map) {
    this.cveImpactV3Id = map['cve_impact_v3_id'];
    this.exploitabilityScore = map['exploitability_score'];
    this.impactScore = map['impact_score'];
    this.attackVector = map['attack_vector'];
    this.attackComplexity = map['attack_complexity'];
    this.privilegesRequired = map['privileges_required'];
    this.userInteraction = map['user_interaction'];
    this.scope = map['scope'];
    this.confidentialityImpact = map['confidentiality_impact'];
    this.integrityImpact = map['integrity_impact'];
    this.availabilityImpact = map['availability_impact'];
    this.baseScore = map['base_score'];
    this.baseSeverity = map['base_severity'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'exploitability_score': this.exploitabilityScore,
      'impact_score': this.impactScore,
      'attack_vector': this.attackVector,
      'attack_complexity': this.attackComplexity,
      'privileges_required': this.privilegesRequired,
      'user_interaction': this.userInteraction,
      'scope': this.scope,
      'confidentiality_impact': this.confidentialityImpact,
      'integrity_impact': this.integrityImpact,
      'availability_impact': this.availabilityImpact,
      'base_score': this.baseScore,
      'base_severity': this.baseSeverity,
    };
    if (cveImpactV3Id != null) map['cve_impact_v3_id'] = cveImpactV3Id;
    return map;
  }
}
