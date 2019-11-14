import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/user_model.dart';
import 'package:goodvibes/providers.dart/login_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/popup_message.dart';
import 'package:provider/provider.dart';

class SignInEmail extends StatefulWidget {
  final FormMode formMode;

  SignInEmail(this.formMode);

  @override
  _SignInEmailState createState() => _SignInEmailState(formMode);
}

class _SignInEmailState extends State<SignInEmail> {
  String email, pass, displayname, confirmPass;
  final _formKey = GlobalKey<FormState>();
  bool showpassword = true;
  FormMode formMode = FormMode.LOGIN;

  _SignInEmailState(this.formMode);

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
    final logincheck = Provider.of<LoginProvider>(context);
    final startupProvider = Provider.of<StartupProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: 80.0,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              formMode == FormMode.SIGNUP
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 25,
                            ),
                            Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            SizedBox(
                              // padding: const EdgeInsets.only(left: 8.0),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: TextFormField(
                                autocorrect: false,
                                autofocus: false,
                                onSaved: (val) => displayname = val,
                                decoration: InputDecoration(
                                    // hint:'Your e-mail'
                                    hintText: 'Your Full Name',
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name can not be empty';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                      Expanded(
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          onSaved: (val) => email = val,
                          decoration: InputDecoration(
                              // hint:'Your e-mail'
                              hintText: 'Your Email',
                              border: InputBorder.none),
                          validator: validateEmail,
                        ),
                      )
                    ],
                  ),
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
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          obscureText: showpassword,
                          decoration: InputDecoration(
                              hintText: 'Your Password',
                              border: InputBorder.none),
                          validator: (value) {
                            if (value.length < 8) {
                              return 'Password must be min 8 char';
                            }

                            confirmPass = value;
                            return null;
                          },
                          onSaved: (val) => pass = val,
                          // 'Enter you email address',
                          // style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(showpassword == true
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              formMode == FormMode.SIGNUP
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 25,
                      ),
                      Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: TextFormField(
                          autocorrect: false,
                          autofocus: false,
                          obscureText: showpassword,
                          decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              border: InputBorder.none),
//                          onSaved: (val) => confirmPass = val,
                          validator: (value) {
                            if (value !=confirmPass) {
                              return 'Password mismatched !!!';
                            }
                            return null;
                          },
                          // 'Enter you email address',
                          // style: TextStyle(color: Colors.black),
                        ),
                      ),
                      IconButton(
                        icon: Icon(showpassword == true
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )
                  : Container(),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _formKey.currentState.save();
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            content: MyShowDialog(),
                          );
                        });
                    await logincheck.loginWithEmail(
                        email: email,
                        pass: pass,
                        mode: this.formMode,
                        name: displayname);
                    UserData user = await startupProvider.getUserData();
                    print(user.email);
                    // // print(user.uid);
                    if (startupProvider.isLoggedIn == true)
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'home', (Route<dynamic> route) => false);
                  }
                },
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        formMode == FormMode.LOGIN ? 'LOG IN' : 'SIGN UP',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: 'Forgot password?  ',
                  style: TextStyle(color: Color(0xFF448AFF), fontSize: 14.0),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, 'forgotPassword');
                          // Forgot password page
                        },
                      text: 'Click here',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              RichText(
                text: TextSpan(
                  text: formMode == FormMode.LOGIN
                      ? 'Dont have an account yet?  '
                      : 'Already Have an Account  ',
                  style: TextStyle(color: Color(0xFF448AFF), fontSize: 14.0),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          if (formMode == FormMode.LOGIN) {
                            setState(() {
                              formMode = FormMode.SIGNUP;
                            });
                          } else {
                            setState(() {
                              formMode = FormMode.LOGIN;
                            });
                          }
                        },
                      text: formMode == FormMode.LOGIN ? 'Sign Up' : 'Log In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
