import 'package:flutter/material.dart';

class NoAdminScreen extends StatefulWidget {
  @override
  _NoAdminScreenState createState() => _NoAdminScreenState();
}

class _NoAdminScreenState extends State<NoAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("no admin"),
      ),
    );
  }
}
