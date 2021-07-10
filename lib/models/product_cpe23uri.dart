class ProductCpe23uri {
  int fkProductId;
  int fkCpe23uriId;

  ProductCpe23uri({
    this.fkProductId,
    this.fkCpe23uriId,
  });

  ProductCpe23uri.fromMap(Map<String, dynamic> map) {
    fkProductId = map['fk_product_id'];
    fkCpe23uriId = map['fk_cpe23uri_id'];
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'fk_product_id': fkProductId,
        'fk_cpe23uri_id': fkCpe23uriId,
      };

  // ProductCpe23uri clone() {
  //   ProductCpe23uri _pc = ProductCpe23uri(
  //     fkProductId: this.fkProductId,
  //     fkCpe23uriId: this.fkCpe23uriId,
  //   );
  //   return _pc;
  // }
}
