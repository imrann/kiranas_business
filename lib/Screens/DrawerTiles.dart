import 'package:kirnas_business/CommonScreens/SlideRightRoute.dart';
import 'package:kirnas_business/CustomWidgets/AddProduct.dart';
import 'package:kirnas_business/Policies/Policies.dart';
import 'package:kirnas_business/Screens/Login.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog progressDialogotpLogout;

class DrawerTiles extends StatelessWidget {
  DrawerTiles({this.icon, this.title});

  final Widget icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    progressDialogotpLogout = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotpLogout.style(
        message: "Logging Out...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return ListTile(
        leading: icon,
        title: Text(title),
        onTap: () {
          if (title == "Logout") {
            progressDialogotpLogout.show().then((value) {
              if (value) {
                _signOut(context);
              }
            });
          } else if (title == "Payent Details") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Payment Details'),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        children: [
                          Row(
                            children: [SelectableText("Phone No : 8369275230")],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SelectableText("UPI ID : 8369275230@ybl")
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      // FlatButton(
                      //   child: Text('NO'),
                      //   onPressed: () {
                      //     Navigator.of(context).pop(false);
                      //   },
                      // ),
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          } else if (title == "About Us") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'About Us',
                      textAlign: TextAlign.center,
                    ),
                    content: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: SelectableText(
                                    "A B2B e-commerce app for local brick and mortar kirana shop."),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: SelectableText(
                                  "Made with :) by pointzeroonetech",
                                  style: TextStyle(fontSize: 10),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => WebViewContainer()));
          } else if (title == "Contact Us") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Contact Us',
                      textAlign: TextAlign.center,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(children: [
                            Text("Itfan Kargathra"),
                            Text("1234567890")
                          ]),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => WebViewContainer()));
          } else if (title == 'Privacy Policy') {
            Navigator.of(context).pop();
            _showPolicies("privacy", context);
          } else if (title == 'Terms & Conditions') {
            Navigator.of(context).pop();
            _showPolicies("Terms", context);
          } else if (title == 'Cancellation/Refund Policies') {
            Navigator.of(context).pop();
            _showPolicies("Refund", context);
          } else if (title == 'Add Product') {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, '/AddProduct',
                arguments: AddProduct(
                  isUpdateProduct: false,
                  prouctDetail: null,
                ));
            // Navigator.push(
            //     context,
            //     SlideRightRoute(
            //         widget: AddProduct(
            //           isUpdateProduct: false,
            //           prouctDetail: null,
            //         ),
            //         slideAction: "vertical"));
          }
        });
  }

  Future<void> _signOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    progressDialogotpLogout.hide().then((isHidden) {
      if (isHidden) {
        UserDetailsSP().logOutUser();

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/Login',
          ModalRoute.withName('/Login'),
        );

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  _showPolicies(String action, BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (BuildContext context) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                return new Container(
                  // height: 500,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.85,
                        width: MediaQuery.of(context).size.height * 0.95,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Policies(
                              action: action,
                            ),
                          ),
                        ),
                      )
                      //  displayUpiApps(),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}
