class Orders {
  OBillTotal oBillTotal;
  int oDop;
  String oEstDelivaryTime;
  String oStatus;
  String oTrackingStatus;
  String oUserID;
  String oUserName;
  String oUserPhone;
  int oUpdateDate;
  OUserAddress oUserAddress;
  List<OProducts> oProducts;

  Orders(
      {this.oBillTotal,
      this.oDop,
      this.oEstDelivaryTime,
      this.oStatus,
      this.oTrackingStatus,
      this.oUserID,
      this.oUserName,
      this.oUserPhone,
      this.oUpdateDate,
      this.oUserAddress,
      this.oProducts});

  factory Orders.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['oProducts'] as List;

    List<OProducts> productList =
        list != null ? list.map((i) => OProducts.fromJson(i)).toList() : null;

    return new Orders(
      oBillTotal: parsedJson['oBillTotal'] != null
          ? new OBillTotal.fromJson(parsedJson['oBillTotal'])
          : null,
      oDop: parsedJson['oDop'],
      oEstDelivaryTime: parsedJson['oEstDelivaryTime'],
      oStatus: parsedJson['oStatus'],
      oTrackingStatus: parsedJson['oTrackingStatus'],
      oUserID: parsedJson['oUserID'],
      oUserName: parsedJson['oUserName'],
      oUserPhone: parsedJson['oUserPhone'],
      oUpdateDate: parsedJson['oUpdateDate'],
      oUserAddress: parsedJson['oUserAddress'] != null
          ? new OUserAddress.fromJson(parsedJson['oUserAddress'])
          : null,
      oProducts: parsedJson['taxes'] != null ? productList : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.oBillTotal != null) {
      data['oBillTotal'] = this.oBillTotal.toJson();
    }
    data['oDop'] = this.oDop;
    data['oEstDelivaryTime'] = this.oEstDelivaryTime;
    data['oStatus'] = this.oStatus;
    data['oTrackingStatus'] = this.oTrackingStatus;
    data['oUserID'] = this.oUserID;
    data['oUserName'] = this.oUserName;
    data['oUserPhone'] = this.oUserPhone;
    data['oUpdateDate'] = this.oUpdateDate;

    if (this.oUserAddress != null) {
      data['oUserAddress'] = this.oUserAddress.toJson();
    }
    if (this.oProducts != null) {
      data['oProducts'] = this.oProducts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OBillTotal {
  String amt;
  String offAmt;
  String totalAmt;

  OBillTotal({this.amt, this.offAmt, this.totalAmt});

  factory OBillTotal.fromJson(Map<String, dynamic> parsedJson) {
    return new OBillTotal(
      amt: parsedJson['Amt'],
      offAmt: parsedJson['offAmt'],
      totalAmt: parsedJson['totalAmt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Amt'] = this.amt;
    data['offAmt'] = this.offAmt;
    data['totalAmt'] = this.totalAmt;
    return data;
  }
}

class OUserAddress {
  String landmark;
  String state;
  String city;
  String address;
  String pincode;
  String locality;

  OUserAddress(
      {this.landmark,
      this.state,
      this.city,
      this.address,
      this.pincode,
      this.locality});

  factory OUserAddress.fromJson(Map<String, dynamic> parsedJson) {
    return new OUserAddress(
      landmark: parsedJson['landmark'],
      state: parsedJson['state'],
      city: parsedJson['city'],
      address: parsedJson['address'],
      pincode: parsedJson['pincode'],
      locality: parsedJson['locality'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['landmark'] = this.landmark;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['locality'] = this.locality;
    return data;
  }
}

class OProducts {
  String createDate;
  String productCategory;
  bool discontinue;
  String productBrand;
  String productCp;
  String productDescription;
  String productMrp;
  String productName;
  String productNetWeight;
  int productOffPercentage;
  String productQty;
  String productUnit;
  String productUrl;
  String updateDate;

  OProducts(
      {this.createDate,
      this.productCategory,
      this.discontinue,
      this.productBrand,
      this.productCp,
      this.productDescription,
      this.productMrp,
      this.productName,
      this.productNetWeight,
      this.productOffPercentage,
      this.productQty,
      this.productUnit,
      this.productUrl,
      this.updateDate});

  factory OProducts.fromJson(Map<String, dynamic> parsedJson) {
    return new OProducts(
      createDate: parsedJson['createDate'],
      productCategory: parsedJson['productCategory'],
      discontinue: parsedJson['discontinue'],
      productBrand: parsedJson['productBrand'],
      productCp: parsedJson['productCp'],
      productDescription: parsedJson['productDescription'],
      productMrp: parsedJson['productMrp'],
      productName: parsedJson['productName'],
      productNetWeight: parsedJson['productNetWeight'],
      productOffPercentage: parsedJson['productOffPercentage'],
      productQty: parsedJson['productQty'],
      productUnit: parsedJson['productUnit'],
      productUrl: parsedJson['productUrl'],
      updateDate: parsedJson['updateDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createDate'] = this.createDate;
    data['productCategory'] = this.productCategory;
    data['discontinue'] = this.discontinue;
    data['productBrand'] = this.productBrand;
    data['productCp'] = this.productCp;
    data['productDescription'] = this.productDescription;
    data['productMrp'] = this.productMrp;
    data['productName'] = this.productName;
    data['productNetWeight'] = this.productNetWeight;
    data['productOffPercentage'] = this.productOffPercentage;
    data['productQty'] = this.productQty;
    data['productUnit'] = this.productUnit;
    data['productUrl'] = this.productUrl;
    data['updateDate'] = this.updateDate;
    return data;
  }
}
