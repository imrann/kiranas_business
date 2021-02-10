import 'dart:convert';
import 'dart:io';

import 'package:kirnas_business/CommonScreens/CustomException.dart';
import 'package:kirnas_business/Podo/Transactions.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  Future<dynamic> getAllTransactions() async {
    final String getAllTransactionsAPI =
        "https://us-central1-kiranas-c082f.cloudfunctions.net/kiranas/api/transactions/getAllTransactions";

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };
    List<Transactions> posts = new List<Transactions>();
    try {
      http.Response res =
          await http.get(getAllTransactionsAPI, headers: headers);
      if (res.statusCode == 200 &&
          jsonDecode(res.body)['message']
              .toString()
              .contains("getAllTransactions")) {
        var data = jsonDecode(res.body)['transactions'] as List;

        posts = data.map((posts) => Transactions.fromJson(posts)).toList();

        return posts;
      } else {
        CustomException().returnResponse(response: res, connection: true);
      }
    } on SocketException {
      CustomException().returnResponse(connection: false);
    } finally {}
  }
}
