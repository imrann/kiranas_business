import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:kirnas_business/Controllers/ProductController.dart';
import 'package:kirnas_business/CustomWidgets/ProductFilter.dart';
import 'package:kirnas_business/Screens/Home.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:kirnas_business/StateManager/FilterListState.dart';
import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

bool l_isSearch;
String selectedDateTime;

class AppBarCommon extends StatefulWidget implements PreferredSizeWidget {
  AppBarCommon(
      {this.title,
      this.subTitle,
      this.trailingIcon,
      this.profileIcon,
      this.centerTile,
      this.context,
      this.route,
      this.notificationCount,
      this.isTabBar,
      this.isSearch,
      this.searchOwner,
      this.tabController});

  final Widget title;
  final Widget subTitle;
  final IconData trailingIcon;
  final IconData profileIcon;
  final bool centerTile;
  final BuildContext context;
  final Widget route;
  final Widget notificationCount;
  final bool isTabBar;
  final bool isSearch;
  final String searchOwner;
  final TabController tabController;

  @override
  _AppBarCommonState createState() => _AppBarCommonState();
  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _AppBarCommonState extends State<AppBarCommon> {
  ProgressDialog progressDialogotp;

  @override
  void initState() {
    super.initState();
    l_isSearch = widget.isSearch;
  }

  @override
  Widget build(BuildContext context) {
    progressDialogotp = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotp.style(
        message: " Logging Out...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);
    return AppBar(
      bottom: getTabBar(isTabBar: widget.isTabBar),
      centerTitle: widget.centerTile,
      elevation: 0.0,
      // backgroundColor:Theme.of(context).primaryColor,
      title: l_isSearch != null
          ? getSearchBox()
          : getTitle(title: widget.title, subTitle: widget.subTitle),
      actions: <Widget>[
        SizedBox(width: 5),
        getIcon(widget.profileIcon, context, widget.route,
            widget.notificationCount),
        l_isSearch != null
            ? getIcon(Icons.close, context, null, null)
            : getIcon(widget.trailingIcon, context, widget.route,
                widget.notificationCount),
      ],
      bottomOpacity: 1,
      backgroundColor:
          widget.searchOwner == "pDetails" ? Colors.transparent : Colors.white,
      brightness: Brightness.light,
    );
  }

  Widget getSearchBox() {
    return TextFormField(
      cursorColor: Colors.black,
      autofocus: true,
      readOnly: false,
      validator: null,
      enabled: true,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        hintText: "Search by name...",
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
      ),
      keyboardType: TextInputType.text,
      onChanged: (text) {
        searchStart(dynamicSearchText: text, listAllData: false);
      },
    );
  }

  searchStart({String dynamicSearchText, bool listAllData}) {
    switch (widget.searchOwner) {
      case "ProductSearch":
        {
          setState(() {
            if (listAllData || dynamicSearchText == "") {
              productList = ProductController().getProductList();
            } else {
              productList =
                  ProductController().getProuctSearchList(dynamicSearchText);
            }

            productList.then((value) {
              var productState =
                  Provider.of<ProductListState>(context, listen: false);
              productState.setProductListState(value);
            }).catchError((err) {});
          });
        }
        break;

      default:
        {
          //progressDialog.hide();
        }
        break;
    }
  }

  PreferredSizeWidget getTabBar({bool isTabBar}) {
    if (isTabBar) {
      return TabBar(
        tabs: [
          Tab(
            text: "OPEN",
          ),
          Tab(text: "DELIVERED"),
          Tab(text: "CANCELLED"),
        ],
        indicatorColor: Colors.pink[900],
        indicatorSize: TabBarIndicatorSize.tab,
        controller: widget.tabController,
      );
    } else {
      return null;
    }
  }

  Widget getIcon(IconData icon, BuildContext context, Widget route,
      Widget notificationCount) {
    final IconData notificationIcon = Icons.notifications;
    final IconData productFilterIcon = Icons.filter_alt_outlined;

    final IconData cartIcon = Icons.shopping_cart_outlined;

    if (null != icon) {
      return new Container(
        child: Row(
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(100),
              child: (productFilterIcon == icon)
                  ? getProductNotificationBadge()
                  : Icon(icon),
              onTap: () async {
                if (icon == Icons.search) {
                  print("search");
                  setState(() {
                    l_isSearch = true;
                  });
                } else if (icon == Icons.close) {
                  print("close search");

                  searchStart(listAllData: true);
                  setState(() {
                    l_isSearch = null;
                  });
                  var filter =
                      Provider.of<FilterListState>(context, listen: false);
                  filter.clearAllProductFilter();
                } else if (icon == Icons.filter_alt_outlined) {
                  filter(context, 0.90);
                } else if (icon == Icons.logout) {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  progressDialogotp.hide().then((isHidden) {
                    if (isHidden) {
                      UserDetailsSP().logOutUser();

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/Login',
                        ModalRoute.withName('/Login'),
                      );

                      // Navigator.push(
                      //     context, MaterialPageRoute(builder: (context) => Login()));
                    }
                  });
                }
                //  else if (icon == Icons.search) {
                //   print("calender");
                //   showDatePicker(
                //     context: context,
                //     initialDate: DateTime.now(),
                //     firstDate: DateTime(2020),
                //     lastDate: DateTime(2030),
                //   ).then((date) {
                //     setState(() {
                //       if (widget.searchOwner == "Transactions") {
                //       } else {}

                //       // Navigator.push(
                //       //     context,
                //       //     MaterialPageRoute(
                //       //         builder: (context) => SlotBooking(
                //       //               phone: widget.phone,
                //       //               user: widget.user,
                //       //               date: selectedDateTime,
                //       //               userID: widget.userID,
                //       //               userRole: role,
                //       //             )));
                //     });
                //   });
                // }
                else {
                  print("Notification");
                }

                //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Maintainance()),);
              },
            ),
            SizedBox(width: 15),
          ],
        ),
      );
    } else {
      return SizedBox(width: 0);
    }
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
                              child: ProductFilter()),
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

  Widget getProductNotificationBadge() {
    return new Stack(
      children: <Widget>[
        new Icon(
          Icons.filter_alt_outlined,
          size: 25,
        ),
        new Positioned(
          right: 0.01,
          child: Consumer<FilterListState>(builder: (context, data, child) {
            if (data.getProductFilterNotification()) {
              return Container(
                padding: EdgeInsets.all(2),
                decoration: new BoxDecoration(
                  color: Colors.pink[900],
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
    );
  }

  Widget getTitle({Widget title, Widget subTitle}) {
    if (title != null && subTitle != null) {
      return new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[title],
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[subTitle],
            )
          ],
        ),
      );
    } else if (title != null && subTitle == null) {
      return Container(
        child: title,
      );
    } else {
      return new Text("");
    }
  }
}
