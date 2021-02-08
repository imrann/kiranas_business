import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirnas_business/Screens/Orders.dart';
import 'package:kirnas_business/StateManager/FilterListState.dart';
import 'package:kirnas_business/StateManager/MiscellaneousState.dart';
import 'package:kirnas_business/StateManager/OrdersListState.dart';
import 'package:kirnas_business/StateManager/ProductListState.dart';
import 'package:provider/provider.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:kirnas_business/Screens/Home.dart';
import 'package:kirnas_business/Screens/Login.dart';
import 'package:kirnas_business/Screens/Maintainance.dart';
import 'package:kirnas_business/Screens/Splash.dart';

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

                runApp(MyApp("HomePage", value["userName"], value["userPhone"],
                    value["userId"]));
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
        ],
        child: MaterialApp(
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
          routes: <String, WidgetBuilder>{
            //app routes
            '/Home': (BuildContext context) => Home(),
            '/Orders': (BuildContext context) => Orders(),
          },
        ));
  }

  Widget _getStartupScreens(String redirectPage, BuildContext context) {
    print(redirectPage);

    if (redirectPage == "LoginPage") {
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
