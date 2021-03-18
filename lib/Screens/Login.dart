import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:kirnas_business/Screens/Home.dart';
import 'package:kirnas_business/Screens/NoAdminScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirnas_business/SharedPref/UserDetailsSP.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:kirnas_business/Controllers/LoginController.dart';

final DateFormat format = new DateFormat("dd-MM-yyyy").add_jms();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var smsCode;

  String errorText = "";
  bool enableResendButton = false;
  String enteredOtp = '';
  ProgressDialog progressDialogotp;
  var onTapRecognizer;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  bool _autoValidate = false;

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);
          result.user.getIdToken().then((token) {
            Fluttertoast.showToast(
                msg: "Login Successfulll",
                fontSize: 10,
                backgroundColor: Colors.black);
            Navigator.of(context).pop();
            if (result.additionalUserInfo.isNewUser) {
              bottomSlider(isOtpSlider: false, userIdToken: token);
            } else {
              progressDialogotp.show().then((isShown) {
                if (isShown) {
                  LoginController().getUserByID(token).then((value) async {
                    if (value != null) {
                      if (value['userAddress']['address'].toString().isEmpty ||
                          value['userAddress']['address'].toString() == null ||
                          value['userAddress']['address'].toString().trim() ==
                              "") {
                        await UserDetailsSP().setIsAddressPresent(false);
                      } else {
                        await UserDetailsSP().setIsAddressPresent(true);
                      }

                      LoginController()
                          .isUserAdmin("+91" + _phoneController.text)
                          .then((isUserAdmin) {
                        if (isUserAdmin == "true") {
                          progressDialogotp.hide().then((isHidden) {
                            if (isHidden) {
                              Navigator.pushNamed(context, '/Home',
                                  arguments: Home());
                              // Navigator.pushNamed(context, '/',
                              //     arguments: Home(
                              //       user: value["userName"],
                              //       phone: value["userPhone"],
                              //       userID: value["userId"],
                              //     ));
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Home(
                              //               user: value["userName"],
                              //               phone: value["userPhone"],
                              //               userID: value["userId"],
                              //             )));
                              Fluttertoast.showToast(
                                  msg: "Welcome Back!",
                                  fontSize: 10,
                                  backgroundColor: Colors.black);
                            }
                          });
                        } else {
                          progressDialogotp.hide().then((isHidden) {
                            if (isHidden) {
                              Navigator.pushNamed(context, '/NoAdminScreen');
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => NoAdminScreen()));
                              Fluttertoast.showToast(
                                  msg: "Welcome Back!",
                                  fontSize: 10,
                                  backgroundColor: Colors.black);
                            }
                          });
                        }
                      });
                    }
                  }).catchError((err) {
                    progressDialogotp.hide();
                    Fluttertoast.showToast(
                        msg: "Something went wrong! please try later",
                        fontSize: 10,
                        backgroundColor: Colors.black);
                    print(err.toString());
                  });
                }
              });
            }
          });

          // if (user != null) {
          //   UserDetailsSP().loginUser(user, _userNameController.text);
          //   Navigator.of(context).pop();
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => Home(
          //                 user: _userNameController.text,
          //                 phone: "+91" + _phoneController.text,
          //                 userID: user.uid,
          //               )));
          // } else {
          //   print("Error");
          // }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print("failed");
          print(exception.message);
          progressDialogotp.hide().then((isHidden) {
            if (isHidden) {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  exception.message,
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
              ));
            }
          });
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          print("verificationId  :" + verificationId);
          progressDialogotp.hide().then((value) {
            if (value) {
              // scaffoldKey.currentState.showSnackBar(SnackBar(
              //   content: Text(
              //     "OTP SENT to : " + _phoneController.text.toString(),
              //     textAlign: TextAlign.center,
              //   ),
              //   duration: Duration(seconds: 5),
              // ));
              bottomSlider(
                  phoneNumber: _phoneController.text,
                  verificationId: verificationId,
                  forceResendingToken: forceResendingToken,
                  isOtpSlider: true);
            }
          });
        },
        codeAutoRetrievalTimeout: (String id) {
          // Navigator.of(context).pop();
          setState(() {
            enableResendButton = true;
          });
        });
  }

  StreamController<ErrorAnimationType> errorController;
  StreamController<ErrorAnimationType> errorController1;

  bool hasError = false;
  bool hasError1 = false;

  String phoneNumber = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    errorController1 = StreamController<ErrorAnimationType>();

    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    errorController1.close();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
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
    progressDialogotp = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialogotp.style(
        message: "Please Wait...",
        progressWidget: CircularProgressIndicator(),
        progressWidgetAlignment: Alignment.centerRight,
        textAlign: TextAlign.center);

    return Scaffold(
        key: scaffoldKey,
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: loginformUI(),
              ),
            )));
  }

  Widget loginformUI() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          reverse: false,
          children: <Widget>[
            SizedBox(
              height: 400,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'LOGIN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: inputOTPField()),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: RichText(
                text: TextSpan(
                    text: "Enter Phone Number ",
                    children: [],
                    style: TextStyle(color: Colors.pink[900], fontSize: 15)),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(hasError ? "*Invalid Phone Number" : "",
                  style: TextStyle(color: Colors.red, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 60,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "OTP will be sent via SMS on above number",
                style: TextStyle(color: Colors.pink[900], fontSize: 12),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  onPressed: () {
                    veryfyAndGetOtp();
                  },
                  child: Center(
                      child: Text(
                    "GET OTP".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(color: Colors.pink[900]),
                  ),
                  onPressed: () {
                    _phoneController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget inputOTPField() {
    return PinCodeTextField(
      length: 10,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColorDark,
      ),
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      inputFormatters: <TextInputFormatter>[
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter.digitsOnly
      ],
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 30,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorDark,
        selectedFillColor: Theme.of(context).primaryColor,
      ),
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      errorAnimationController: errorController,
      controller: _phoneController,
      onCompleted: (v) {},
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
      },
    );
  }

  onboardingProceed(
      String userName, IdTokenResult userIdToken, StateSetter setModalState) {
    if (userName.length < 4) {
      progressDialogotp.hide().then((isHidden) {
        if (isHidden) {
          setModalState(() {
            hasError = true;
            _autoValidate = true;
          });
        }
      });
    } else {
      setModalState(() {
        hasError = false;
        _autoValidate = false;
      });

      LoginController().createUser(userIdToken, userName).then((value) {
        if (value == "true") {
          LoginController()
              .isUserAdmin("+91" + _phoneController.text)
              .then((isUserAdmin) {
            if (isUserAdmin == "true") {
              progressDialogotp.hide().then((isHidden) {
                if (isHidden) {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/Home', arguments: Home());
                  // Navigator.pushNamed(context, '/',
                  //     arguments: Home(
                  //       user: _userNameController.text,
                  //       phone: "+91" + _phoneController.text,
                  //     ));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Home(
                  //               user: _userNameController.text,
                  //               phone: "+91" + _phoneController.text,
                  //             )));

                  Fluttertoast.showToast(
                      msg: "Welcome!",
                      fontSize: 10,
                      backgroundColor: Colors.black);
                }
              });
            } else {
              progressDialogotp.hide().then((isHidden) {
                if (isHidden) {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/NoAdminScreen');
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => NoAdminScreen()));

                  Fluttertoast.showToast(
                      msg: "Welcome!",
                      fontSize: 10,
                      backgroundColor: Colors.black);
                }
              });
            }
          });
        } else {
          Fluttertoast.showToast(
              msg: "Something went wrong! please try later..",
              fontSize: 10,
              backgroundColor: Colors.black);
          Navigator.of(context).pop();
        }
      }).catchError((err) {
        progressDialogotp.hide();
        Fluttertoast.showToast(
            msg: "Something went wrong! please try later",
            fontSize: 10,
            backgroundColor: Colors.black);
        print(err.toString());
      });
    }
  }

  veryfyAndProceed(String verificationId, int forceResendingToken,
      StateSetter setModalState) async {
    if (enteredOtp.length != 6) {
      errorController1
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError1 = true;
        errorText = "Invalid SMS Code";
      });
      progressDialogotp.hide();
    } else {
      setState(() {
        hasError1 = false;
        errorText = "";
      });

      FirebaseAuth _auth = FirebaseAuth.instance;
      final code = _codeController.text.trim();
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: code);

      AuthResult result =
          await _auth.signInWithCredential(credential).catchError((err) {
        progressDialogotp.hide();
        print('Caught $err');
        errorController1
            .add(ErrorAnimationType.shake); // Triggering error shake animation

        if (err.toString().contains("ERROR_INVALID_VERIFICATION_CODE")) {
          setModalState(() {
            hasError1 = true;
            errorText = "Invalid SMS Code";
          });
        }
      });

      result.user.getIdToken().then((token) {
        Fluttertoast.showToast(
            msg: "Login Successfull",
            fontSize: 10,
            backgroundColor: Colors.black);

        if (result.additionalUserInfo.isNewUser) {
          Navigator.of(context).pop();
          bottomSlider(isOtpSlider: false, userIdToken: token);
        } else {
          LoginController().getUserByID(token).then((value) async {
            if (value != null) {
              if (value['userAddress']['address'].toString().isEmpty ||
                  value['userAddress']['address'].toString() == null ||
                  value['userAddress']['address'].toString().trim() == "") {
                await UserDetailsSP().setIsAddressPresent(false);
              } else {
                await UserDetailsSP().setIsAddressPresent(true);
              }
              progressDialogotp.hide().then((isHidden) {
                if (isHidden) {
                  Navigator.pushNamed(context, '/Home', arguments: Home());

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Home(
                  //               user: value["userName"],
                  //               phone: value["userPhone"],
                  //               userID: value["userId"],
                  //             )));
                  Fluttertoast.showToast(
                      msg: "Welcome Back!",
                      fontSize: 10,
                      backgroundColor: Colors.black);
                }
              });
            }
          }).catchError((err) {
            progressDialogotp.hide();
            Fluttertoast.showToast(
                msg: "Something went wrong! please try later",
                fontSize: 10,
                backgroundColor: Colors.black);
            print(err.toString());
          });
        }
      });
    }
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  veryfyAndGetOtp() {
// conditions for validating
    Pattern pattern = r'^\d{10}$';
    RegExp regex = new RegExp(pattern);

    if ((!regex.hasMatch(phoneNumber))) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
        _autoValidate = false;
      });
    } else {
      setState(() {
        hasError = false;
        _autoValidate = false;
      });
      String phoneNumber = "+91" + _phoneController.text.trim();
      progressDialogotp.show().then((isProgressShown) {
        if (isProgressShown) {
          print(phoneNumber);
          loginUser(phoneNumber, context);
          // Future.delayed(Duration(seconds: 5), () {
          //   progressDialogotp.hide().then((isHidden) {
          //     if (isHidden) {
          //       // Navigator.push(context, SlideRightRoute(widget: OtpScreen()));
          //       //otpSlider();
          //     }
          //   });
          // });
        }
      });
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Container onboardingUI(IdTokenResult userIdToken, StateSetter setModalState) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.55,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 14,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Text(
                "Hellooooo!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30),
              child: Text(
                "What's your name....",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                child: TextFormField(
                  key: _formKey,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(10),
                  ],

                  autofocus: false,
                  readOnly: false,
                  cursorColor: Colors.black,

                  // ignore: deprecated_member_use
                  autovalidate: _autoValidate,
                  validator: _userNameValidator,
                  controller: _userNameController,
                  //  enabled: !lreadonlyForm,
                  style: TextStyle(color: Colors.pink[900], fontSize: 20),
                  decoration: InputDecoration(
                      labelText: "Enter User Name",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 15)),

                  // focusedBorder: InputBorder.none,
                  // border: InputBorder.none),
                  keyboardType: TextInputType.text,
                )),
            SizedBox(
              height: 70,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                splashColor: Colors.pink[900],
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  onPressed: () {
                    progressDialogotp.show().then((isShown) {
                      if (isShown) {
                        onboardingProceed(_userNameController.text, userIdToken,
                            setModalState);
                      }
                    });
                  },
                  child: Center(
                      child: Text(
                    "PROCEED".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 14,
            ),
          ],
        ));
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget otpFormUI(String verificationId, int forceResendingToken,
      StateSetter setModalState) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 2,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'OTP Verification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Hi " + _userNameController.text.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.redAccent[200],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                "Enter the OTP sent to +91 ",
                                style: TextStyle(
                                  color: Colors.pink[900],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                phoneNumber,
                                style: TextStyle(
                                    color: Colors.redAccent[200],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: inputPhoneNumberField()),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(errorText,
                  style: TextStyle(color: Colors.red, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            "Didn't Recieve the OTP?",
                            style: TextStyle(
                              color: Colors.pink[900],
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 0),
                      Column(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                  color: Colors.pink[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/Login');

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Login()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
              child: ButtonTheme(
                splashColor: Colors.pink[900],
                height: 50,
                child: FlatButton(
                  color: Colors.pink[900],
                  onPressed: () {
                    progressDialogotp.show().then((isShown) {
                      if (isShown) {
                        veryfyAndProceed(
                            verificationId, forceResendingToken, setModalState);
                      }
                    });
                    // conditions for validating
                  },
                  child: Center(
                      child: Text(
                    "Verify & Proceed".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Colors.pink[900],
                    ),
                  ),
                  onPressed: () {
                    _codeController.clear();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _userNameValidator(String value) {
    if (value.trim().length < 4) {
      return 'Must be greator than 3 and smaller than 10 charactors';
    } else
      return null;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////

  bottomSlider(
      {String phoneNumber,
      String verificationId,
      int forceResendingToken,
      bool isOtpSlider,
      IdTokenResult userIdToken}) {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {},
            child: Scrollbar(
              child: SingleChildScrollView(
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                  return new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0))),
                    child: isOtpSlider
                        ? otpFormUI(
                            verificationId, forceResendingToken, setModalState)
                        : onboardingUI(userIdToken, setModalState),
                  );
                }),
              ),
            ),
          );
        });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget inputPhoneNumberField() {
    return PinCodeTextField(
      length: 6,
      textStyle: TextStyle(
        color: Theme.of(context).primaryColorDark,
      ),
      textInputType: TextInputType.number,
      obsecureText: false,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        // borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 50,
        activeColor: Theme.of(context).primaryColor,
        activeFillColor: Theme.of(context).primaryColor,
        selectedColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).primaryColorDark,
        selectedFillColor: Theme.of(context).primaryColor,
      ),
      animationDuration: Duration(milliseconds: 200),
      backgroundColor: Colors.transparent,
      enableActiveFill: false,
      errorAnimationController: errorController1,
      controller: _codeController,
      textCapitalization: TextCapitalization.characters,
      onCompleted: (v) {},
      onChanged: (value) {
        setState(() {
          enteredOtp = value;
        });
      },
    );
  }
}
