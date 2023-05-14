class CounterfeitProduct {
  String? cproductId;
  String? cproductName;
  String? cproductDescription;
  String? cproductPlatform;
  String? cproductOrigin;
  String? cproductLocation;
  String? cproductSellername;
  String? cproductPurchasedate;
  String? cproductEncryptedcode;
  String? cproductBuyerid;
  String? cproductBuyername;
  String? cproductSubmitdate;
  String? manufacturerName;
  String? retailerName;

  CounterfeitProduct({
    this.cproductId,
    this.cproductName,
    this.cproductDescription,
    this.cproductPlatform,
    this.cproductOrigin,
    this.cproductLocation,
    this.cproductSellername,
    this.cproductPurchasedate,
    this.cproductEncryptedcode,
    this.cproductBuyerid,
    this.cproductBuyername,
    this.cproductSubmitdate,
    this.manufacturerName,
    this.retailerName,
  });

  CounterfeitProduct.fromJson(Map<String, dynamic> json) {
    cproductId = json['cproduct_id'];
    cproductName = json['cproduct_name'];
    cproductDescription = json['cproduct_description'];
    cproductPlatform = json['cproduct_platform'];
    cproductOrigin = json['cproduct_origin'];
    cproductLocation = json['cproduct_location'];
    cproductSellername = json['cproduct_sellername'];
    cproductPurchasedate = json['cproduct_purchasedate'];
    cproductEncryptedcode = json['cproduct_encryptedcode'];
    cproductBuyerid = json['cproduct_buyerid'];
    cproductBuyername = json['cproduct_buyername'];
    cproductSubmitdate = json['cproduct_submitdate'];
    manufacturerName = json['manufacturer_name'];
    retailerName = json['retailer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cproduct_id'] = cproductId;
    data['cproduct_name'] = cproductName;
    data['cproduct_description'] = cproductDescription;
    data['cproduct_platform'] = cproductPlatform;
    data['cproduct_origin'] = cproductOrigin;
    data['cproduct_location'] = cproductLocation;
    data['cproduct_sellername'] = cproductSellername;
    data['cproduct_purchasedate'] = cproductPurchasedate;
    data['cproduct_encryptedcode'] = cproductEncryptedcode;
    data['cproduct_buyerid'] = cproductBuyerid;
    data['cproduct_buyername'] = cproductBuyername;
    data['cproduct_submitdate'] = cproductSubmitdate;
    data['manufacturer_name'] = manufacturerName;
    data['retailer_name'] = retailerName;
    return data;
  }
}
