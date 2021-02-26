import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kirnas_business/CommonScreens/OrderFilterCategoryList.dart';
import 'package:kirnas_business/Controllers/OrderController.dart';
import 'package:kirnas_business/StateManager/CancelledOrderState.dart';
import 'package:kirnas_business/StateManager/DeliveredOrderState.dart';
import 'package:kirnas_business/StateManager/OpenOrderState.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

final DateFormat format = new DateFormat("dd-MM-yyyy");
final DateFormat formatDate = new DateFormat("EEE, d/M/y");

class OrderFilter extends StatefulWidget {
  final Function setIsMoreOrdersAvailable;
  final String orderType;
  final List<String> mainOrderCategoryList;

  OrderFilter(
      {this.setIsMoreOrdersAvailable,
      this.orderType,
      this.mainOrderCategoryList});

  @override
  _OrderFilterState createState() => _OrderFilterState();
}

class _OrderFilterState extends State<OrderFilter> {
  ProgressDialog progressDialog;

  Map<String, dynamic> deliveredOrderStateLocal = {
    "Date Of Purchase": "select date",
    "Date Of Delivery": "select date",
    "isNotifcationCue": false
  };
  Map<String, dynamic> cancelledOrderState = {
    "Date Of Purchase": "select date",
    "Date Of Cancellation": "select date",
    "isNotifcationCue": false
  };
  Map<String, dynamic> openOrderState = {
    "Date Of Purchase": "select date",
    "Status": "NOT SELECTED",
    "isNotifcationCue": false
  };
  @override
  void initState() {
    super.initState();
    if (widget.orderType.contains("Delivered")) {
      var localDeliveredFilterState =
          Provider.of<DeliveredOrderState>(context, listen: false);
      deliveredOrderStateLocal
          .addAll(localDeliveredFilterState.getDeliveredOrderState());
    } else if (widget.orderType.contains("Cancelled")) {
      var localCancelledFilterState =
          Provider.of<CancelledOrderState>(context, listen: false);
      cancelledOrderState
          .addAll(localCancelledFilterState.getCancelledOrderState());
    } else if (widget.orderType.contains("Open")) {
      var localOpenFilterState =
          Provider.of<OpenOrderState>(context, listen: false);
      openOrderState.addAll(localOpenFilterState.getOpenOrderState());
    }
  }

