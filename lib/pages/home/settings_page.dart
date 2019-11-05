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
                      style: TextStyle(fontSize: 18.0)),
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
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          Color(0xFFBBDEFB),
          // Color(0xFFBBDEFB),
          Color(0xffE4F0F7)
        ], radius: 300)
            // image: DecorationImage(
            //     image: AssetImage('assets/images/onboarding1.png'),
            //     fit: BoxFit.cover),
            ),
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
              child: Center(
                child: Text(
                  'SettingsPage',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: Consumer<StartupProvider>(
                builder: (context, state, _) => SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            if (state.isLoggedIn == true)
                              Navigator.pushNamed(context, 'profile');
                            else
                              Navigator.pushNamed(context, 'loginHome');
                          },
                          title: Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),

                        ListTile(
                          onTap: () =>
                              Navigator.pushNamed(context, 'download'),
                          title: Text(
                            'Downloads',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),

                        // ListTile(
                        //   onTap: null,
                        //   title: Text(
                        //     'Do not Disturb',
                        //     style: TextStyle(
                        //       fontSize: 18.0,
                        //     ),
                        //   ),
                        // ),
                        state.userdata.paid == false
                            ? ListTile(
                                onTap: () =>
                                    Navigator.pushNamed(context, 'subscribe'),
                                title: Text(
                                  'Subscription',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              )
                            : Container(),
                        ListTile(
                          onTap: () =>
                              Navigator.pushNamed(context, 'reminder'),
                          title: Text(
                            'Reminder',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        // ListTile(
                        //   onTap: null,
                        //   title: Text(
                        //     'Shop',
                        //     style: TextStyle(
                        //       fontSize: 18.0,
                        //     ),
                        //   ),
                        // ),
                        // ListTile(
                        //   onTap: null,
                        //   title: Text(
                        //     'Travel',
                        //     style: TextStyle(
                        //       fontSize: 18.0,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: null,
                          title: Text(
                            'general'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xFFEEAEFF),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: null,
                          title: GestureDetector(
                            onTap: () {
                              _rateApp();
                            },
                            child: Text(
                              'Rate app',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: null,
                          title: GestureDetector(
                            onTap: () {
                              // _shareApp();
                              Share.share(
                                  'Good Vibes Official https://play.google.com/store/apps/details?id=com.goodvibes&hl=en_US');
                            },
                            child: Text(
                              'Share app',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            const url =
                                'http://goodvibesofficial.com/help-and-support';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          title: Text(
                            'Help and Support',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.pushNamed(context, 'about'),
                          title: Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => Navigator.pushNamed(context, 'faq'),
                          title: Text(
                            'FAQ',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
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
                                        title: Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                          ),
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
