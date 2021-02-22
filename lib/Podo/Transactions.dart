class Transactions {
  TransData transData;

  Transactions({this.transData});

  factory Transactions.fromJson(Map<String, dynamic> parsedJson) {
    return new Transactions(
      transData: parsedJson['transData'] != null
          ? new TransData.fromJson(parsedJson['transData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transData != null) {
      data['transData'] = this.transData.toJson();
    }
    return data;
  }
}

class TransData {
  int tCreationDate;
  String tParty;
  String tOrderID;
  String tBillAmt;
  String tStatus;
  int tUpdationDate;
  String tMode;
  String tTransactionAction;

  TransData(
      {this.tCreationDate,
      this.tParty,
      this.tOrderID,
      this.tBillAmt,
      this.tStatus,
      this.tUpdationDate,
      this.tMode,
      this.tTransactionAction});

  factory TransData.fromJson(Map<String, dynamic> parsedJson) {
    return new TransData(
        tCreationDate: parsedJson['t_CreationDate'],
        tParty: parsedJson['t_Party'],
        tOrderID: parsedJson['t_OrderID'],
        tBillAmt: parsedJson['t_BillAmt'],
        tStatus: parsedJson['t_Status'],
        tUpdationDate: parsedJson['t_UpdationDate'],
        tMode: parsedJson['t_Mode'],
        tTransactionAction: parsedJson['t_TransactionAction']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['t_CreationDate'] = this.tCreationDate;
    data['t_Party'] = this.tParty;
    data['t_OrderID'] = this.tOrderID;
    data['t_BillAmt'] = this.tBillAmt;
    data['t_Status'] = this.tStatus;
    data['t_UpdationDate'] = this.tUpdationDate;
    data['t_Mode'] = this.tMode;
    data['t_TransactionAction'] = this.tTransactionAction;
    return data;
  }
}