  int selectedIndex = 0;
  Future<bool> _onBackPressed() {
    print("backPressed");
    var localOpenFilterState =
        Provider.of<OpenOrderState>(context, listen: false);
    var localDeliveredFilterState =
        Provider.of<DeliveredOrderState>(context, listen: false);
    var localCancelledFilterState =
        Provider.of<CancelledOrderState>(context, listen: false);
    localOpenFilterState.setActiveFilter("Date Of Purchase");
    localDeliveredFilterState.setActiveFilter("Date Of Purchase");

    localCancelledFilterState.setActiveFilter("Date Of Purchase");

    Navigator.of(context).pop(true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Applying Filters...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.60,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filters",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                FlatButton(
                    onPressed: () {
                      clearFilter();
                      Fluttertoast.showToast(
                          msg: "Cleared",
                          fontSize: 10,
                          backgroundColor: Colors.black);
                    },
                    child: Text(
                      "CLEAR ALL",
                      style: TextStyle(fontSize: 12, color: Colors.pink[900]),
                    )),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.grey[300], Colors.white])),
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: filtercategoryMainList(),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.grey[100], Colors.white])),
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: filtercategorySubList(),
                      )
                    ],
                  )
                ],
              ),
            ),
            ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minWidth: MediaQuery.of(context).size.width * 0.4,
              height: 30,
              child: RaisedButton(
                splashColor: Colors.white,
                color: Colors.pink[900],
                elevation: 5,
                onPressed: () {
                  applyFilters();
                },
                child: Text("APPLY",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearFilter() {
    if (widget.orderType.contains("Delivered")) {
      var deliveredOrderdFilterState =
          Provider.of<DeliveredOrderState>(context, listen: false);

      setState(() {
        deliveredOrderStateLocal.addAll({
          "Date Of Purchase": "select date",
          "Date Of Delivery": "select date",
          "isNotifcationCue": false
        });
      });
      deliveredOrderdFilterState.setIsClearFilter(true);
    } else if (widget.orderType.contains("Cancelled")) {
      var cancelledOrderdFilterState =
          Provider.of<CancelledOrderState>(context, listen: false);

      setState(() {
        cancelledOrderState.addAll({
          "Date Of Purchase": "select date",
          "Date Of Cancellation": "select date",
          "isNotifcationCue": false
        });
      });
      cancelledOrderdFilterState.setIsClearFilter(true);
    } else if (widget.orderType.contains("Open")) {
      var openOrderdFilterState =
          Provider.of<OpenOrderState>(context, listen: false);

      setState(() {
        openOrderState.addAll({
          "Date Of Purchase": "select date",
          "Status": "NOT SELECTED",
          "isNotifcationCue": false
        });
      });
      openOrderdFilterState.setIsClearFilter(true);
    }
  }

  applyFilters() {
    progressDialog.show().then((isShown) {
      if (isShown) {
        if (widget.orderType.contains("Delivered")) {
          var deliveredOrderdFilterState =
              Provider.of<DeliveredOrderState>(context, listen: false);

          if (deliveredOrderdFilterState.getIsClearFilter()) {
            OrderController().getOrdersOnlyByType("Delivered").then((value) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState.setDeliveredOrdersListState(value);
              deliveredOrderdFilterState.clearAll();
              Navigator.of(context).pop();
              progressDialog.hide();
            });
            setState(() {
              widget.setIsMoreOrdersAvailable();
            });
          } else {
            deliveredOrderdFilterState
                .setDeliveredOrderState(deliveredOrderStateLocal);
            print(deliveredOrderdFilterState.getDeliveredOrderState());
            OrderController()
                .getProductByFilter(
                    dop: deliveredOrderdFilterState
                                .getDeliveredOrderState()["Date Of Purchase"] ==
                            "select date"
                        ? null
                        : deliveredOrderdFilterState
                            .getDeliveredOrderState()["Date Of Purchase"],
                    dod: deliveredOrderdFilterState
                                .getDeliveredOrderState()["Date Of Delivery"] ==
                            "select date"
                        ? null
                        : deliveredOrderdFilterState
                            .getDeliveredOrderState()["Date Of Delivery"],
                    status: "Delivered")
                .then((deliveredOrderFiltered) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState
                  .setDeliveredOrdersListState(deliveredOrderFiltered);
              deliveredOrderdFilterState.setActiveFilter("Date Of Purchase");
              Navigator.of(context).pop();
              progressDialog.hide();
            }).catchError((err) {
              progressDialog.hide();
              Fluttertoast.showToast(
                  msg: "Something went wrong! please try later",
                  fontSize: 10,
                  backgroundColor: Colors.black);
              print(err.toString());
            });
          }
        } else if (widget.orderType.contains("Cancelled")) {
          var cancelledOrderdFilterState =
              Provider.of<CancelledOrderState>(context, listen: false);

          if (cancelledOrderdFilterState.getIsClearFilter()) {
            OrderController().getOrdersOnlyByType("Cancelled").then((value) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState.setCancelOrdersListState(value);
              cancelledOrderdFilterState.clearAll();
              Navigator.of(context).pop();
              progressDialog.hide();
            });
            setState(() {
              widget.setIsMoreOrdersAvailable();
            });
          } else {
            cancelledOrderdFilterState
                .setCancelledOrderState(cancelledOrderState);

            OrderController()
                .getProductByFilter(
                    dop: cancelledOrderdFilterState
                                .getCancelledOrderState()["Date Of Purchase"] ==
                            "select date"
                        ? null
                        : cancelledOrderdFilterState
                            .getCancelledOrderState()["Date Of Purchase"],
                    doc: cancelledOrderdFilterState.getCancelledOrderState()[
                                "Date Of Cancellation"] ==
                            "select date"
                        ? null
                        : cancelledOrderdFilterState
                            .getCancelledOrderState()["Date Of Cancellation"],
                    status: "Cancelled")
                .then((cancelledOrderFiltered) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState.setCancelOrdersListState(cancelledOrderFiltered);
              cancelledOrderdFilterState.setActiveFilter("Date Of Purchase");
              Navigator.of(context).pop();
              progressDialog.hide();
            }).catchError((err) {
              progressDialog.hide();
              Fluttertoast.showToast(
                  msg: "Something went wrong! please try later",
                  fontSize: 10,
                  backgroundColor: Colors.black);
              print(err.toString());
            });
          }
        } else if (widget.orderType.contains("Open")) {
          var openOrderdFilterState =
              Provider.of<OpenOrderState>(context, listen: false);

          if (openOrderdFilterState.getIsClearFilter()) {
            OrderController().getOrdersOnlyByType("Open").then((value) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState.setOrdersListState(value);
              openOrderdFilterState.clearAll();
              Navigator.of(context).pop();
              progressDialog.hide();
            });
            setState(() {
              widget.setIsMoreOrdersAvailable();
            });
          } else {
            openOrderdFilterState.setOpenOrderState(openOrderState);

            OrderController()
                .getProductByFilter(
                    dop: openOrderdFilterState
                                .getOpenOrderState()["Date Of Purchase"] ==
                            "select date"
                        ? null
                        : openOrderdFilterState
                            .getOpenOrderState()["Date Of Purchase"],
                    trackingStatus: openOrderdFilterState
                                .getOpenOrderState()["Status"] ==
                            "NOT SELECTED"
                        ? null
                        : openOrderdFilterState.getOpenOrderState()["Status"],
                    status: "Open")
                .then((openOrderFiltered) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState.setOrdersListState(openOrderFiltered);
              openOrderdFilterState.setActiveFilter("Date Of Purchase");
              Navigator.of(context).pop();
              progressDialog.hide();
            }).catchError((err) {
              progressDialog.hide();
              Fluttertoast.showToast(
                  msg: "Something went wrong! please try later",
                  fontSize: 10,
                  backgroundColor: Colors.black);
              print(err.toString());
            });
          }
        }
      }
    });
  }

  filtercategorySubList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer3<DeliveredOrderState, OpenOrderState, CancelledOrderState>(
            builder: (context, deliveredOrderData, openOrderData,
                cancelledOrderData, child) {
          if (widget.orderType.contains("Delivered")) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  splashColor: Colors.pink[900],
                  elevation: 0,
                  onPressed: () {
                    showDate();
                  },
                  child: Row(
                    children: [
                      Text(deliveredOrderStateLocal[
                                  deliveredOrderData.getActiveFilter()]
                              .toString()
                              .contains("select")
                          ? "Select Date"
                          : "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(deliveredOrderStateLocal[deliveredOrderData.getActiveFilter()])))}"),
                      SizedBox(width: 20),
                      Icon(Icons.calendar_today)
                    ],
                  ),
                )
              ],
            );
          } else if (widget.orderType.contains("Cancelled")) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  elevation: 0,
                  onPressed: () {
                    showDate();
                  },
                  child: Row(
                    children: [
                      Text(cancelledOrderState[
                                  cancelledOrderData.getActiveFilter()]
                              .toString()
                              .contains("select")
                          ? "Select Date"
                          : "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(cancelledOrderState[cancelledOrderData.getActiveFilter()])))}"),
                      SizedBox(width: 20),
                      Icon(Icons.calendar_today)
                    ],
                  ),
                ),
              ],
            );
          } else if (widget.orderType.contains("Open")) {
            List<String> openOrderFilterCategorySubList =
                OrderFilterCategoryList().getOpenOrderFilterCategorySubList();

            if (openOrderData.getActiveFilter().contains("Date Of Purchase")) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      showDate();
                    },
                    child: Row(
                      children: [
                        Text(openOrderState[openOrderData.getActiveFilter()]
                                .toString()
                                .contains("select")
                            ? "Select Date"
                            : "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(openOrderState[openOrderData.getActiveFilter()])))}"),
                        SizedBox(width: 20),
                        Icon(Icons.calendar_today)
                      ],
                    ),
                  ),
                ],
              );
            } else if (openOrderData.getActiveFilter().contains("Status")) {
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: openOrderFilterCategorySubList.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          children: [
                            //openOrderFilterCategorySubList[index]
                            ListTile(
                              //openOrderStateStatus
                              onTap: () {
                                if (!openOrderFilterCategorySubList[index]
                                    .contains(openOrderState["Status"])) {
                                  setState(() {
                                    openOrderState["Status"] =
                                        openOrderFilterCategorySubList[index];
                                  });
                                  openOrderData.setIsClearFilter(false);
                                } else {
                                  setState(() {
                                    openOrderState["Status"] =
                                        openOrderFilterCategorySubList[index];
                                  });
                                }
                              },
                              dense: true,
                              title: Text(
                                openOrderFilterCategorySubList[index]
                                    .toString(),
                                style: TextStyle(
                                    color:
                                        (openOrderFilterCategorySubList[index]
                                                .contains(
                                                    openOrderState["Status"]))
                                            ? Colors.red
                                            : Colors.grey),
                              ),
                            ),
                            Divider(
                              thickness: 0,
                            )
                          ],
                        ),
                      );
                    }),
              );
            } else {
              return Text("Try Again!!");
            }
          } else {
            return Text("Try Again!!");
          }
        }),

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [FlatButton(onPressed: () {}, child: Text("Select Date"))],
        // )
      ],
    );
  }

  showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink[900],
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    ).then((date) {
      var formattedDate = format.format(date);
      var epochConvertedDate = date.millisecondsSinceEpoch;
      print(formattedDate.toString() + "  " + epochConvertedDate.toString());

      // print(date1);
      if (widget.orderType.contains("Delivered")) {
        var deliveredOrderdFilterState =
            Provider.of<DeliveredOrderState>(context, listen: false);

        setState(() {
          deliveredOrderStateLocal.update(
              deliveredOrderdFilterState.getActiveFilter(),
              (v) => epochConvertedDate.toString());
          deliveredOrderStateLocal.update("isNotifcationCue", (v) => true);
        });
        deliveredOrderdFilterState.setIsClearFilter(false);

        print(deliveredOrderStateLocal);
        print(deliveredOrderdFilterState.getDeliveredOrderState());
      } else if (widget.orderType.contains("Cancelled")) {
        var cancelledOrderdFilterState =
            Provider.of<CancelledOrderState>(context, listen: false);

        setState(() {
          cancelledOrderState.update(
              cancelledOrderdFilterState.getActiveFilter(),
              (v) => epochConvertedDate.toString());
          cancelledOrderState.update("isNotifcationCue", (v) => true);
        });
        cancelledOrderdFilterState.setIsClearFilter(false);
      } else if (widget.orderType.contains("Open")) {
        var openOrderdFilterState =
            Provider.of<OpenOrderState>(context, listen: false);

        setState(() {
          openOrderState.update(openOrderdFilterState.getActiveFilter(),
              (v) => epochConvertedDate.toString());
          openOrderState.update("isNotifcationCue", (v) => true);
        });
        openOrderdFilterState.setIsClearFilter(false);
        print(openOrderState);
        print(openOrderdFilterState.getOpenOrderState());
      }
    }).catchError((err) {});
    return "";
  }

  filtercategoryMainList() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: widget.mainOrderCategoryList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              if (widget.orderType.contains("Delivered")) {
                var deliveredOrderdFilterState =
                    Provider.of<DeliveredOrderState>(context, listen: false);
                deliveredOrderdFilterState
                    .setActiveFilter(widget.mainOrderCategoryList[index]);
              } else if (widget.orderType.contains("Cancelled")) {
                var cancelledOrderFilterState =
                    Provider.of<CancelledOrderState>(context, listen: false);
                cancelledOrderFilterState
                    .setActiveFilter(widget.mainOrderCategoryList[index]);
              } else if (widget.orderType.contains("Open")) {
                var openOrderFilterState =
                    Provider.of<OpenOrderState>(context, listen: false);
                openOrderFilterState
                    .setActiveFilter(widget.mainOrderCategoryList[index]);
              }
            },
            selected: selectedIndex == index ? true : false,
            selectedTileColor: Colors.grey[100],
            title: Text(widget.mainOrderCategoryList[index],
                style: TextStyle(color: Colors.black, fontSize: 13)),
          );
        },
      ),
    );
  }
}
