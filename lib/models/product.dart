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
  });

  bool get tracked => this.trackVulnerabilities == 1 ? true : false;

  void trackSwitch() => this.trackVulnerabilities == 1
      ? this.trackVulnerabilities = 0
      : this.trackVulnerabilities = 1;

  Product.fromMap(Map<String, dynamic> map) {
    this.productId = map['product_id'];
    this.productType = map['product_type'];
    this.productTrademark = map['product_trademark'];
    this.productModel = map['product_model'];
    this.productVersion = map['product_version'];
    this.productUpdate = map['product_update'];
    this.productStatus = map['product_status'];
    this.trackVulnerabilities = map['track_vulnerabilities'];
    this.lastTracking = map['last_tracking'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'product_type': this.productType,
      'product_trademark': this.productTrademark,
      'product_model': this.productModel,
      'product_version': this.productVersion,
      'product_update': this.productUpdate,
      'product_status': this.productStatus,
      'track_vulnerabilities': this.trackVulnerabilities,
      'last_tracking': this.lastTracking,
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
        trackVulnerabilities: this.trackVulnerabilities,
        lastTracking: this.lastTracking,
      );
}
