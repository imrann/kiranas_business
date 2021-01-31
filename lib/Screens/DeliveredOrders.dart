import 'package:flutter/material.dart';
import 'package:kirnas_business/CommonScreens/ErrorPage.dart';
import 'package:kirnas_business/CommonScreens/FancyLoader.dart';
import 'package:kirnas_business/Controllers/OrderController.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:provider/provider.dart';

Future<dynamic> deliveredOrdersList;

class DeliveredOrders extends StatefulWidget {
  @override
  _DeliveredOrdersState createState() => _DeliveredOrdersState();
}

class _DeliveredOrdersState extends State<DeliveredOrders> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliveredOrdersList = OrderController().getOrdersOnlyByType("Delivered");

    deliveredOrdersList.then((value) {
      var ordersListState =
          Provider.of<OrdersListState>(context, listen: false);
      ordersListState.setDeliveredOrdersListState(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: getOrders(),
      ),
    );
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
            return Scrollbar(child:
                Consumer<OrdersListState>(builder: (context, orders, child) {
              var orderListState = orders.getDeliveredOrdersListState();
              if (orderListState.length > 0) {
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,

                        //controller: _scrollController,

                        itemCount: orderListState.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            color: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    isThreeLine: true,
                                    title: Text(
                                      orderListState[index].orderData.oStatus,
                                    ),
                                    subtitle: Text(
                                      orderListState[index]
                                          .orderData
                                          .oBillTotal
                                          .totalAmt,
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0,
                                    indent: 80,
                                    endIndent: 15,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                );
              } else {
                return Center(
                  child: Text("No Delivered Orders!!"),
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
}
