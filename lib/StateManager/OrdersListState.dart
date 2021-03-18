import 'package:flutter/material.dart';
import 'package:kirnas_business/Podo/Orders.dart';
import 'package:kirnas_business/Podo/OrdersData.dart';

class OrdersListState extends ChangeNotifier {
  int totalOrdersLength = 0;

  int getTotalOrdersLength() => totalOrdersLength;

  setTotalOrdersLength(int totalOrdersLength) {
    this.totalOrdersLength = totalOrdersLength;
    notifyListeners();
  }

  //////////////////////////////////////////////////////////////

  List<OrdersData> ordersListState = [];

  List<OrdersData> getOrdersListState() => ordersListState;

  setOrdersListState(List<OrdersData> ordersListState) {
    this.ordersListState = ordersListState;
    notifyListeners();
  }

  addAllOrdersListState(List<OrdersData> ordersListState) {
    this.ordersListState.addAll(ordersListState);
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////////
  List<OrdersData> cancelOrdersListState = [];

  List<OrdersData> getCancelOrdersListState() => cancelOrdersListState;

  setCancelOrdersListState(List<OrdersData> cancelOrdersListState) {
    this.cancelOrdersListState = cancelOrdersListState;
    notifyListeners();
  }

  addAllCancelOrdersListState(List<OrdersData> cancelOrdersListState) {
    this.cancelOrdersListState.addAll(cancelOrdersListState);
    notifyListeners();
  }

/////////////////////////////////////////////////////////////////////////////////
  List<OrdersData> deliveredOrdersListState = [];

  List<OrdersData> getDeliveredOrdersListState() => deliveredOrdersListState;

  setDeliveredOrdersListState(List<OrdersData> deliveredOrdersListState) {
    this.deliveredOrdersListState = deliveredOrdersListState;
    notifyListeners();
  }

  addAllDeliveredOrdersListState(List<OrdersData> deliveredOrdersListState) {
    this.deliveredOrdersListState.addAll(deliveredOrdersListState);
    notifyListeners();
  }
}
