import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kirnas_business/CommonScreens/AppBarCommon.dart';
import 'package:kirnas_business/Screens/DrawerNav.dart';

class NoAdminScreen extends StatefulWidget {
  @override
  _NoAdminScreenState createState() => _NoAdminScreenState();
}

class _NoAdminScreenState extends State<NoAdminScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'NO',
                  style: TextStyle(color: Colors.pink[900]),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  'YES',
                  style: TextStyle(color: Colors.pink[900]),
                ),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: new AppBarCommon(
        title: Text(
          "",
          style: TextStyle(fontSize: 18),
        ),
        trailingIcon: Icons.logout,
        centerTile: false,
        context: context,
        notificationCount: Text("i"),
        isTabBar: false,
      ),

      // backgroundColor: Theme.of(context).backgroundColor,
      body: WillPopScope(onWillPop: _onBackPressed, child: noAdminMsg()),

      //specify the location of the FAB
    );
  }

  Widget noAdminMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.dangerous,
              color: Colors.redAccent,
              size: 100,
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hi there!",
              style: TextStyle(fontSize: 30, color: Colors.grey),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "The kiranas does'nt recognizes you as an admin",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Please ask other admins/super admin to to add you'r phone number as admin.",
                overflow: TextOverflow.visible,
                maxLines: 2,
                softWrap: true,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            )
          ],
        )
      ],
    );
  }
}
