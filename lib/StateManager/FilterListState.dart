import 'package:flutter/material.dart';

class FilterListState extends ChangeNotifier {
  bool productFilterNotification = false;
  bool getProductFilterNotification() => productFilterNotification;

  setProductFilterNotification(bool productFilterNotification) {
    this.productFilterNotification = productFilterNotification;
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////
  clearAllProductFilter() {
    this.sFilterDiscountCategory.clear();
    this.sFilterProductCategory.clear();
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////////
  String activeFilter = "";

  String getActiveFilter() => activeFilter;

  setActiveFilter(String activeFilterName) {
    this.activeFilter = activeFilterName;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////
  List<String> filterProductCategory = [];

  List<String> getFilterProductCategory() => filterProductCategory;

  setFilterProductCategory(List<String> filterProductCategory) {
    this.filterProductCategory = filterProductCategory;
    notifyListeners();
  }

  List<String> sFilterProductCategory = [];
  List<String> getSFilterProductCategory() => sFilterProductCategory;

  setSFilterProductCategory(List<String> productCategory) {
    this.sFilterProductCategory.addAll(productCategory);
    notifyListeners();
  }

  clearSFilterProductCategory() {
    this.sFilterProductCategory.clear();
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////

  List<String> filterDiscountCategory = [];

  List<String> getFilterDiscountCategory() => filterDiscountCategory;

  setFilterDiscountCategory(List<String> filterDiscountCategory) {
    this.filterDiscountCategory = filterDiscountCategory;
    notifyListeners();
  }

  List<String> sFilterDiscountCategory = [];
  List<String> getSFilterDiscountCategory() => sFilterDiscountCategory;

  setSFilterDiscountCategory(List<String> discountCategory) {
    this.sFilterDiscountCategory.addAll(discountCategory);
    notifyListeners();
  }

  clearSFilterDiscountCategory() {
    this.sFilterDiscountCategory.clear();
    notifyListeners();
  }

  removeSAllFilterDiscountCategory() {
    this.sFilterDiscountCategory.clear();
    notifyListeners();
  }
}
