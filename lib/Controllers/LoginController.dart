import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kirnas_business/Services/LoginService.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';

var now = new DateTime.now();
var formatter = DateFormat("dd-MM-yyyy");
String formattedTodayDate = formatter.format(now);

class LoginController {
  Future<dynamic> updateAddress(
      {String landmark,
      String state,
      String city,
      String address,
      String pincode,
      String locality}) async {
    var userD = await UserDetailsSP().getUserDetails();
    print("iDDD :" + userD["userId"]);
    var body = json.encode({
      "landmark": landmark,
      "state": state,
      "city": city,
      "address": address,
      "pincode": pincode,
      "locality": locality
    });

    var userDetails = await LoginService().updateAddress(body, userD["userId"]);
    if (userDetails["message"].toString().contains("Address Updated")) {
      Map<String, dynamic> address = json.decode(body);

      Map<String, dynamic> userDetailsAdded =
          await UserDetailsSP().updateAddress(address);
      await UserDetailsSP().setIsAddressPresent(true);

      userDetails = userDetailsAdded;
    } else {
      userDetails = null;
    }

    return userDetails;
  }

  Future<dynamic> addDeviceToken(String deviceToken) async {
    var userDetails = await UserDetailsSP().getUserDetails();
    String userID = userDetails['userId'];
    var body = json.encode({
      "token": deviceToken,
      "userID": userID,
    });

    var tokenDetails = await LoginService().addDeviceToken(body);

    return tokenDetails;
  }

  Future<dynamic> createUser(IdTokenResult userIdToken, String userName) async {
    var body = json.encode({
      "userBalance": "0",
      "userAdmin": false,
      "userName": userName,
      "userAddress": {
        "landmark": "",
        "state": "",
        "city": "",
        "address": "",
        "pincode": "",
        "locality": ""
      },
      "userDeviceToken": "",
      "userPhone": userIdToken.claims["phone_number"].toString(),
      "userCreationdate": formattedTodayDate,
    });

    var userDetails = await LoginService()
        .createUser(body, userIdToken.claims["user_id"].toString());
    if (userDetails["message"].toString().contains("Created")) {
      Map<String, dynamic> userD = json.decode(body);

      userD.addAll({
        "jwt": userIdToken.token.toString(),
        "jwtExp": userIdToken.claims["exp"].toString(),
        "jwtIat": userIdToken.claims["iat"].toString(),
        "userId": userIdToken.claims["user_id"].toString(),
      });
      var userDetailsForPref = json.encode(userD);
      print(userDetailsForPref);

      await UserDetailsSP().loginUser(userDetailsForPref);
      await UserDetailsSP().setIsAddressPresent(false);

      userDetails = "true";
    } else {
      userDetails = "false";
    }

    return userDetails;
  }

  Future<dynamic> getUserByID(IdTokenResult userIdToken) async {
    var userDetails = await LoginService()
        .getUserByID(userIdToken.claims["user_id"].toString());

    if (userDetails["message"].toString().contains("getUserById")) {
      Map<String, dynamic> userD = userDetails['userData'];
      userDetails = userD;

      userD.addAll({
        "jwt": userIdToken.token.toString(),
        "jwtExp": userIdToken.claims["exp"].toString(),
        "jwtIat": userIdToken.claims["iat"].toString(),
        "userId": userIdToken.claims["user_id"].toString(),
      });
      var userDetailsForPref = json.encode(userD);
      print(userDetailsForPref);

      await UserDetailsSP().loginUser(userDetailsForPref);
    } else {
      Map<String, dynamic> userD = userDetails['userData'];
      userDetails = userD;
    }

    return userDetails;
  }

  Future<dynamic> isUserAdmin(String phoneNumber) async {
    var isUserAdmin = await LoginService().isUserAdmin(phoneNumber);

    return isUserAdmin;
  }
}
