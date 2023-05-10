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
  String? manufacturerId;
  String? manufacturerRegDate;
  String? retailerId;
  String? retalerRegDate;
  String? buyerId;
  String? buyerRegDate;

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
    this.manufacturerId,
    this.manufacturerRegDate,
    this.retailerId,
    this.retalerRegDate,
    this.buyerId,
    this.buyerRegDate,
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
    manufacturerId = json['manufacturer_id'];
    manufacturerRegDate = json['manufacturer_regdate'];
    retailerId = json['retailer_id'];
    retalerRegDate = json['retailer_regdate'];
    buyerId = json['buyer_id'];
    buyerRegDate = json['buyer_regdate'];
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
    data['manufacturer_id'] = manufacturerId;
    data['manufacturer_regdate'] = manufacturerRegDate;
    data['retailer_id'] = retailerId;
    data['retailer_regdate'] = retalerRegDate;
    data['buyer_id'] = buyerId;
    data['buyer_regdate'] = buyerRegDate;
    return data;
  }
}
