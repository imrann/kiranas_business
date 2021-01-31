class FilterListDiscount {
  List<String> productDiscountList;

  FilterListDiscount({this.productDiscountList});

  factory FilterListDiscount.fromJson(Map<String, dynamic> parsedJson) {
    return new FilterListDiscount(
      productDiscountList: parsedJson['productDiscountList'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productDiscountList'] = this.productDiscountList;
    return data;
  }
}
