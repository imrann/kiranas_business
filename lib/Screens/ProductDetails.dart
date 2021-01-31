import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';
import 'package:kirnas_business/Podo/Product.dart';
import 'package:kirnas_business/Screens/DrawerTiles.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

bool isItemPresentInCart = false;

class ProductDetails extends StatefulWidget {
  ProductDetails({this.productDetails, this.heroIndex});

  final Product productDetails;
  final String heroIndex;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProgressDialog progressDialogotp;
  int produstQtyCounter = 1;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    progressDialogotp = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotp.style(
        message: "Adding item to cart..",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
        searchOwner: "OrdersSearch",
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.pink[100], Colors.white]))),
          Positioned(
            top: 70,
            left: 0,
            right: 0,
            child: Hero(
              tag: widget.heroIndex,
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image:
                    'http://clipart-library.com/images_k/food-transparent-background/food-transparent-background-7.png',
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 30.0, bottom: 30.0, left: 0),
                    child: new Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                            onPressed: () {},
                            color: Colors.pink[900],
                            child: Row(children: <Widget>[
                              Text('UPDATE ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                              Icon(
                                Icons.update_outlined,
                                size: 25,
                                color: Colors.white,
                              )
                            ]),
                          ),
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
                            onPressed: () {},
                            color: Colors.pink[900],
                            child: Icon(
                              Icons.delete_outlined,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.productDetails.productData.productName,
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.productDetails.productData
                                        .productBrand,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.productDetails.productData
                                            .productNetWeight +
                                        "  " +
                                        widget.productDetails.productData
                                            .productUnit,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "\u20B9" +
                                        widget.productDetails.productData
                                            .productMrp,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 15),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    widget.productDetails.productData
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
                                    (int.parse(widget.productDetails.productData
                                                .productMrp) -
                                            ((int.parse(widget
                                                        .productDetails
                                                        .productData
                                                        .productOffPercentage) /
                                                    100) *
                                                int.parse(widget.productDetails
                                                    .productData.productMrp)))
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
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: new Text(
                              "Description" +
                                  "\n" +
                                  widget.productDetails.productData
                                      .productDescription,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontStyle: FontStyle.italic),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            "Category: " +
                                widget
                                    .productDetails.productData.productCategory,
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                //  color: Colors.grey,
              )),
        ],
      ),

      // Center(
      //   child: Hero(
      //     tag: widget.heroIndex,
      //     child: FadeInImage.memoryNetwork(
      //       placeholder: kTransparentImage,
      //       image:
      //           'http://clipart-library.com/images_k/food-transparent-background/food-transparent-background-7.png',
      //     ),
      //   ),
      // ),
    );
  }
}
