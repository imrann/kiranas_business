import 'package:flutter/material.dart';
import 'package:kirnas_business/CommonScreens/OrderFilterCategoryList.dart';
import 'package:kirnas_business/CustomWidgets/OrderFIlter.dart';
import 'package:kirnas_business/StateManager/DeliveredOrderState.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:intl/intl.dart';

import 'package:kirnas_business/CommonScreens/ErrorPage.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/Controllers/OrderController.dart';
import 'package:kirnas_business/Podo/OrdersData.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:provider/provider.dart';

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;
FloatingActionButtonLocation totalFab = FloatingActionButtonLocation.endDocked;

final DateFormat formatDate = new DateFormat("EEE, d/M/y");
final DateFormat format = new DateFormat.jms();

Future<dynamic> deliveredOrdersList;

class DeliveredOrders extends StatefulWidget {
  @override
  _DeliveredOrdersState createState() => _DeliveredOrdersState();
}

class _DeliveredOrdersState extends State<DeliveredOrders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fab = FloatingActionButtonLocation.endFloat;

    // TODO: implement initState
    super.initState();

    deliveredOrdersList = OrderController().getOrdersOnlyByType("Delivered");

    deliveredOrdersList.then((value) {
      var localDeliveredFilterState =
          Provider.of<DeliveredOrderState>(context, listen: false);
      localDeliveredFilterState.clearAll();

      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      ordersListState.setDeliveredOrdersListState(value);
    });
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
                child: Consumer<DeliveredOrderState>(
                    builder: (context, data, child) {
                  if (data.getDeliveredOrderState()["isNotifcationCue"]) {
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

          // Icon(
          //   Icons.filter_alt_outlined,
          //   color: Colors.white,
          // ),
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
                                orderType: "Delivered",
                                mainOrderCategoryList: OrderFilterCategoryList()
                                    .getDeliveredOrderFilterCategoryList(),
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
      future: deliveredOrdersList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          var data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("No Delivered Orders",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Consumer<OrdersListState>(builder: (context, orders, child) {
              var orderListState = orders.getDeliveredOrdersListState();
              if (orderListState.length > 0) {
                return ListView.builder(
                    padding: const EdgeInsets.only(
                        bottom: kFloatingActionButtonMargin + 100,
                        top: kFloatingActionButtonMargin + 60),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),

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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 0, 7),
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
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15))
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              "Dop                           " +
                                                  "${formatDate.format(new DateTime.fromMillisecondsSinceEpoch(orderListState[index].orderData.oDop))}" +
                                                  "  " +
                                                  "${format.format(new DateTime.fromMillisecondsSinceEpoch(orderListState[index].orderData.oDop))}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              child: Container(
                                                color: Colors.pink[900],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text("n/a",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                    });
              } else {
                return Center(
                  child: Text("No Delivered Orders!!"),
                );
              }
            });
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
                "ORDER DELIVERED ON :" +
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
