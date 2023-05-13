class Product {
  String? productId;
  String? productName;
  String? productDescription;
  String? productType;
  String? productBarcode;
  String? productDate;
  String? productWarranty;
  String? productOrigin;
  String? productEncryptedCode;
  String? productInsertDate;
  String? manufacturerId;
  String? manufacturerRegid;
  String? manufacturerRegDate;
  String? manufacturerName;
  String? retailerId;
  String? retailerRegDate;
  String? retailerName;
  String? buyerId;
  String? buyerRegDate;
  String? buyerName;

  Product({
    this.productId,
    this.productName,
    this.productDescription,
    this.productType,
    this.productBarcode,
    this.productDate,
    this.productWarranty,
    this.productOrigin,
    this.productEncryptedCode,
    this.productInsertDate,
    this.manufacturerId,
    this.manufacturerRegid,
    this.manufacturerRegDate,
    this.manufacturerName,
    this.retailerId,
    this.retailerRegDate,
    this.retailerName,
    this.buyerId,
    this.buyerRegDate,
    this.buyerName,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDescription = json['product_description'];
    productType = json['product_type'];
    productBarcode = json['product_barcode'];
    productDate = json['product_date'];
    productWarranty = json['product_warranty'];
    productOrigin = json['product_origin'];
    productEncryptedCode = json['product_encryptedcode'];
    productInsertDate = json['product_insertdate'];
    manufacturerId = json['manufacturer_id'];
    manufacturerRegid = json['manufacturer_regid'];
    manufacturerRegDate = json['manufacturer_regdate'];
    manufacturerName = json['manufacturer_name'];
    retailerId = json['retailer_id'];
    retailerRegDate = json['retailer_regdate'];
    retailerName = json['retailer_Name'];
    buyerId = json['buyer_id'];
    buyerRegDate = json['buyer_regdate'];
    buyerName = json['buyer_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_description'] = productDescription;
    data['product_type'] = productType;
    data['product_barcode'] = productBarcode;
    data['product_date'] = productDate;
    data['product_warranty'] = productWarranty;
    data['product_origin'] = productOrigin;
    data['product_encyptedcode'] = productEncryptedCode;
    data['product_insertdate'] = productInsertDate;
    data['manufacturer_id'] = manufacturerId;
    data['manufacturer_regid'] = manufacturerRegid;
    data['manufacturer_regdate'] = manufacturerRegDate;
    data['retailer_id'] = retailerId;
    data['retailer_regdate'] = retailerRegDate;
    data['buyer_id'] = buyerId;
    data['buyer_regdate'] = buyerRegDate;
    return data;
  }
}
