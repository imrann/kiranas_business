import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kirnas_business/CommonScreens/ErrorPage.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/CommonScreens/OrderFilterCategoryList.dart';
import 'package:kirnas_business/Controllers/OrderController.dart';
import 'package:kirnas_business/CustomWidgets/OrderFIlter.dart';
import 'package:kirnas_business/Podo/OrdersData.dart';
import 'package:kirnas_business/StateManager/OpenOrderState.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

FloatingActionButtonLocation fab = FloatingActionButtonLocation.endDocked;
FloatingActionButtonLocation totalFab = FloatingActionButtonLocation.endDocked;

final DateFormat formatDate = new DateFormat("EEE, d/M/y");
final DateFormat format = new DateFormat.jms();
final DateFormat formatForEstTime = new DateFormat("dd-MM-yyyy");

Future<dynamic> openOrdersList;

class OpenOrders extends StatefulWidget {
  @override
  _OpenOrdersState createState() => _OpenOrdersState();
}

class _OpenOrdersState extends State<OpenOrders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String estSeletedDate;
  List<bool> _selection = new List<bool>();
  String formattedTomorrowDate;
  String formattedTodayDate;
  ProgressDialog progressDialog;

  @override
  void initState() {
    fab = FloatingActionButtonLocation.endFloat;

    // TODO: implement initState
    super.initState();

    var now = new DateTime.now();
    var tomorrowDate = new DateTime(now.year, now.month, now.day + 1);

    formattedTomorrowDate = formatForEstTime.format(tomorrowDate);
    formattedTodayDate = formatForEstTime.format(now);

    estSeletedDate = formattedTomorrowDate;
    _selection = [false, true, false];

    openOrdersList = OrderController().getOrdersOnlyByType("Open");

    openOrdersList.then((value) {
      var localOpenFilterState =
          Provider.of<OpenOrderState>(context, listen: false);
      localOpenFilterState.clearAll();

      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      ordersListState.setOrdersListState(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Processing...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

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
                child:
                    Consumer<OpenOrderState>(builder: (context, data, child) {
                  if (data.getOpenOrderState()["isNotifcationCue"]) {
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
            // var searchDateState =
            //     Provider.of<StateManager>(context, listen: false);
            // searchDateState.setSearchDate("WholeList");

            // searchDateState.setClearFilter(false);
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
                                orderType: "Open",
                                mainOrderCategoryList: OrderFilterCategoryList()
                                    .getOpenOrderFilterCategoryList(),
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
      future: openOrdersList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          var data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("No Open Orders",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Scrollbar(child:
                Consumer<OrdersListState>(builder: (context, orders, child) {
              List<OrdersData> orderListState = orders.getOrdersListState();
              for (var item in orderListState) {
                print(item.orderData.oProducts.toString());
              }
              if (orderListState.length > 0) {
                return ListView.builder(
                    //controller: _scrollController,
                    padding: const EdgeInsets.only(
                        bottom: kFloatingActionButtonMargin + 100,
                        top: kFloatingActionButtonMargin + 60),
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
                                            Flexible(
                                              child: Container(
                                                child: Text(
                                                    orderListState[index]
                                                        .orderData
                                                        .oEstDelivaryTime
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12)),
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
                  child: Text("No Open Orders!!"),
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
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (orderListState.orderData.oTrackingStatus == "Placed")
                  ? actionButtons([
                      {
                        'buttonColor': Colors.red[900],
                        'buttonLabel': 'CANCEL ORDER',
                        'buttonStatus': 'Cancelled by owner'
                      },
                      {
                        'buttonColor': Colors.green[900],
                        'buttonLabel': 'ACCEPT ORDER',
                        'buttonStatus': 'Accepted'
                      }
                    ], orderListState)
                  : (orderListState.orderData.oTrackingStatus == "Accepted")
                      ? actionButtons([
                          {
                            'buttonColor': Colors.red[900],
                            'buttonLabel': 'CANCEL ORDER',
                            'buttonStatus': 'Cancelled by owner'
                          },
                          {
                            'buttonColor': Colors.green[900],
                            'buttonLabel': 'OUT FOR DELIVERY',
                            'buttonStatus': 'Out for Delivery'
                          }
                        ], orderListState)
                      : (orderListState.orderData.oTrackingStatus ==
                              "Out for Delivery")
                          ? actionButtons([
                              {
                                'buttonColor': Colors.red[900],
                                'buttonLabel': 'CANCEL ORDER',
                                'buttonStatus': 'Cancelled by owner'
                              },
                              {
                                'buttonColor': Colors.green[900],
                                'buttonLabel': 'ORDER DELIVERED',
                                'buttonStatus': 'Delivered'
                              }
                            ], orderListState)
                          : [
                              Text(
                                  "Something went wrong, please contact Admin!")
                            ])
        ],
      ),
    );
  }

  actionButtons(List<Map<String, dynamic>> actionButtonsDetails,
      OrdersData orderListState) {
    List<Widget> actionButtons = [];
    for (var item in actionButtonsDetails) {
      actionButtons.add(
        ButtonTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          minWidth: MediaQuery.of(context).size.width * 0.2,
          height: 20,
          child: RaisedButton(
            splashColor: Colors.white,
            color: item['buttonColor'],
            elevation: 5,
            onPressed: () {
              if (item['buttonLabel'] == "ACCEPT ORDER") {
                getEstDeliveryPopUp(context, orderListState, item);
              } else {
                updateOrderStatus(orderListState, item);
              }
            },
            child: Text(item['buttonLabel'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
          ),
        ),
      );
    }
    return actionButtons;
  }

  getEstDeliveryPopUp(BuildContext context, OrdersData orderListState,
      Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return ButtonBarTheme(
                data: ButtonBarThemeData(alignment: MainAxisAlignment.center),
                child: AlertDialog(
                  content: Text(
                    "EST DELIVERY DATE" + "\n\n" + estSeletedDate,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Column(
                      children: [
                        Row(
                          children: [
                            ToggleButtons(
                              children: [
                                Text("Today"),
                                Text("Tomorrow"),
                                Icon(Icons.calendar_today_outlined)
                              ],
                              borderColor: Colors.grey,
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              borderWidth: 2,
                              selectedBorderColor: Colors.pink[900],
                              selectedColor: Colors.pink[900],
                              splashColor: Colors.pink[900],
                              isSelected: _selection,
                              onPressed: (int index) {
                                setModalState(() {
                                  switch (index) {
                                    case 0:
                                      _selection = [true, false, false];
                                      estSeletedDate = formattedTodayDate;
                                      break;
                                    case 1:
                                      _selection = [false, true, false];
                                      estSeletedDate = formattedTomorrowDate;

                                      break;
                                    case 2:
                                      _selection = [false, false, true];
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2015),
                                        lastDate: DateTime(2050),
                                        builder: (BuildContext context,
                                            Widget child) {
                                          return Theme(
                                            data: ThemeData.dark().copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Colors.pink[900],
                                                onPrimary: Colors.white,
                                                surface: Colors.white,
                                                onSurface: Colors.grey,
                                              ),
                                              dialogBackgroundColor:
                                                  Colors.white,
                                            ),
                                            child: child,
                                          );
                                        },
                                      ).then((date) {
                                        print(date);
                                        var date1 =
                                            formatForEstTime.format(date);

                                        setModalState(() {
                                          estSeletedDate = date1;
                                        });
                                      }).catchError((err) {});
                                      break;
                                    default:
                                      _selection = [false, false, false];
                                  }
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            FlatButton(
                              color: Colors.white,
                              splashColor: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, right: 0),
                                child: Text(
                                  "ACCEPT ORDER",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.pink[900]),
                                ),
                              ),
                              onPressed: () {
                                updateOrderStatus(orderListState, item);
                              },
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ));
          },
        );
      },
    );
  }

  updateOrderStatus(OrdersData orderListState, Map<String, dynamic> item) {
    progressDialog.show().then((isShown) {
      if (isShown) {
        OrderController()
            .updateOrderStatus(
                orderID: orderListState.orderData.orderID,
                status: item['buttonStatus'],
                est: estSeletedDate)
            .then((isActionSuccessfull) {
          if (isActionSuccessfull == "true") {
            openOrdersList = OrderController().getOrdersOnlyByType("Open");

            openOrdersList.then((value) {
              var ordersListState =
                  Provider.of<OrdersListState>(context, listen: false);
              ordersListState.setOrdersListState(value);
              progressDialog.hide().then((isHidden) {
                if (orderListState.orderData.oTrackingStatus == "Placed") {
                  Navigator.of(context).pop();
                }

                Fluttertoast.showToast(
                    msg: "Action Successfull!!",
                    fontSize: 10,
                    backgroundColor: Colors.black);
              });
            });
          }
        }).catchError((err) {
          progressDialog.hide();
          Fluttertoast.showToast(
              msg: "Something went wrong! please try later",
              fontSize: 10,
              backgroundColor: Colors.black);
          print(err.toString());
        });
      }
    });
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
