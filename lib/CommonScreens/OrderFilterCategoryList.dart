class OrderFilterCategoryList {
  List<String> openOrderFilterCategoryList = [
    "Date Of Purchase",
    "Status",
  ];

  List<String> getOpenOrderFilterCategoryList() => openOrderFilterCategoryList;
////////////////////////////////////////////////////////////////////////////////
  List<String> cancelledOrderFilterCategoryList = [
    "Date Of Purchase",
    "Date Of Cancellation",
  ];

  List<String> getCancelledOrderFilterCategoryList() =>
      cancelledOrderFilterCategoryList;
////////////////////////////////////////////////////////////////////////////////
  List<String> deliveredOrderFilterCategoryList = [
    "Date Of Purchase",
    "Date Of Delivery",
  ];

  List<String> getDeliveredOrderFilterCategoryList() =>
      deliveredOrderFilterCategoryList;

////////////////////////////////////////////////////////////////////////////////
  List<String> openOrderFilterCategorySubList = [
    "Placed",
    "Accepted",
    "Out for Delivery"
  ];

  List<String> getOpenOrderFilterCategorySubList() =>
      openOrderFilterCategorySubList;
}
