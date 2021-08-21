import 'package:flutter/material.dart';

import '../models/api/nist/cpe.dart';
import '../models/cpe23uri.dart';

class Product {
  int productId;
  String productType;
  String productTrademark;
  String productModel;
  String productVersion;
  String productUpdate;
  String productStatus;
  int fkCpe23uriId;

  Cpe23uri cpe23uri;

  void setCpe23uri(Cpe cpe) => this.cpe23uri = Cpe23uri.fromCpe(cpe);

  bool get isEmpty =>
      this.productTrademark.isEmpty &&
      this.productModel.isEmpty &&
      this.cpe23uri == null;

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

  IconData get icon {
    switch (productType) {
      case 'h':
        return Icons.router;
        break;
      case 'o':
        return Icons.android;
        break;
      case 'a':
        return Icons.wysiwyg;
        break;
      default:
        return Icons.router;
    }
  }

  Product({
    this.productId,
    this.productType = '',
    this.productTrademark = '',
    this.productModel = '',
    this.productVersion = '',
    this.productUpdate = '',
    this.productStatus = '',
    this.fkCpe23uriId,
  });

  Product.fromMap(Map<String, dynamic> map) {
    this.productId = map['product_id'];
    this.productType = map['product_type'];
    this.productTrademark = map['product_trademark'];
    this.productModel = map['product_model'];
    this.productVersion = map['product_version'];
    this.productUpdate = map['product_update'];
    this.productStatus = map['product_status'];
    this.fkCpe23uriId = map['fk_cpe23uri_id'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'product_type': this.productType,
      'product_trademark': this.productTrademark,
      'product_model': this.productModel,
      'product_version': this.productVersion,
      'product_update': this.productUpdate,
      'product_status': this.productStatus,
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
