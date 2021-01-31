class FilterList {
  List<String> productCategoryList;

  FilterList({this.productCategoryList});

  factory FilterList.fromJson(Map<String, dynamic> parsedJson) {
    return new FilterList(
      productCategoryList: parsedJson['productCategoryList'].cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCategoryList'] = this.productCategoryList;
    return data;
  }
}
