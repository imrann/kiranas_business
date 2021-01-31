import 'package:flutter/material.dart';
import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';
import 'package:kirnas_business/Screens/CancelledOrders.dart';
import 'package:kirnas_business/Screens/DeliveredOrders.dart';
import 'package:kirnas_business/Screens/OpenOrders.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: new AppBarCommon(
          //  title: Text("ORDERS"),
          profileIcon: Icons.search,
          trailingIcon: Icons.filter_alt_outlined,
          centerTile: false,
          context: context,
          notificationCount: Text("i"),
          isTabBar: true,
          searchOwner: "OrdersSearch",
        ),
        body: TabBarView(
          children: [
            OpenOrders(),
            DeliveredOrders(),
            CancelledOrders()
            // DeliveredOrders(),
            // CancelledOrders()
          ],
        ),
      ),
    );
  }
}
