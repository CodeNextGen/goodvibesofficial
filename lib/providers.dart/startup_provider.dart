import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartupProvider with ChangeNotifier {
  bool _firstRun = true;
  bool _isLoggedIn = false;
  bool _networkConnected = false;
  UserData _userData = UserData();

  StartupProvider() {
    checkConnectivity();
    _initAppUserState();
    getUserData();
    loggedIn();
  }

  get firstrun => _firstRun;
  bool get networkStatus => _networkConnected;
  UserData get userdata => _userData;

  checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _networkConnected = false;
    } else {
      _networkConnected = true;
    }

    // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     _networkConnected = false;

    //     print('No internet');
    //   } else {
    //     MusicProvider();
    //     _networkConnected = true;
    //     print('Internet is connected');
    //   }
    // });

    notifyListeners();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> loggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var isloggedin = prefs.getBool('islogedin');
    // print('is logged in $isloggedin');
    if (isloggedin == true)
      _isLoggedIn = true;
    else
      _isLoggedIn = false;

    return _isLoggedIn;
  }

  _initAppUserState() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    var fr = prefs.getBool('first_run');
    print('first run status $fr');
    if (fr == null) {
      _firstRun = true;
      prefs.setBool('first_run', false);
    } else
      _firstRun = false;
    // print('Checking for user logged in');
    //check for user logged in or not

    notifyListeners();
  }

  Future<UserData> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userData.email = prefs.getString('email');
    _userData.uid = prefs.getString('uid');
    _userData.paid = prefs.getBool('paid');
    _userData.type = prefs.getString('type');
    _userData.email = prefs.getString('email');
    _userData.name = prefs.getString('name');
    _userData.image = prefs.getString('image');
    _isLoggedIn = prefs.getBool('islogedin');

    // notifyListeners();
    return _userData;
  }
}
