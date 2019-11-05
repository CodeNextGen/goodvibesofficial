import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:provider/provider.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<StartupProvider>(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Spacer(),
            Image.asset('assets/images/noInternetIcon.png'),
            Text(
              'Whoops!',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'No internet connection found.\n Check your connection and try again',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA3A7B2), fontSize: 16.0),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
              child: Container(
                width: 200.0,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFFDBE7F5),
                      offset: Offset(1.0, 10.0),
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25.0),
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
                child: InkWell(
                  onTap: () => AppSettings.openWIFISettings(),
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Open Settings',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
              child: Container(
                width: 200.0,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0xFFDBE7F5),
                      offset: Offset(1.0, 10.0),
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25.0),
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
                child: InkWell(
                  onTap: () {
                    if (user.isLoggedIn != true) {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Subscribe'),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text('Retry'),
                                  onPressed: () async{
                                     await user.checkConnectivity();
                                    bool network =  user.networkStatus;
                                   if(network){
                                     Navigator.pushNamedAndRemoveUntil(context, 'home', (Route<dynamic> route)=>false);

                                   }else Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                  child: Text('Open Settings'),
                                  onPressed: () =>
                                      AppSettings.openWIFISettings(),
                                ),
                              ],
                              content: Text(
                                  'Looks like you have not logged in yet and offline\n Users are required to login first to use offline mode.\nYou might have to disable VPN for the app to work properly.'),
                            );
                          });
                    } else {
                      Navigator.pushReplacementNamed(context, 'home');
                      Navigator.pushNamed(context, 'download');
                    }
                  },
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Continue Offline',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
