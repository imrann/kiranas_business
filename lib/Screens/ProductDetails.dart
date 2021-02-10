import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kirnas_business/CommonScreens/ErrorPage.dart';

import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/CommonScreens/SlideRightRoute.dart';
import 'package:kirnas_business/Controllers/ProductController.dart';
import 'package:kirnas_business/CustomWidgets/AddProduct.dart';
import 'package:kirnas_business/Podo/Product.dart';
import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

bool isItemPresentInCart = false;

Future<dynamic> productDetails;

class ProductDetails extends StatefulWidget {
  ProductDetails({this.productDetailsL, this.heroIndex});

  final Product productDetailsL;
  final String heroIndex;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProgressDialog progressDialogotp;
  int produstQtyCounter = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productDetails =
        ProductController().getProductByID(widget.productDetailsL.productID);

    productDetails.then((value) {
      var productDetailsState =
          Provider.of<ProductListState>(context, listen: false);
      productDetailsState.setProductState(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    progressDialogotp = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotp.style(
        message: "Editing Item..",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      // appBar: new AppBarCommon(
      //   centerTile: false,
      //   context: context,
      //   notificationCount: Text("i"),
      //   isTabBar: false,
      //   searchOwner: "pDetails",
      // ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.pink[100], Colors.white])),
          child: getProductDetails()),
      bottomNavigationBar: FutureBuilder<dynamic>(
        future: productDetails,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;

            return ErrorPage(error: error.toString());
          } else if (snapshot.hasData) {
            List<Product> data = snapshot.data;

            if (data.isEmpty || data.length == 0) {
              return Center(
                child: Text("Loading..!",
                    style: TextStyle(
                        color: Colors.black,
                        //fontWeight: FontWeight.bold,
                        fontSize: 15)),
              );
            } else {
              return BottomAppBar(
                elevation: 0,
                child: Consumer<ProductListState>(
                    builder: (context, product, child) {
                  List<Product> productList = product.getProductState();
                  if (productList.length != 0) {
                    return getBottonButtons(productList);
                  } else {
                    return Center(child: Text(""));
                  }
                }),
              );
            }
          } else {
            return FancyLoader(
              loaderType: "sLine",
            );
          }
        },
      ),
    );
  }

  getBottonButtons(List<Product> productList) {
    return Container(
      color: Colors.pink[100],
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [

          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                child: RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                  splashColor: Colors.white,
                  onPressed: () {
                    var productDetailsState =
                        Provider.of<ProductListState>(context, listen: false);
                    Navigator.push(
                        context,
                        SlideRightRoute(
                            widget: AddProduct(
                              isUpdateProduct: true,
                              prouctDetail:
                                  productDetailsState.getProductState()[0],
                            ),
                            slideAction: "horizontal"));
                  },
                  color: Colors.pink[900],
                  child: Row(children: <Widget>[
                    Text('UPDATE ',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                    Icon(
                      Icons.update_outlined,
                      size: 25,
                      color: Colors.white,
                    )
                  ]),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.1,
                height: 40,
                child: RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topLeft: Radius.circular(5)),
                  ),
                  splashColor: Colors.white,
                  onPressed: () {
                    progressDialogotp.show().then((isShown) {
                      if (isShown) {
                        ProductController()
                            .disContinueProduct(
                                productID: widget.productDetailsL.productID,
                                discontinueAction:
                                    productList[0].productData.discontinue
                                        ? false
                                        : true)
                            .then((result) {
                          if (result == "true") {
                            productDetails = ProductController().getProductByID(
                                widget.productDetailsL.productID);

                            productDetails.then((value) {
                              var productDetailsState =
                                  Provider.of<ProductListState>(context,
                                      listen: false);
                              productDetailsState.setProductState(value);
                              dynamic productListS =
                                  ProductController().getProductList();
                              productListS.then((value) {
                                var productState =
                                    Provider.of<ProductListState>(context,
                                        listen: false);
                                productState.setProductListState(value);
                              }).catchError((err) {
                                progressDialogotp.hide();
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "$err",
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 5),
                                ));
                              });

                              progressDialogotp.hide().then((isHidden) {
                                if (isHidden) {
                                  Fluttertoast.showToast(
                                      msg: productDetailsState
                                              .getProductState()[0]
                                              .productData
                                              .discontinue
                                          ? "Item Discontinued!"
                                          : "Item Restored!",
                                      fontSize: 10,
                                      backgroundColor: Colors.black);
                                }
                              });
                            });
                          }
                        }).catchError((err) {
                          progressDialogotp.hide();
                          Fluttertoast.showToast(
                              msg: "Something went wrong! please try later",
                              fontSize: 10,
                              backgroundColor: Colors.black);
                          print(err.toString());
                        });
                      }
                    });
                  },
                  color: Colors.pink[900],
                  child: productList[0].productData.discontinue
                      ? Row(
                          children: [
                            Text("RESTORE",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Icon(
                              Icons.restore_from_trash_rounded,
                              size: 25,
                              color: Colors.white,
                            )
                          ],
                        )
                      : Icon(
                          Icons.delete_outline_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  getProductDetails() {
    return FutureBuilder<dynamic>(
      future: productDetails,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;

          return ErrorPage(error: error.toString());
        } else if (snapshot.hasData) {
          List<Product> data = snapshot.data;

          if (data.isEmpty || data.length == 0) {
            return Center(
              child: Text("No Details Available!",
                  style: TextStyle(
                      color: Colors.black,
                      //fontWeight: FontWeight.bold,
                      fontSize: 15)),
            );
          } else {
            return Consumer<ProductListState>(
                builder: (context, product, child) {
              List<Product> productList = product.getProductState();
              if (productList.length != 0) {
                return ListView(
                  children: [
                    Container(
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        alignment: Alignment.center,
                        image: productList[0].productData.productUrl,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              productList[0].productData.productName,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    productList[0].productData.productBrand,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    productList[0]
                                            .productData
                                            .productNetWeight +
                                        "  " +
                                        productList[0].productData.productUnit,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "\u20B9" +
                                        productList[0].productData.productMrp,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 15),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    productList[0]
                                            .productData
                                            .productOffPercentage +
                                        "%" +
                                        " off",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "\u20B9",
                                    style: TextStyle(
                                        color: Colors.green[500], fontSize: 25),
                                  ),
                                  Text(
                                    (int.parse(productList[0]
                                                .productData
                                                .productMrp) -
                                            ((int.parse(productList[0]
                                                        .productData
                                                        .productOffPercentage) /
                                                    100) *
                                                int.parse(productList[0]
                                                    .productData
                                                    .productMrp)))
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.green[500], fontSize: 50),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Flexible(
                            child: new Text(
                              "Description" +
                                  "\n" +
                                  productList[0].productData.productDescription,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            "Category: " +
                                productList[0].productData.productCategory,
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text("No Details Available!"));
              }
            });
          }
        } else {
          return FancyLoader(
            loaderType: "logo",
          );
        }
      },
    );
  }
}
