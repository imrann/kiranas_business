import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kirnas_business/CommonScreens/CustomException.dart';

class LoginService {
  Future<dynamic> updateAddress(String body, String userID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String updateAddressApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/users/updateAddress/$userID";

    try {
      http.Response res =
          await http.put(updateAddressApi, headers: headers, body: body);
      print(res.statusCode.toString());
      if (res.statusCode == 201) {
        var userDetails = json.decode(res.body);
        if (userDetails["message"].toString().contains("Address Updated")) {
          return userDetails;
        }
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> createUser(String body, String userID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String createUserApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/users/createUser/$userID";

    try {
      http.Response res =
          await http.post(createUserApi, headers: headers, body: body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        var userDetails = json.decode(res.body);
        if (userDetails["message"].toString().contains("Created")) {
          return userDetails;
        }
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> getUserByID(String userID) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String getUserByIDApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/users/getUserById/$userID";

    try {
      http.Response res = await http.get(getUserByIDApi, headers: headers);

      if (res.statusCode == 200 || res.statusCode == 201) {
        var userDetails = json.decode(res.body);
        if (userDetails["message"].toString().contains("getUserById")) {
          return userDetails;
        }
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> isUserAdmin(String phoneNumber) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String isUserAdminApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/users/isUserAdmin/$phoneNumber";

    try {
      http.Response res = await http.get(isUserAdminApi, headers: headers);

      if (res.statusCode == 200 || res.statusCode == 201) {
        var adminDetails = json.decode(res.body);
        if (adminDetails["message"]) {
          return "true";
        } else {
          return "false";
        }
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }

  Future<dynamic> addDeviceToken(String body) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    final String createUserApi =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/users/saveDeviceToken/ownerDeviceToken";

    try {
      http.Response res =
          await http.post(createUserApi, headers: headers, body: body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        var tokenDetails = json.decode(res.body);
        if (tokenDetails["message"].toString().contains("token Added")) {
          return "true";
        } else {
          return "false";
        }
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }
}
