import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:kirnas_business/CommonScreens/ErrorPage.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/CommonScreens/OrderFilterCategoryList.dart';
import 'package:kirnas_business/Controllers/OrderController.dart';
import 'package:kirnas_business/CustomWidgets/OrderFIlter.dart';
import 'package:kirnas_business/Podo/OrdersData.dart';
import 'package:kirnas_business/StateManager/CancelledOrderState.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;
FloatingActionButtonLocation totalFab = FloatingActionButtonLocation.endDocked;
final DateFormat formatDate = new DateFormat("EEE, d/M/y");
final DateFormat format = new DateFormat.jms();

Future<dynamic> cancelledOrdersList;

class CancelledOrders extends StatefulWidget {
  @override
  _CancelledOrdersState createState() => _CancelledOrdersState();
}

class _CancelledOrdersState extends State<CancelledOrders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _controller = ScrollController();

  bool isPaginationActive;
  bool isMoreOrdersAvailable;
  bool isGetMoreOrders;

  getCancelledOrdersChunk() {
    cancelledOrdersList = OrderController().getOrdersOnlyByType("Cancelled");

    cancelledOrdersList.then((value) {
      var localCancelledFilterState =
          Provider.of<CancelledOrderState>(context, listen: false);
      localCancelledFilterState.clearAll();

      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      ordersListState.setCancelOrdersListState(value);
    });
  }

  getPaginatedOrdersOnlyByType() {
    print("Step2");
    if (isMoreOrdersAvailable && isGetMoreOrders) {
      setState(() {
        isPaginationActive = true;
        isGetMoreOrders = false;
      });

      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      List<OrdersData> currentCancelledOrderListState =
          ordersListState.getCancelOrdersListState();

      String lastOrderID = currentCancelledOrderListState[
              (currentCancelledOrderListState.length) - 1]
          .orderData
          .orderID;
      int lastOUpdateDate = currentCancelledOrderListState[
              (currentCancelledOrderListState.length) - 1]
          .orderData
          .oUpdateDate;

      Future deliveredOrdersPaginatedList = OrderController()
          .getPaginatedOrdersOnlyByType(
              "Cancelled", lastOrderID, lastOUpdateDate);
      deliveredOrdersPaginatedList.then((value) {
        List<dynamic> paginatedData = value;
        print(paginatedData.length.toString());
        if (paginatedData.length != 0) {
          var ordersListState =
              Provider.of<OrdersListState>(context, listen: false);
          ordersListState.addAllCancelOrdersListState(value);
        } else {
          setState(() {
            isMoreOrdersAvailable = false;
          });
          Fluttertoast.showToast(
              msg: "No more orders !!",
              fontSize: 10,
              backgroundColor: Colors.black);
        }
        setState(() {
          isPaginationActive = false;
          isGetMoreOrders = true;
        });
      });
    }
  }

  @override
  void initState() {
    isPaginationActive = false;
    isMoreOrdersAvailable = true;
    isGetMoreOrders = true;
    fab = FloatingActionButtonLocation.endFloat;

    // TODO: implement initState
    super.initState();

    getCancelledOrdersChunk();
    _controller.addListener(_scrollListener);
  }

  _scrollListener() {
    double maxScroll = _controller.position.maxScrollExtent;
    double currentScroll = _controller.position.pixels;
    double delta = MediaQuery.of(context).size.height * 0.1;
    if (maxScroll - currentScroll <= delta && isMoreOrdersAvailable) {
      getPaginatedOrdersOnlyByType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Container(
        child: getOrders(),
      ),
      floatingActionButtonLocation: fab,

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      //specify the location of the FAB

      floatingActionButton: FloatingActionButton(
          mini: true,
          child: new Stack(
            children: <Widget>[
              new Icon(
                Icons.filter_alt_outlined,
                color: Colors.white,
                size: 25,
              ),
              new Positioned(
                right: 0.01,
                child: Consumer<CancelledOrderState>(
                    builder: (context, data, child) {
                  if (data.getCancelledOrderState()["isNotifcationCue"]) {
                    return Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          backgroundColor: Colors.pink[900],
          splashColor: Colors.white,
          onPressed: () {
            filter(context, 0.60);
          }),
    );
  }

  filter(BuildContext context, double bottomSheetHeight) {
    return showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                return new Container(
                  // height: 500,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height *
                            bottomSheetHeight,
                        // width: MediaQuery.of(context).size.height * 0.95,
                        child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OrderFilter(
                                orderType: "Cancelled",
                                mainOrderCategoryList: OrderFilterCategoryList()
                                    .getCancelledOrderFilterCategoryList(),
                              )),
                        ),
                      )
                      //  displayUpiApps(),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }

  Widget getOrders() {
    return FutureBuilder<dynamic>(
      future: cancelledOrdersList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          var data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("No Cancelled Orders",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Scrollbar(child:
                Consumer<OrdersListState>(builder: (context, orders, child) {
              var orderListState = orders.getCancelOrdersListState();
              if (orderListState.length > 0) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          controller: _controller,
                          padding: const EdgeInsets.only(
                              bottom: kFloatingActionButtonMargin + 100,
                              top: kFloatingActionButtonMargin + 60),

                          //controller: _scrollController,

                          itemCount: orderListState.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(3, 10, 3, 0),
                                  child: Card(
                                    elevation: 1.0,
                                    child: ExpansionTile(
                                      //tilePadding: EdgeInsets.all(5),

                                      title: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 7, 0, 7),
                                        child: Row(
                                          children: [
                                            Text("Order ID: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                            Text(
                                                orderListState[index]
                                                    .orderData
                                                    .orderID,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15))
                                          ],
                                        ),
                                      ),

                                      subtitle: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Tracking status       " +
                                                          orderListState[index]
                                                              .orderData
                                                              .oTrackingStatus
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(

                                                    // "Dop                           " +

                                                    //     orderListState[index]

                                                    //         .orderData

                                                    //         .oDop

                                                    //         .toString(),

                                                    "Dop                           " +
                                                        "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(orderListState[index].orderData.oDop))}" +
                                                        "  " +
                                                        "${format.format(new DateTime.fromMillisecondsSinceEpoch(orderListState[index].orderData.oDop))}",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12)),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                              child: Row(
                                                children: [
                                                  Text("Est delivery time    ",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12)),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(2)),
                                                    child: Container(
                                                      color: Colors.pink[900],
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text("n/a",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      children: <Widget>[
                                        Container(

                                            //   height: 100,

                                            color: Colors.grey[100],
                                            child: inventoryCard1(
                                                orderListState[index])),
                                      ],
                                    ),
                                  ),
                                ),

                                // Divider(

                                //   thickness: 0,

                                //   indent: 0,

                                //   endIndent: 0,

                                // )
                              ],
                            );
                          }),
                    ),
                    isPaginationActive
                        ? CircularProgressIndicator()
                        : SizedBox()
                  ],
                );
              } else {
                return Center(
                  child: Text("No Cancelled Orders!!"),
                );
              }
            }));
          }
        } else {
          return FancyLoader(
            loaderType: "list",
          );
        }
      },
    );
  }

  Widget inventoryCard1(OrdersData orderListState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
      child: Column(
        children: [
          Row(
            children: [
              Text("Order Details:",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          inventoryCardDetailsList(orderListState),
          SizedBox(
            height: 5,
          ),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          inventoryCardDetails(
              "Delivery Address",
              orderListState.orderData.oUserAddress.address +
                  "\n" +
                  orderListState.orderData.oUserAddress.landmark +
                  "\n" +
                  orderListState.orderData.oUserAddress.locality +
                  "\n" +
                  orderListState.orderData.oUserAddress.state +
                  "\n" +
                  orderListState.orderData.oUserAddress.city +
                  "\n" +
                  orderListState.orderData.oUserAddress.pincode),
          SizedBox(
            height: 5,
          ),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          inventoryCardDetails("Bill Details",
              orderListState.orderData.oBillTotal.totalAmt.toString()),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          Row(
            children: [
              Text("Call Customer",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),
              Flexible(
                child: FlatButton(
                  child: Text(orderListState.orderData.oUserPhone,
                      style: TextStyle(
                          color: Colors.blue[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  onPressed: () {
                    UrlLauncher.launch(
                        "tel:${orderListState.orderData.oUserPhone}");
                  },
                ),
              )
            ],
          ),
          Divider(thickness: 0.5, endIndent: 5, color: Colors.grey[300]),
          Row(
            children: [
              Text("Actions:",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
                "ORDER CANCELLED ON :" +
                    "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(orderListState.orderData.oUpdateDate))}" +
                    "  " +
                    "${format.format(new DateTime.fromMillisecondsSinceEpoch(orderListState.orderData.oUpdateDate))}",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12)),
          ])
        ],
      ),
    );
  }

  inventoryCardDetailsList(OrdersData orderListState) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: orderListState.orderData.oProducts.length,
        itemBuilder: (context, index) {
          return Table(
            columnWidths: {
              0: FlexColumnWidth(5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      orderListState.orderData.oProducts[index].productName
                          .toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12))
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                      "x " +
                          orderListState.orderData.oProducts[index].productQty
                              .toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(
                      "\u20B9 " +
                          (int.parse(orderListState
                                      .orderData.oProducts[index].productQty) *
                                  (int.parse(orderListState.orderData
                                          .oProducts[index].productMrp) -
                                      ((orderListState
                                                  .orderData
                                                  .oProducts[index]
                                                  .productOffPercentage /
                                              100) *
                                          int.parse(orderListState.orderData
                                              .oProducts[index].productMrp))))
                              .toString(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 12)),
                ]),
              ])
            ],
          );
        });
  }

  Widget inventoryCardDetails(String titleName, String titleValue) {
    return Column(
      children: [
        Row(
          children: [
            Text(titleName + ":",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 12)),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Flexible(
              child: Text(titleValue,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 12)),
            )
          ],
        ),
      ],
    );
  }
}
