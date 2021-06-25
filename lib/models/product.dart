class Product {
  int productId;
  String productType;
  String productTrademark;
  String productModel;
  String productVersion;
  String productUpdate;
  int fkCpe23uriId;

  Product({
    this.productId,
    this.productType = '',
    this.productTrademark = '',
    this.productModel = '',
    this.productVersion = '',
    this.productUpdate = '',
    this.fkCpe23uriId,
  });

  Product.fromMap(Map<String, dynamic> map) {
    this.productId = map['prodcut_id'];
    this.productType = map['prodcut_type'];
    this.productTrademark = map['prodcut_trademark'];
    this.productModel = map['prodcut_model'];
    this.productVersion = map['prodcut_version'];
    this.productUpdate = map['prodcut_update'];
    this.fkCpe23uriId = map['fk_cpe23uri_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'prodcut_type': this.productType,
      'prodcut_trademark': this.productTrademark,
      'prodcut_model': this.productModel,
      'prodcut_version': this.productVersion,
      'prodcut_update': this.productUpdate,
      'fk_cpe23uri_id': this.fkCpe23uriId,
    };
    if (this.productId != null) map['product_id'] = this.productId;
    return map;
  }

  Product clone() => Product(
        productId: this.productId,
        productType: this.productType,
        productTrademark: this.productTrademark,
        productModel: this.productModel,
        productVersion: this.productVersion,
        productUpdate: this.productUpdate,
        fkCpe23uriId: this.fkCpe23uriId,
      );
}
