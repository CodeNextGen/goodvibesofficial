import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:goodvibes/providers.dart/login_provider.dart';
// import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/popup_message.dart';
import 'package:provider/provider.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  String email;

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email is not valid';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    final forgetPass = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Container(
              height: 80.0,
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: Text(
                'Please enter your registered email and click Reset Password.\n Password reset link will be sent to your email',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    Icon(
                      Icons.mail_outline,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: true,
                          // obscureText: true,
                          // enabled: _isenable,
                          decoration: InputDecoration(
                              hintText: 'Enter your Email',
                              border: InputBorder.none),
                          validator: validateEmail,
                          onSaved: (val) => email = val,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9],
                    colors: [
                      Color(0xFF7E2BF5),
                      Color(0xFF3741AE),
                    ],
                  ),
                ),
                width: double.infinity,
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                MaterialButton(
                                  child: Text('Check Mail'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    AppAvailability.launchApp(Platform.isIOS
                                        ? "message://"
                                        : "com.google.android.gm");
                                  },
                                ),
                              ],
                              content: MyShowDialog(),
                            );
                          });

                      forgetPass.forgotPassword(email);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Reset Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
