import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FancyLoader extends StatelessWidget {
  FancyLoader({this.loaderType, this.lines});

  final String loaderType;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      period: Duration(milliseconds: 500),
      highlightColor: Colors.white,
      child: getLoaderType(loaderType: loaderType, lines: lines),
    );
  }

  Widget getLoaderType({String loaderType, int lines}) {
    switch (loaderType) {
      case "list":
        {
          return getListLoader();
        }
        break;

      case "sLine":
        {
          return getSingleLineLoader();
        }
        break;

      case "mLine":
        {
          return getMultiLineLoader(lines);
        }
        break;
      case "Grid":
        {
          return getGridLoader();
        }
        break;

      default:
        {
          return getLogoLoader();
        }
        break;
    }
  }

  Widget getLogoLoader() {
    return Center(
      child: Text(
        'kirnas_business',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.grey,
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            wordSpacing: 2,
            fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget getSingleLineLoader() {
    return Center(
      child: Container(
        color: Colors.grey[200],
        height: 100,
        width: 300,
      ),
    );
  }

  Widget getMultiLineLoader(int lines) {
    return Container(
      color: Colors.grey[200],
      height: lines.toDouble() * 50,
      width: 300,
    );
  }

  Widget getListLoader() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  color: Colors.grey[200],
                  height: 15,
                  width: 100,
                ),
              ),
              subtitle: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                  color: Colors.grey[200],
                  height: 15,
                  width: 100,
                ),
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getGridLoader() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            color: Colors.grey[200],
          ),
        );
      },
    );
  }
}
