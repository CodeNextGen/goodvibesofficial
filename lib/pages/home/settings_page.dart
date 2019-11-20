import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/providers.dart/login_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _rateApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            // height: 350.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100.0,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 30.0,
                        child: Image.asset(
                          'assets/images/starRating.png',
                          fit: BoxFit.contain,
                        )),
                  ),
                  Text('We want your feedback',
                      style: TextStyle(fontSize: 15.0)),
                  Text(
                    'Love the app? ',
                    style: TextStyle(color: Colors.blue, fontSize: 14.0),
                  ),
                  InkWell(
                    onTap: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.goodvibes&';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
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
                        width: double.infinity,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Give us 5 Star'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Container(
                      decoration: BoxDecoration(
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
                      width: double.infinity,
                      child: Center(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'remind me later'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool isAutoPlay = true;
  bool isSleeperTime = false;
  @override
  Widget build(BuildContext context) {
    // final loginprovider = Provider.of<LoginProvider>(context);
    // final musicProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
//        decoration: BoxDecoration(
//            gradient: RadialGradient(colors: [
//          Color(0xffE4F0F7),
//          // Color(0xFFBBDEFB),
//          Color(0xffE4F0F7)
//        ], radius: 300)
//            // image: DecorationImage(
//            //     image: AssetImage('assets/images/onboarding1.png'),
//            //     fit: BoxFit.cover),
//            ),
        // color: Color(0xFFBBDEFB),

        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg1.png'),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
//                      IconButton(
//                        icon: Icon(
//                          Icons.arrow_back,
//                          color: Colors.white,
//                        ),
//                        onPressed: () => Navigator.pop(context),
//                      ),
                      SizedBox(width: 20.0,),
                      Text(
                        'Settings',
                        style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<StartupProvider>(
                builder: (context, state, _) => SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          onTap: null,
                          title: Padding(
                            padding: const EdgeInsets.only(top:35.0, bottom: 15.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'account'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  // color: Color(0xFFEEAEFF),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () {
                            if (state.isLoggedIn == true)
                              Navigator.pushNamed(context, 'profile');
                            else
                              Navigator.pushNamed(context, 'loginHome');
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.person_outline, color: Color(0xFF3741AE),),
                              SizedBox(width: 10.0,),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
//                          leading: Icon(Icons.person_outline),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),

                        ListTile(
                          dense: true,
                          onTap: () =>
                              Navigator.pushNamed(context, 'download'),
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.arrow_downward, color: Color(0xFF3741AE),),
                              SizedBox(width: 10),
                              Text(
                                'Downloads',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
//                          leading: Icon(Icons.arrow_downward),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),

                        // ListTile(
                        //   onTap: null,
                        //   title: Text(
                        //     'Do not Disturb',
                        //     style: TextStyle(
                        //       fontSize: 15.0,
                        //     ),
                        //   ),
                        // ),
                        state.userdata.paid == false
                            ? ListTile(
                          dense: true,
                                onTap: () =>
                                    Navigator.pushNamed(context, 'subscribe'),
                                title: Row(
                                  children: <Widget>[
                           Icon(Icons.touch_app,color: Color(0xFF3741AE),),
                                    SizedBox(width: 10.0),
                                    Text(
                                      'Manage suscribe',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ],
                                ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                              )
                            : Container(),
                        ListTile(
                          dense: true,
                          onTap: () =>
                              Navigator.pushNamed(context, 'reminder'),
                          title: Row(
                            children: <Widget>[
                          Icon(Icons.alarm, color: Color(0xFF3741AE),),
                              SizedBox(width: 10.0),
                              Text(
                                'Reminder',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),
                        // ListTile(
                        //   onTap: null,
                        //   title: Text(
                        //     'Shop',
                        //     style: TextStyle(
                        //       fontSize: 15.0,
                        //     ),
                        //   ),
                        // ),
                        // ListTile(
                        //   onTap: null,
                        //   title: Text(
                        //     'Travel',
                        //     style: TextStyle(
                        //       fontSize: 15.0,
                        //     ),
                        //   ),
                        // ),
//                        SizedBox(
//                          height: 10,
//                        ),
                        ListTile(
                          onTap: null,
                          title: Text(
                            'more'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xFFEEAEFF),
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: null,
                          title: GestureDetector(
                            onTap: () {
                              _rateApp();
                            },
                            child: Row(
                              children: <Widget>[
                          Icon(Icons.star_border, color: Color(0xFF3741AE),),
                                SizedBox(width: 10.0),
                                Text(
                                  'Rate app',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: null,
                          title: GestureDetector(
                            onTap: () {
                              // _shareApp();
                              Share.share(
                                  'Good Vibes Official https://play.google.com/store/apps/details?id=com.goodvibes&hl=en_US');
                            },
                            child: Row(
                              children: <Widget>[
                           Icon(Icons.share, color: Color(0xFF3741AE),),
                                SizedBox(width: 10.0),
                                Text(
                                  'Share app',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () async {
                            const url =
                                'http://goodvibesofficial.com/help-and-support';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          title: Row(
                            children: <Widget>[
                          Icon(Icons.help_outline, color: Color(0xFF3741AE),),
                              SizedBox(width: 10.0),
                              Text(
                                'Help and Support',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Navigator.pushNamed(context, 'about'),
                          title: Row(
                            children: <Widget>[
                          Icon(Icons.new_releases, color: Color(0xFF3741AE),),
                              SizedBox(width: 10.0),
                              Text(
                                'About Us',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),
                        ListTile(
                          dense: true,
                          onTap: () => Navigator.pushNamed(context, 'faq'),
                          title: Row(
                            children: <Widget>[
                          Icon(Icons.question_answer, color: Color(0xFF3741AE),),
                              SizedBox(width: 10.0),
                              Text(
                                'FAQ',
                                style: TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Divider(
                            color: Colors.grey,
                            indent: 35.0,
                          ),
                        ),
                        Consumer<MusicProvider>(
                          // stream: null,
                          builder: (context, data,_) {
                            return Consumer<LoginProvider>(
                              // stream: null,
                              builder: (context, loginprovider,_) {
                                return state.isLoggedIn == true
                                    ? ListTile(
                                  dense: true,
                                        onTap: () async {
                                          // await data.stopPlaying();
                                          locator<MusicService>().stopPlaying();
                                          await loginprovider.logout();
                                          // await startupProvider.getUserData();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              'login',
                                              (Route<dynamic> route) => false);
                                        },
                                        title: Row(
                                          children: <Widget>[
                                 Icon(Icons.input, color: Color(0xFF3741AE),),
                                            SizedBox(width: 10.0),
                                            Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                  subtitle: Divider(
                                    color: Colors.grey,
                                    indent: 35.0,
                                  ),
                                      )
                                    : Container();
                              }
                            );
                          }
                        ),
                      ],
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
