import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:shimmer/shimmer.dart';

import 'Home.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((currentUser) => {
          UserDetailsSP().getUserDetails().then((value) {
            Future.delayed(Duration(seconds: 2), () {
              if (currentUser != null) {
                currentUser.getIdToken().then((token) {
                  print(token.toString());

                  Navigator.of(context).pushNamed('/Home', arguments: Home());
                });
              } else {
                Navigator.pushNamed(context, '/Login');
              }
            });
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Shimmer.fromColors(
                      baseColor: Colors.pink[900],
                      period: Duration(milliseconds: 1000),
                      highlightColor: Colors.pink[100],
                      child: Text(
                        'BRANDED BANIYA',
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 70.0,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Everything below MRP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      wordSpacing: 1,
                      fontStyle: FontStyle.italic),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
