import 'package:flutter/material.dart';

class CancelledOrderState extends ChangeNotifier {
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
  Map<String, dynamic> cancelledOrderState = {
    "Date Of Purchase": "select date",
    "Date Of Cancellation": "select date",
    "isNotifcationCue": false
  };

  Map<String, dynamic> getCancelledOrderState() => cancelledOrderState;

  setCancelledOrderState(Map<String, dynamic> cancelledOrderState) {
    this.cancelledOrderState = cancelledOrderState;
    notifyListeners();
  }

  clearAll() {
    this.isClearFilter = false;
    this.activeFilter = "Date Of Purchase";
    this.cancelledOrderState = {
      "Date Of Purchase": "select date",
      "Date Of Cancellation": "select date",
      "isNotifcationCue": false
    };
    notifyListeners();
  }
}
