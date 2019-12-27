import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AudioPlayer audiPlayer;
  double size = 100;

  Future loadMusic() async {
    audiPlayer = await AudioCache().play("audio/intro.mp3");
  }

  @override
  void dispose() {
    if(audiPlayer!= null)
    audiPlayer.stop();
//     audiPlayer.dispose();
    audiPlayer = null;
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    loadMusic();
    Timer(Duration(milliseconds: 200), () {
      setState(() {
        size = 150;
      });
    });
  }

  // onBottom(Widget child) => Positioned.fill(
  //       child: Align(
  //         alignment: Alignment.bottomCenter,
  //         child: child,
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    final startup = Provider.of<StartupProvider>(context);
    print('forst run status is ${startup.firstrun}');
    if (startup.firstrun == false)
      Timer(Duration(seconds: 3), () async {
        print('Network status is ${startup.networkStatus}');
        if (startup.networkStatus == false) {
          print('network is false');
          Navigator.pushReplacementNamed(context, 'offline');
        } else {
          bool isloggedin = await startup.loggedIn();
          if (isloggedin) {
            print('user is logged in $isloggedin');
            Navigator.pushReplacementNamed(context, 'home');
            if (startup.userdata.paid == true)
              Navigator.pushReplacementNamed(context, 'home');
            else
              Navigator.pushNamed(context, 'subscribe');
          } else
            Navigator.pushReplacementNamed(context, 'login');
        }
      });

    return Scaffold(
      backgroundColor: Color(0xFF3F3FB6),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover),
          ),
        ),
        Positioned.fill(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeInOutCirc,
                width: size,
                height: size,
                child: Image.asset(
                  'assets/images/good-vibes-logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              // Text(
              //   'NAMASTE',
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20.0),
              // ),
              // Text(
              //   'believe then achieve',
              //   style: TextStyle(color: Colors.white),
              // ),
              SizedBox(
                height: 5,
              ),
              startup.firstrun == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: GestureDetector(
                        onTap: () {
                          audiPlayer.stop();
                          Navigator.pushReplacementNamed(context, 'intro');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.white24),
                          ),
                          width: 200.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                'GET STARTED',
                                style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 16.0,
                                    // fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: Text(
                        ' Welcome ',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            letterSpacing: 3),
                      ),
                    ),
            ],
          ),
        )),
      ]),
    );
  }
}
