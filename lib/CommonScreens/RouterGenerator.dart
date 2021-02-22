import 'package:flutter/material.dart';
import 'package:kirnas_business/Screens/Login.dart';
import 'package:kirnas_business/Screens/Home.dart';
import 'package:kirnas_business/Screens/Orders.dart';
import 'package:kirnas_business/CustomWidgets/AddProduct.dart';
import 'package:kirnas_business/Screens/TransactionScreen.dart';
import 'package:kirnas_business/Screens/ProductDetails.dart';
import 'package:kirnas_business/Screens/NoAdminScreen.dart';
import 'package:kirnas_business/Screens/Maintainance.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    // final args = settings.arguments;

    switch (settings.name) {
      case '/Login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/Home':
        final Home args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => Home(
            phone: args.phone,
            user: args.user,
            userID: args.userID,
          ),
        );
      case '/':
        final Home args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => Home(
            phone: args.phone,
            user: args.user,
            userID: args.userID,
          ),
        );
      case '/Orders':
        final Orders args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => Orders(initialTabIndex: args.initialTabIndex),
        );
      case '/TransactionScreen':
        return MaterialPageRoute(
          builder: (_) => TransactionScreen(),
        );
      case '/AddProduct':
        final AddProduct args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => AddProduct(
              isUpdateProduct: args.isUpdateProduct,
              prouctDetail: args.prouctDetail),
        );
      case '/NoAdminScreen':
        return MaterialPageRoute(
          builder: (_) => NoAdminScreen(),
        );
      case '/Maintainance':
        return MaterialPageRoute(
          builder: (_) => Maintainance(),
        );
      case '/ProductDetails':
        final ProductDetails args = settings.arguments;

        return MaterialPageRoute(
          builder: (_) => ProductDetails(
              heroIndex: args.heroIndex, productDetailsL: args.productDetailsL),
        );

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
