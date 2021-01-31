class Product {
  String productID;
  ProductData productData;

  Product({this.productID, this.productData});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return new Product(
      productID: parsedJson['productID'],
      productData: parsedJson['productData'] != null
          ? new ProductData.fromJson(parsedJson['productData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productID'] = this.productID;
    if (this.productData != null) {
      data['productData'] = this.productData.toJson();
    }
    return data;
  }
}

class ProductData {
  String productUnit;
  String updateDate;
  String productUrl;
  String productName;
  String productOffPercentage;
  String productCategory;
  String productBrand;
  String productNetWeight;
  bool discontinue;
  String productID;
  String productDescription;
  String productQty;
  String createDate;
  String productMrp;
  String productCp;

  ProductData(
      {this.productUnit,
      this.updateDate,
      this.productUrl,
      this.productName,
      this.productOffPercentage,
      this.productCategory,
      this.productBrand,
      this.productNetWeight,
      this.discontinue,
      this.productID,
      this.productDescription,
      this.productQty,
      this.createDate,
      this.productMrp,
      this.productCp});

  factory ProductData.fromJson(Map<String, dynamic> parsedJson) {
    return new ProductData(
      productUnit: parsedJson['productUnit'],
      updateDate: parsedJson['updateDate'],
      productUrl: parsedJson['productUrl'],
      productName: parsedJson['productName'],
      productOffPercentage: parsedJson['productOffPercentage'],
      productCategory: parsedJson['productCategory'],
      productBrand: parsedJson['productBrand'],
      productNetWeight: parsedJson['productNetWeight'],
      discontinue: parsedJson['discontinue'],
      productID: parsedJson['productID'],
      productDescription: parsedJson['productDescription'],
      productQty: parsedJson['productQty'],
      createDate: parsedJson['createDate'],
      productMrp: parsedJson['productMrp'],
      productCp: parsedJson['productCp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productUnit'] = this.productUnit;
    data['updateDate'] = this.updateDate;
    data['productUrl'] = this.productUrl;
    data['productName'] = this.productName;
    data['productOffPercentage'] = this.productOffPercentage;
    data['productCategory'] = this.productCategory;
    data['productBrand'] = this.productBrand;
    data['productNetWeight'] = this.productNetWeight;
    data['discontinue'] = this.discontinue;
    data['productID'] = this.productID;
    data['productDescription'] = this.productDescription;
    data['productQty'] = this.productQty;
    data['createDate'] = this.createDate;
    data['productMrp'] = this.productMrp;
    data['productCp'] = this.productCp;
    return data;
  }
}
