import 'package:flutter/material.dart';
import 'package:kirnas_business/Podo/Orders.dart';
import 'package:kirnas_business/Podo/OrdersData.dart';

class OrdersListState extends ChangeNotifier {
  List<OrdersData> ordersListState = [];

  List<OrdersData> getOrdersListState() => ordersListState;

  setOrdersListState(List<OrdersData> ordersListState) {
    this.ordersListState = ordersListState;
    notifyListeners();
  }

  List<OrdersData> cancelOrdersListState = [];

  List<OrdersData> getCancelOrdersListState() => cancelOrdersListState;

  setCancelOrdersListState(List<OrdersData> cancelOrdersListState) {
    this.cancelOrdersListState = cancelOrdersListState;
    notifyListeners();
  }

  List<OrdersData> deliveredOrdersListState = [];

  List<OrdersData> getDeliveredOrdersListState() => deliveredOrdersListState;

  setDeliveredOrdersListState(List<OrdersData> deliveredOrdersListState) {
    this.deliveredOrdersListState = deliveredOrdersListState;
    notifyListeners();
  }
}
