import 'package:keyway/models/api/nist/cpe.dart';
import 'package:keyway/models/cpe23uri.dart';

class Product {
  int productId;
  String productType;
  String productTrademark;
  String productModel;
  String productVersion;
  String productUpdate;
  String productStatus;

  List<Cpe23uri> cpes = <Cpe23uri>[];

  Product({
    this.productId,
    this.productType = '',
    this.productTrademark = '',
    this.productModel = '',
    this.productVersion = '',
    this.productUpdate = '',
    this.productStatus = '',
  });

  //TODO: tracking vulns in status

  Product.fromMap(Map<String, dynamic> map) {
    this.productId = map['product_id'];
    this.productType = map['product_type'];
    this.productTrademark = map['product_trademark'];
    this.productModel = map['product_model'];
    this.productVersion = map['product_version'];
    this.productUpdate = map['product_update'];
    this.productStatus = map['product_status'];
  }

  String get type {
    switch (productType) {
      case 'h':
        return 'Hardware';
        break;
      case 'o':
        return 'OS/Firmware';
        break;
      case 'a':
        return 'Application';
        break;
      default:
        return 'All types';
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'product_type': this.productType,
      'product_trademark': this.productTrademark,
      'product_model': this.productModel,
      'product_version': this.productVersion,
      'product_update': this.productUpdate,
      'product_status': this.productStatus,
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
      );

  void addRemoveCpe(Cpe cpe) {
    if (cpes.any((c) => c.value == cpe.cpe23Uri)) {
      cpes.removeWhere((c) => c.value == cpe.cpe23Uri);
    } else {
      cpes.add(Cpe23uri.fromCpe(cpe));
    }
  }
}
