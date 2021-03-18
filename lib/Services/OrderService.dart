import 'dart:convert';
import 'dart:io';

import 'package:kirnas_business/CommonScreens/CustomException.dart';

import 'package:http/http.dart' as http;
import 'package:kirnas_business/Podo/OrdersData.dart';

class OrderService {
  Future<dynamic> createOrder(var order, String mode) async {
    final String createProductApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/orders/createOrder/$mode";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    try {
      http.Response res =
          await http.post(createProductApi, headers: headers, body: order);
      print(res.body);
      if (res.statusCode == 201 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("order created")) {
        return "orderCreated";
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getOrdersOnlyByType(String type) async {
    final String getOrdersOnlyByTypeApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/orders/getOrdersOnlyByType/$type";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<OrdersData> posts = new List<OrdersData>();
    try {
      http.Response res =
          await http.get(getOrdersOnlyByTypeApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getOrdersOnlyByType")) {
        var data = jsonDecode(res.body)['orders'] as List;

        posts = data.map((posts) => OrdersData.fromJson(posts)).toList();

        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getPaginatedOrdersOnlyByType(
      String type, String lastOrderID, num lastOUpdateDate) async {
    final String getPaginatedOrdersOnlyByTypeApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/orders/getPaginatedOrdersOnlyByType/$type/$lastOrderID/$lastOUpdateDate";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<OrdersData> posts = new List<OrdersData>();
    try {
      http.Response res =
          await http.get(getPaginatedOrdersOnlyByTypeApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getPaginatedOrdersOnlyByType")) {
        var data = jsonDecode(res.body)['orders'] as List;

        posts = data.map((posts) => OrdersData.fromJson(posts)).toList();
        print(jsonDecode(res.body)['lastOrderID'].toString());
        print(jsonDecode(res.body)['lastOUpdateDate'].toString());

        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getOrdersByType(String type, String userId) async {
    final String getOrdersByTypeApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/orders/getOrdersByType/$userId/$type";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<OrdersData> posts = new List<OrdersData>();
    try {
      http.Response res = await http.get(getOrdersByTypeApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getOrdersByType")) {
        var data = jsonDecode(res.body)['orders'] as List;
        print("cc :" + data.toString());

        posts = data.map((posts) => OrdersData.fromJson(posts)).toList();

        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> updateOrderStatus(
      {String orderID, String status, String est}) async {
    final String updateOrderStatusApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/status/updateOrderStatus/$orderID/$status/$est";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    try {
      http.Response res =
          await http.put(updateOrderStatusApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("status cancelled")) {
        return "true";
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getProductByFilter(
      {String dop,
      String dod,
      String doc,
      String trackingStatus,
      String status}) async {
    final String getProductByFilterApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/orders/getOrderByFilter/dop/$dop/dod/$dod/doc/$doc/trackingStatus/$trackingStatus/status/$status";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    print(getProductByFilterApi);
    List<OrdersData> posts = new List<OrdersData>();
    try {
      http.Response res =
          await http.get(getProductByFilterApi, headers: headers);

      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getOrderByFilter")) {
        var data = jsonDecode(res.body)['orders'] as List;

        posts = data.map((posts) => OrdersData.fromJson(posts)).toList();
        print(posts);
        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getTotalOrdersByType(String type) async {
    final String getTotalOrdersByTypeApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/orders/getTotalOrdersByType/$type";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    try {
      http.Response res =
          await http.get(getTotalOrdersByTypeApi, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getTotalOrdersByType")) {
        var data = jsonDecode(res.body)['ordersLength'];

        return data;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }
}
