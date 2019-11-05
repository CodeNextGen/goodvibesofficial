import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import '../config.dart';

enum FormMode { LOGIN, SIGNUP }

class LoginProvider with ChangeNotifier {
  bool _loadingLogin = true;
  String status = 'Processing Data';
  Widget statusWidget = CupertinoActivityIndicator();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthCredential fbcredential;
  get isloding => _loadingLogin;
  get loginStatus => status;

  Future<bool> _addUserToSystemApp({email, uuid}) async {
    Dio dio = Dio();
    print('email $email  UUID $uuid');
    FormData formData = new FormData.fromMap({"email": email, "uuid": uuid});
    try {
      await dio.post(
        '$baseUrl/signup',
        data: formData,
      );
      return true;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }

  loginWithEmail({email, pass, FormMode mode, name}) async {
    FirebaseUser user;
    status = 'Processing Data';
    statusWidget = CupertinoActivityIndicator();
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', 'email');
    try {
      if (mode == FormMode.LOGIN) {
        user = (await _firebaseAuth.signInWithEmailAndPassword(
                email: email, password: pass))
            .user;
        print(user);
        await _addUserToSystemApp(email: user.email, uuid: user.uid);
        print('user added to system');
        // if (user.isEmailVerified == true) {
        await _setUserData(user);
        statusWidget = Icon(Icons.check_circle);
        status = 'Login Sucess !\n Welcome ${user.displayName ?? 'Guest'}';
        try {
          Dio dio = Dio();
          Response response = await dio.get(
            '$baseUrl/v1/users/present_user',
            options: Options(
              headers: {'uuid': user.uid},
            ),
          );

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('image', response.data['user_image']);
          await prefs.setBool('paid', response.data['paid']);
        } on DioError catch (e) {
          print(e);
        }
      } else {
        user = (await _firebaseAuth.createUserWithEmailAndPassword(
                email: email, password: pass))
            .user;
        user.sendEmailVerification();
        user.updateProfile(userUpdateInfo);
        await _addUserToSystemApp(email: user.email, uuid: user.uid);
        statusWidget = Icon(Icons.check_circle);
        status = 'Sign up sucessful !\n Please log in ';
        print(user);
      }
    } catch (e) {
      print('Error exception');
      print('Error: $e');
      statusWidget = Icon(Icons.error);
      status = e.message == null ? e.details : e.message;
    }

    notifyListeners();
  }

  forgotPassword(String email) async {
    statusWidget = CupertinoActivityIndicator();
    status = 'Processing Data';

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      statusWidget = Icon(Icons.check);
      status = 'Email Sent !';
    } catch (e) {
      print('Error exception');
      print('Error: $e');
      statusWidget = Icon(Icons.error);
      status = e.message == null ? e.details : e.message;
    }
    notifyListeners();
  }

  Future<bool> _setUserData(FirebaseUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('islogedin', true);
    await prefs.setString('uid', user.uid);
    await prefs.setBool('admin', false);
    await prefs.setString('email', user.email);
    await prefs.setString('image', user.photoUrl);
    await prefs.setString('name', user.displayName);
    return true;
  }

  Future<bool> loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print('google user $googleUser');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      if (fbcredential != null) user.linkWithCredential(fbcredential);
      fbcredential = null;

      print("signed in " + user.displayName);
      print(user);
      await _addUserToSystemApp(email: user.email, uuid: user.uid);

      statusWidget = Icon(Icons.check_circle);
      status = 'Login Sucess !\n Welcome ${user.displayName ?? ' '}';

      await prefs.setString('type', 'google');
      try {
        Dio dio = Dio();
        Response response = await dio.get(
          '$baseUrl/v1/users/present_user',
          options: Options(
            headers: {'uuid': user.uid},
          ),
        );
        print(response.data);
        await prefs.setBool('paid', response.data['paid']);
      } on DioError catch (e) {
        print(e);
      }
      await _setUserData(user);
      return true;
    } catch (e) {
      statusWidget = Icon(Icons.error);
      status = e.message == null ? e.details : e.message;
      return false;
    }
  }

  Future<bool> loginWithFacebook() async {
    FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult fblogin = await facebookLogin.logIn(['email']);
    // print('facebook login status is ${fblogin.status} ${fblogin.errorMessage} ${fblogin.accessToken}');
    if (fblogin.status == FacebookLoginStatus.loggedIn) {
      fbcredential = FacebookAuthProvider.getCredential(
          accessToken: fblogin.accessToken.token);

      try {
        final FirebaseUser user =
            (await _firebaseAuth.signInWithCredential(fbcredential)).user;

        print(user);
        print('User can log in ');
        await _addUserToSystemApp(email: user.email, uuid: user.uid);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('type', 'facebook');
        try {
          Dio dio = Dio();
          Response response = await dio.get(
            '$baseUrl/v1/users/present_user',
            options: Options(
              headers: {'UUID': user.uid},
            ),
          );
          await prefs.setBool('paid', response.data['paid']);
        } on DioError catch (e) {
          print(e);
        }
        await _setUserData(user);
        statusWidget = Icon(Icons.check_circle);
        status = 'Login Sucess !\n Welcome ${user.displayName ?? 'Guest'}';
        return true;
      } catch (e) {
        statusWidget = Icon(Icons.error);
        status = e.message == null ? e.details : e.message;
        return false;
      }
    }
    notifyListeners();
    return false;
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('islogedin', false);
    prefs.remove('auth_token');
    prefs.remove('admin');
    prefs.remove('id');
    prefs.remove('name');
    prefs.setBool('paid', false);
    prefs.remove('image');
    prefs.remove('email');
    prefs.remove('type');
    prefs.remove('uid');
    notifyListeners();
  }
}
