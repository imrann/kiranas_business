import 'dart:convert';
import 'dart:io';

import 'package:kirnas_business/CommonScreens/CustomException.dart';
import 'package:kirnas_business/Podo/FIlterListDiscount.dart';
import 'package:kirnas_business/Podo/FilterList.dart';
import 'package:kirnas_business/Podo/Product.dart';

import 'package:http/http.dart' as http;

class ProductService {
  Future<dynamic> getProductByID(String productID) async {
    final String getProductByIDApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/getProductByID/$productID";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<Product> posts = new List<Product>();
    try {
      http.Response res = await http.get(getProductByIDApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getProductByID")) {
        var data = jsonDecode(res.body)['result'] as List;

        posts = data.map((posts) => Product.fromJson(posts)).toList();
        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getProductList() async {
    final String getAllProductApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/getAllProducts";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<Product> posts = new List<Product>();
    try {
      http.Response res = await http.get(getAllProductApi, headers: headers);
      print(res.body);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getAllProducts")) {
        var data = jsonDecode(res.body)['result'] as List;

        posts = data.map((posts) => Product.fromJson(posts)).toList();

        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getFilterListByName(String filterName) async {
    final String getFilterListByNameApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/getAllproductCategory/$filterName";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    FilterList filterListPost = new FilterList();
    FilterListDiscount filterListPDiscountPost = new FilterListDiscount();

    try {
      http.Response res =
          await http.get(getFilterListByNameApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message'].toString() ==
              "success getting productFilterList") {
        var data = jsonDecode(res.body)['productFilterList'];
        if (filterName.contains("productCategoryList")) {
          filterListPost = FilterList.fromJson(data);
          return filterListPost.productCategoryList;
        } else if (filterName.contains("productDiscountList")) {
          filterListPDiscountPost = FilterListDiscount.fromJson(data);
          return filterListPDiscountPost.productDiscountList;
        }
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getMedicineSearchList({String searchParam}) async {
    final String getProductByNameApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/getProductByName/$searchParam/6";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<Product> posts = new List<Product>();
    try {
      http.Response res = await http.get(getProductByNameApi, headers: headers);

      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getProductByName")) {
        var data = jsonDecode(res.body)['result'] as List;

        posts = data.map((posts) => Product.fromJson(posts)).toList();

        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getFilterSearchList(
      {String category, String discount}) async {
    final String getFilterSearchListApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/getProductByCategory/$category/$discount";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<Product> posts = new List<Product>();
    print(category + " : " + discount);
    try {
      http.Response res =
          await http.get(getFilterSearchListApi, headers: headers);

      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getAllProducts")) {
        var data = jsonDecode(res.body)['result'] as List;

        posts = data.map((posts) => Product.fromJson(posts)).toList();
        print(posts);
        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> disContinueProduct(
      {String productID, bool discontinueAction}) async {
    final String disContinueProductApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/deleteProduct/$productID";
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var body = json.encode({
      "discontinue": discontinueAction,
    });
    try {
      http.Response res =
          await http.put(disContinueProductApi, headers: headers, body: body);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("deleteProduct")) {
        return "true";
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> createProduct(String body) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String createProductApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/createProduct";

    try {
      http.Response res =
          await http.post(createProductApi, headers: headers, body: body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "true";
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> updateProduct(String body, String productID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String updateProductApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/products/updateProduct/$productID";

    try {
      http.Response res =
          await http.put(updateProductApi, headers: headers, body: body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return "true";
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }
}
