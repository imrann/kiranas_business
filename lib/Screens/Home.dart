import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kirnas_business/CommonScreens/ErrorPage.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/CommonScreens/SlideRightRoute.dart';
import 'package:kirnas_business/Controllers/OrderController.dart';
import 'package:kirnas_business/Controllers/ProductController.dart';
import 'package:kirnas_business/Podo/Product.dart';
import 'package:kirnas_business/Screens/OpenOrders.dart';
import 'package:kirnas_business/Screens/Transactions.dart';
import 'package:kirnas_business/Screens/Orders.dart';
import 'package:kirnas_business/Screens/ProductDetails.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'DrawerNav.dart';

Future<dynamic> productList;

FloatingActionButtonLocation fab = FloatingActionButtonLocation.centerFloat;
FloatingActionButtonLocation miniFab = FloatingActionButtonLocation.centerFloat;

class Home extends StatefulWidget {
  final String user;
  final String phone;
  final String userID;
  Home({this.user, this.phone, this.userID});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ProgressDialog progressDialog;

  @override
  void initState() {
    fab = FloatingActionButtonLocation.centerFloat;
    miniFab = FloatingActionButtonLocation.miniEndFloat;

    super.initState();
    openOrdersList = OrderController().getOrdersOnlyByType("Open");
    openOrdersList.then((value) {
      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      ordersListState.setOrdersListState(value);
    });

    productList = ProductController().getProductList();
    productList.then((value) {
      var productState = Provider.of<ProductListState>(context, listen: false);
      productState.setProductListState(value);
    }).catchError((err) {
      progressDialog.hide();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "$err",
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 5),
      ));
    });
  }

  void updateTabSelection(int index, String buttonText) {
    setState(() {
      selectedIndex = index;
      text = buttonText;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: Text("ALL PRODUCTS"),
        profileIcon: Icons.search,
        trailingIcon: Icons.filter_alt_outlined,
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "ProductSearch",
      ),
      drawer: Drawer(
        child: DrawerNav(
          phoneNo: widget.phone,
          userName: widget.user,
          userRole: "User",
        ),
      ),
      body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Center(
            child: productListUI(),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getIconButton(0, "Home", Icons.home),
              getIconButton(1, "Orders", Icons.archive),

              //getIconButton(1, "Orders", Icons.),
              // FlatButton(
              //     onPressed: () {
              //       updateTabSelection(1, "Orders");

              //     },
              //     child: Text(
              //       "ORDERS",
              //       style: TextStyle(
              //           color: Colors.grey[400],
              //           fontSize: 17,
              //           fontWeight: FontWeight.bold),
              //     )),

              //to leave space in between the bottom app bar items and below the FAB

              getIconButton(2, "Transactions", Icons.compare_arrows_sharp)
            ],
          ),
        ),
        //to add a space between the FAB and BottomAppBar
        shape: CircularNotchedRectangle(),
        //color of the BottomAppBar
        color: Colors.white,
      ),
    );

    /// );
  }

  Widget productListUI() {
    return FutureBuilder<dynamic>(
      future: productList,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          List<Product> data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("0 Products!",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Scrollbar(child:
                Consumer<ProductListState>(builder: (context, product, child) {
              List<Product> productList = product.getProductListState();
              if (productList.length != 0) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.7),
                  itemCount: productList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                            context,
                            SlideRightRoute(
                                widget: ProductDetails(
                                  productDetails: productList[index],
                                  heroIndex: "productDetails$index",
                                ),
                                slideAction: "horizontal"));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => ProductDetails(
                        //               productDetails: productList[index],
                        //             )));
                      },
                      child: new Card(
                        elevation: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.center,
                                    colors: [Colors.pink[100], Colors.white])),
                            child: new GridTile(
                              child: Hero(
                                tag: "productDetails$index",
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image:
                                      'http://clipart-library.com/images_k/food-transparent-background/food-transparent-background-7.png',
                                ),
                              ),
                              header: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      productList[index]
                                              .productData
                                              .productNetWeight +
                                          "  " +
                                          productList[index]
                                              .productData
                                              .productUnit,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              footer: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Text(
                                              productList[index]
                                                  .productData
                                                  .productName,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: 12),
                                          Text(
                                            "Rs. " +
                                                productList[index]
                                                    .productData
                                                    .productMrp,
                                            style: TextStyle(
                                                color: Colors.black,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 12),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            productList[index]
                                                    .productData
                                                    .productOffPercentage +
                                                "%" +
                                                " off",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            productList[index]
                                                .productData
                                                .productBrand,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ), //just for testing, will fill with image later
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("0 Search Result!"));
              }
            }));
          }
        } else {
          return FancyLoader(
            loaderType: "Grid",
          );
        }
      },
    );
  }

  Widget getIconButton(int sIndex, String pageName, IconData pageIcon) {
    if (sIndex == 1) {
      return FlatButton(
          onPressed: () {
            Navigator.push(context, SlideRightRoute(widget: Orders()));

            updateTabSelection(0, "Home");
          },
          child: new Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                child: new Text(
                  "ORDERS",
                  style: TextStyle(
                      color: selectedIndex == sIndex
                          ? Colors.pink[900]
                          : Colors.grey[400],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
              new Positioned(
                right: 0,
                top: 0,
                child: new Container(
                    padding: EdgeInsets.all(0),
                    decoration: new BoxDecoration(
                      color: Colors.pink[900],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 13,
                      minHeight: 10,
                    ),
                    child: Consumer<OrdersListState>(
                        builder: (context, data, child) {
                      return Text(
                        data.getOrdersListState().length.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    })),
              ),
            ],
          ));
    } else {
      return IconButton(
        //update the bottom app bar view each time an item is clicked
        onPressed: () {
          updateTabSelection(sIndex, pageName);
          switch (pageName) {
            case "Home":
              {
                updateTabSelection(0, "Home");
              }
              break;

            case "Transactions":
              {
                updateTabSelection(0, "Home");
                //  Navigator.push(context, SlideRightRoute(widget: Cart()));
                Navigator.push(
                    context, SlideRightRoute(widget: Transactions()));
              }
              break;

            default:
              {}
              break;
          }
        },
        iconSize: 27.0,
        icon: new Icon(
          pageIcon,
          //darken the icon if it is selected or else give it a different color
          color: selectedIndex == sIndex ? Colors.pink[900] : Colors.grey[400],
        ),
      );
    }
  }
}
