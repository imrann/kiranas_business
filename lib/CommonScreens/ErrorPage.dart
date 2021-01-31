import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Oops!",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 100)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(error.toString(),
                style: TextStyle(
                    color: Colors.grey[400],
                    //fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ],
        )
      ],
    );
  }
}
