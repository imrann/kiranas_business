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
  FirebaseAuth.instance.currentUser().then((currentUser) => {
        UserDetailsSP().getUserDetails().then((value) {
          Future.delayed(Duration(seconds: 2), () {
            if (currentUser != null) {
              currentUser.getIdToken().then((token) {
                print(token.toString());

                LoginController()
                    .isUserAdmin(value["userPhone"])
                    .then((isUserAdmin) {
                  if (isUserAdmin == "true") {
                    runApp(MyApp("HomePage", value["userName"],
                        value["userPhone"], value["userId"]));
                  } else {
                    runApp(MyApp("NoAdminScreen", value["userName"],
                        value["userPhone"], value["userId"]));
                  }
                });
              });
            } else {
              runApp(MyApp("LoginPage", value["userName"], value["userPhone"],
                  value["userId"]));
            }
          });
        })
      });
  runApp(MyApp("SplashScreen", "No User", "No Number", "No uID"));
}

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

class MyApp extends StatelessWidget {
  MyApp(this.redirect, this.userName, this.phone, this.userID);

  final String redirect;
  final String userName;
  final String phone;
  final String userID;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: colorCustom,
            accentColor: colorCustom1,

            ///C2185B
            // primaryColor: colorCustom,
            // // buttonColor: Colors.teal,
            // backgroundColor: colorCustom1,
            // // //put primaryColorLight..wher ever u encounters backgroundcolor
            // primaryColorLight: colorCustom1,
            // primaryColorDark: Colors.black,
            // splashColor: Colors.white,
            // highlightColor: Colors.grey[500],
            // // cardColor: Colors.orangeAccent[400],
            // errorColor: Colors.red,
            // cursorColor: Colors.white

            // canvasColor: colorCustom,
          ),
          home: _getStartupScreens(redirect, context),
        ));
  }

  Widget _getStartupScreens(String redirectPage, BuildContext context) {
    print(redirectPage);
    if (redirectPage == "NoAdminScreen") {
      return NoAdminScreen();
    } else if (redirectPage == "LoginPage") {
      return Login();
    } else if (redirectPage == "HomePage") {
      return Home(
        user: userName.toString(),
        phone: phone.toString(),
        userID: userID.toString(),
      );
    } else if (redirectPage == "SplashScreen") {
      return Splash();
    }

    return Maintainance();
  }
}
