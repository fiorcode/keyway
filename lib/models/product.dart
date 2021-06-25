class Product {
  int productId;
  String productType;
  String productTrademark;
  String productModel;
  String productVersion;
  String productUpdate;
  String productStatus;
  int trackVulnerabilities;
  String lastTracking;
  int fkCpe23uriId;

  Product({
    this.productId,
    this.productType = '',
    this.productTrademark = '',
    this.productModel = '',
    this.productVersion = '',
    this.productUpdate = '',
    this.productStatus = '',
    this.trackVulnerabilities = 1,
    this.lastTracking = '',
    this.fkCpe23uriId,
  });

  bool get tracked => this.trackVulnerabilities == 1 ? true : false;

  void trackSwitch() => this.trackVulnerabilities == 1
      ? this.trackVulnerabilities = 0
      : this.trackVulnerabilities = 1;

  Product.fromMap(Map<String, dynamic> map) {
    this.productId = map['prodcut_id'];
    this.productType = map['prodcut_type'];
    this.productTrademark = map['prodcut_trademark'];
    this.productModel = map['prodcut_model'];
    this.productVersion = map['prodcut_version'];
    this.productUpdate = map['prodcut_update'];
    this.productStatus = map['prodcut_status'];
    this.trackVulnerabilities = map['track_vulnerabilities'];
    this.lastTracking = map['last_tracking'];
    this.fkCpe23uriId = map['fk_cpe23uri_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'prodcut_type': this.productType,
      'prodcut_trademark': this.productTrademark,
      'prodcut_model': this.productModel,
      'prodcut_version': this.productVersion,
      'prodcut_update': this.productUpdate,
      'prodcut_status': this.productStatus,
      'track_vulnerabilities': this.trackVulnerabilities,
      'last_tracking': this.lastTracking,
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
