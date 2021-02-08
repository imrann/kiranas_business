import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:kirnas_business/Services/ProductService.dart';

var now = new DateTime.now();
var formatter = DateFormat("dd-MM-yyyy");
String formattedTodayDate = formatter.format(now);

class ProductController {
  Future<dynamic> getProductByID(String productID) async {
    var productDetails = await ProductService().getProductByID(productID);

    return productDetails;
  }

  Future<dynamic> disContinueProduct(
      {String productID, bool discontinueAction}) async {
    var discontinueResult = await ProductService().disContinueProduct(
        productID: productID, discontinueAction: discontinueAction);

    return discontinueResult;
  }

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

  Future<dynamic> createProduct(
      String productBrand,
      String productCategory,
      String productCp,
      String productDescription,
      String productMrp,
      String productName,
      String productOffPercentage,
      String productQty,
      String productUnit,
      String productNetWeight,
      String productUrl,
      String imageName) async {
    var body = json.encode({
      "productBrand": productBrand,
      "productCategory": productCategory,
      "productCp": productCp,
      "productDescription": productDescription,
      "productMrp": productMrp,
      "productName": productName,
      "productOffPercentage": productOffPercentage,
      "productQty": productQty,
      "productUnit": productUnit,
      "productNetWeight": productNetWeight,
      "productUrl": productUrl,
      "createDate": formattedTodayDate,
      "updateDate": formattedTodayDate,
      "discontinue": false,
      "productImageName": imageName
    });

    var isProductCreated = await ProductService().createProduct(body);

    return isProductCreated;
  }

  Future<dynamic> updateProduct(
      String productBrand,
      String productCategory,
      String productCp,
      String productDescription,
      String productMrp,
      String productName,
      String productOffPercentage,
      String productQty,
      String productUnit,
      String productNetWeight,
      String productUrl,
      String productID,
      String imageName) async {
    var updateBody = json.encode({
      "productBrand": productBrand,
      "productCategory": productCategory,
      "productCp": productCp,
      "productDescription": productDescription,
      "productMrp": productMrp,
      "productName": productName,
      "productOffPercentage": productOffPercentage,
      "productQty": productQty,
      "productUnit": productUnit,
      "productNetWeight": productNetWeight,
      "productUrl": productUrl,
      "createDate": formattedTodayDate,
      "updateDate": formattedTodayDate,
      "productID": productID,
      "discontinue": false,
      "productImageName": imageName
    });

    var isProductUpdated =
        await ProductService().updateProduct(updateBody, productID);

    return isProductUpdated;
  }
}
