import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Splash extends StatelessWidget {
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
                Shimmer.fromColors(
                  baseColor: Colors.white,
                  period: Duration(milliseconds: 1000),
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    'KIRANAS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 80.0,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 1,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: Colors.white,
                  period: Duration(milliseconds: 1000),
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    'BUSINESS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        wordSpacing: 1,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
