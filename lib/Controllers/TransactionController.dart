import 'package:kirnas_business/Services/TransactionService.dart';

class TransactionController {
  Future<dynamic> getAllTransactions() async {
    var transactionList = await TransactionService().getAllTransactions();

    return transactionList;
  }
}
