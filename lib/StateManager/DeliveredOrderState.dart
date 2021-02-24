import 'package:flutter/material.dart';

class DeliveredOrderState extends ChangeNotifier {
  String lastOrderID = "";
  String lastOUpdateDate = "";

  String getLastOrderID() => lastOrderID;
  String getLastOUpdateDate() => lastOUpdateDate;

  setLastOrderID(String lastOrderID) {
    this.lastOrderID = lastOrderID;
    notifyListeners();
  }

  setLastOUpdateDate(String lastOUpdateDate) {
    this.lastOUpdateDate = lastOUpdateDate;
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////
  bool isClearFilter = false;
  bool getIsClearFilter() => isClearFilter;

  setIsClearFilter(bool isClearFilter) {
    this.isClearFilter = isClearFilter;
    notifyListeners();
  }
///////////////////////////////////////////////////////////////////////////

  String activeFilter = "Date Of Purchase";

  String getActiveFilter() => activeFilter;

  setActiveFilter(String activeFilterName) {
    this.activeFilter = activeFilterName;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  Map<String, dynamic> deliveredOrderState = {
    "Date Of Purchase": "select date",
    "Date Of Delivery": "select date",
    "isNotifcationCue": false
  };

  Map<String, dynamic> getDeliveredOrderState() => deliveredOrderState;

  setDeliveredOrderState(Map<String, dynamic> deliveredOrderState) {
    this.deliveredOrderState = deliveredOrderState;

    notifyListeners();
  }

  clearAll() {
    this.isClearFilter = false;
    this.activeFilter = "Date Of Purchase";
    this.deliveredOrderState = {
      "Date Of Purchase": "select date",
      "Date Of Delivery": "select date",
      "isNotifcationCue": false
    };
    notifyListeners();
  }
}
