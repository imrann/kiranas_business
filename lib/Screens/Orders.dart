import 'package:flutter/material.dart';
import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';
import 'package:kirnas_business/Screens/CancelledOrders.dart';
import 'package:kirnas_business/Screens/DeliveredOrders.dart';
import 'package:kirnas_business/Screens/OpenOrders.dart';
import 'package:kirnas_business/StateManager/CancelledOrderState.dart';
import 'package:kirnas_business/StateManager/DeliveredOrderState.dart';
import 'package:kirnas_business/StateManager/OpenOrderState.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  final String initialTabIndex;
  Orders({this.initialTabIndex});
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    var localOpenFilterState =
        Provider.of<OpenOrderState>(context, listen: false);
    var localDeliveredFilterState =
        Provider.of<DeliveredOrderState>(context, listen: false);
    var localCancelledFilterState =
        Provider.of<CancelledOrderState>(context, listen: false);
    localOpenFilterState.clearAll();
    localDeliveredFilterState.clearAll();

    localCancelledFilterState.clearAll();

    Navigator.of(context).pop(true);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: int.parse(widget.initialTabIndex),
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
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: TabBarView(
            children: [
              new OpenOrders(),
              new DeliveredOrders(),
              new CancelledOrders()
              // DeliveredOrders(),
              // CancelledOrders()
            ],
          ),
        ),
      ),
    );
  }
}
