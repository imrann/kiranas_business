import 'package:kirnas_business/Services/ProductService.dart';

class ProductController {
  Future<dynamic> getProductList() async {
    var productList = await ProductService().getProductList();

    return productList;
  }

  Future<dynamic> getProuctSearchList(String searchParam) async {
    var productSearchList =
        await ProductService().getMedicineSearchList(searchParam: searchParam);

    return productSearchList;
  }

  Future<dynamic> getFilterListByName(String filterName) async {
    var productfilterNameList =
        await ProductService().getFilterListByName(filterName);

    return productfilterNameList;
  }

  Future<dynamic> getFilterSearchList(
      List<String> category, List<String> discount) async {
    var commaSeperatedCategory;
    var discountVal;

    if (category.isEmpty) {
      commaSeperatedCategory = "null";
    } else {
      commaSeperatedCategory = category.join(',');
    }

    if (discount.isEmpty) {
      discountVal = "null";
    } else {
      discountVal = discount[0];
    }
    var productFilteredSearchList = await ProductService().getFilterSearchList(
        category: commaSeperatedCategory, discount: discountVal);

    return productFilteredSearchList;
  }
}
