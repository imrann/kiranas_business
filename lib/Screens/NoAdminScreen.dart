import 'package:flutter/material.dart';

class NoAdminScreen extends StatefulWidget {
  @override
  _NoAdminScreenState createState() => _NoAdminScreenState();
}

class _NoAdminScreenState extends State<NoAdminScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      extendBodyBehindAppBar: false,
      body: noAdminMsg(),

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
