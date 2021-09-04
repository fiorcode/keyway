class ProductCve {
  int fkProductId;
  int fkCveId;
  int patched;

  ProductCve({
    this.fkProductId,
    this.fkCveId,
    this.patched = 0,
  });

  bool get isPatched => (this.patched > 0);

  ProductCve.fromMap(Map<String, dynamic> map) {
    fkProductId = map['fk_product_id'];
    fkCveId = map['fk_cve_id'];
    patched = map['patched'];
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fk_product_id': fkProductId,
        'fk_cve_id': fkCveId,
        'patched': patched,
      };

  ProductCve clone() {
    ProductCve _pc = ProductCve(
      fkProductId: this.fkProductId,
      fkCveId: this.fkCveId,
      patched: this.patched,
    );
    return _pc;
  }

  bool notEqual(ProductCve pc) {
    if (pc == null) return true;
    if (this.fkProductId != pc.fkProductId) return true;
    if (this.fkCveId != pc.fkCveId) return true;
    if (this.patched != pc.patched) return true;
    return false;
  }

  bool equal(ProductCve pc) {
    if (this.fkProductId != pc.fkProductId) return false;
    if (this.fkCveId != pc.fkCveId) return false;
    if (this.patched != pc.patched) return false;
    return true;
  }
}
