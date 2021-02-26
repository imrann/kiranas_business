import 'package:flutter/material.dart';

class OpenOrderState extends ChangeNotifier {
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
  Map<String, dynamic> openOrderState = {
    "Date Of Purchase": "select date",
    "Status": "NOT SELECTED",
    "isNotifcationCue": false
  };

  Map<String, dynamic> getOpenOrderState() => openOrderState;

  setOpenOrderState(Map<String, dynamic> openOrderState) {
    this.openOrderState = openOrderState;
    notifyListeners();
  }

  clearAll() {
    this.isClearFilter = false;
    this.activeFilter = "Date Of Purchase";
    this.openOrderState = {
      "Date Of Purchase": "select date",
      "Status": "NOT SELECTED",
      "isNotifcationCue": false
    };
    notifyListeners();
  }
}
