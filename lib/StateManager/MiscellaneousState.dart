import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiscellaneousState extends ChangeNotifier {
  Icon deleteIconState = Icon(
    Icons.delete_outline_rounded,
    size: 25,
    color: Colors.white,
  );
  Icon getDeleteIconState() => deleteIconState;

  setDeleteIconState(Icon deleteIconState) {
    this.deleteIconState = deleteIconState;
    notifyListeners();
  }
}
