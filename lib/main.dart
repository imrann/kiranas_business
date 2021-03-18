import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirnas_business/Controllers/LoginController.dart';
import 'package:kirnas_business/StateManager/CancelledOrderState.dart';
import 'package:kirnas_business/StateManager/DeliveredOrderState.dart';
import 'package:kirnas_business/StateManager/FilterListState.dart';
import 'package:kirnas_business/StateManager/MiscellaneousState.dart';
import 'package:kirnas_business/StateManager/OpenOrderState.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:kirnas_business/CommonScreens/RouterGenerator.dart';

import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:kirnas_business/StateManager/TransactionState.dart';
import 'package:provider/provider.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:kirnas_business/Screens/Home.dart';
import 'package:kirnas_business/Screens/Login.dart';
import 'package:kirnas_business/Screens/Maintainance.dart';
import 'package:kirnas_business/Screens/Splash.dart';

import 'package:kirnas_business/Screens/NoAdminScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(136, 14, 79, .1),
      100: Color.fromRGBO(136, 14, 79, .2),
      200: Color.fromRGBO(136, 14, 79, .3),
      300: Color.fromRGBO(136, 14, 79, .4),
      400: Color.fromRGBO(136, 14, 79, .5),
      500: Color.fromRGBO(136, 14, 79, .6),
      600: Color.fromRGBO(136, 14, 79, .7),
      700: Color.fromRGBO(136, 14, 79, .8),
      800: Color.fromRGBO(136, 14, 79, .9),
      900: Color.fromRGBO(136, 14, 79, 1),
    };
    MaterialColor colorCustom = MaterialColor(0xFFffffff, color);
    MaterialColor colorCustom1 = MaterialColor(0xFFf48fb1, color);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProductListState()),
          ChangeNotifierProvider(create: (context) => OrdersListState()),
          ChangeNotifierProvider(create: (context) => FilterListState()),
          ChangeNotifierProvider(create: (context) => MiscellaneousState()),
          ChangeNotifierProvider(create: (context) => TransactionState()),
          ChangeNotifierProvider(create: (context) => DeliveredOrderState()),
          ChangeNotifierProvider(create: (context) => OpenOrderState()),
          ChangeNotifierProvider(create: (context) => CancelledOrderState()),
        ],
        child: MaterialApp(
          onGenerateRoute: RouterGenerator.generateRoute,

          // routes: {
          //   //app routes
          //   '/Login': (context) => Login(),
          //   '/Home': (context) => Home(),
          //   '/Orders': (context) => Orders(),
          //   '/TransactionScreen': (context) => TransactionScreen(),
          //   '/AddProduct': (context) => AddProduct(),

          //   '/NoAdminScreen': (context) => NoAdminScreen(),
          //   '/Maintainance': (context) => Maintainance(),
          //   '/ProductDetails': (context) => ProductDetails(),
          //   '/Splash': (context) => Splash(),
          // },
          title: 'Braded Baniya Business',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: colorCustom,
            accentColor: colorCustom1,
          ),

          initialRoute: "/",
        ));
  }
}
