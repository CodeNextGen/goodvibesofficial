import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/providers.dart/login_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:goodvibes/widgets/trail_button.dart';
import 'package:provider/provider.dart';
import 'image_upload.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    // final loginprovider = Provider.of<LoginProvider>(context);
    // final musicProvider = Provider.of<MusicProvider>(context);
    final startupProvider = Provider.of<StartupProvider>(context);
    // print(startupProvider.userdata.type);
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FE),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                height: 250.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 200.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 0.9],
                            colors: [
                              Color(0xFF4025B2),
                              Color(0xFF6619A5),
                            ],
                          ),
                          image: DecorationImage(
                              image: AssetImage('assets/images/profileBg.png'),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      top: 25,
                      right: 2,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      top: 25,
                      left: 2,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(width: 20.0,),
                          Text(
                            'Profile',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: startupProvider.userdata.image ==
                                  null
                              ? AssetImage('assets/images/avatar.png')
                              : NetworkImage(startupProvider.userdata.image),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 100,
                            child: startupProvider.userdata.type == 'email'
                                ? OutlineButton(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Text(
                                        'Change',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    borderSide: BorderSide.none,
                                    clipBehavior: Clip.antiAlias,
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ProfileImageUpload();
                                          });
                                    },
                                  )
                                : Container(),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  startupProvider.userdata.name ?? 'Guest',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              // Text(
              //   'Kathmandu, Nepal',
              //   style: TextStyle(color: Colors.black54),
              // ),
              GestureDetector(
                onTap: () {
                  if (startupProvider.userdata.type == 'email') {
                    Navigator.pushNamed(context, 'forgotPassword');
                  } else {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text('Social Media User'),
                            actions: <Widget>[
                              MaterialButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            content: Text(
                                'Looks like you have logged in via Social Media\Reset password works for user logged in with Email only.'),
                          );
                        });
                  }
                },
                child: Text(
                  'change password',
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    //fav Button
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, 'favs'),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color(0xFFDBE7F5),
                              offset: Offset(1.0, 10.0),
                              blurRadius: 10.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.1, 0.6],
                            colors: [
                              Color(0xFF3741AE),
                              Color(0xFF6719A5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Text(
                              'favorite'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color(0xFFDBE7F5),
                            offset: Offset(1.0, 10.0),
                            blurRadius: 10.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.1, 0.6],
                          colors: [
                            Color(0xFF3741AE),
                            Color(0xFF6719A5),
                          ],
                        ),
                      ),
                      child: Center(
                        //download button
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, 'download'),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Text(
                              'Downloads'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TrailButton(),
                    SizedBox(
                      height: 15.0,
                    ),
                    //History button
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, 'history'),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color(0xFFDBE7F5),
                              offset: Offset(1.0, 10.0),
                              blurRadius: 10.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.1, 0.6],
                            colors: [
                              Color(0xFF3741AE),
                              Color(0xFF6719A5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Text(
                              'history'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    InkWell(
                      onTap: () {
                        if (startupProvider.userdata.paid == true)
                          Navigator.pushNamed(context, 'askQuestion');
                        else
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text('Subscribe'),
                                  actions: <Widget>[
                                    MaterialButton(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    MaterialButton(
                                      child: Text('Buy Premium'),
                                      onPressed: () => Navigator.pushNamed(
                                          context, 'subscribe'),
                                    ),
                                  ],
                                  content: Text(
                                      'Support are provided for paid users only\n Please consider buying trail subscription'),
                                );
                              });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Color(0xFFDBE7F5),
                              offset: Offset(1.0, 10.0),
                              blurRadius: 10.0,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.1, 0.6],
                            colors: [
                              Color(0xFF3741AE),
                              Color(0xFF6719A5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Text(
                              'Ask a Question'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //  Spacer(),
                    SizedBox(
                      height: 65,
                    ),
                    Consumer<MusicProvider>(
                        // stream: null,
                        builder: (context, musicProvider, _) {
                      return Consumer<LoginProvider>(
                          // stream: null,
                          builder: (context, loginprovider, _) {
                        return InkWell(
                          onTap: () async {
                            // await musicProvider.stopPlaying();
                            locator<MusicService>().stopPlaying();
                            await loginprovider.logout();
                            await startupProvider.getUserData();
                            Navigator.pushNamedAndRemoveUntil(context, 'login',
                                (Route<dynamic> route) => false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xFFDBE7F5),
                                  offset: Offset(1.0, 10.0),
                                  blurRadius: 10.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.1, 0.6],
                                colors: [
                                  Color(0xFF3741AE),
                                  Color(0xFF6719A5),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                                child: Text(
                                  'Sign Out'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }),
                  ],
                ),
              ),
//              StaggeredGridView.count(crossAxisCount: 2,
//              crossAxisSpacing: 12,
//              mainAxisSpacing: 12,
//                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                children: <Widget>[
//                  MyGridTiles(IconButton(icon: Image.asset('assets/images/avatar.png'),onPressed: ()=>{},))
//                ],
//              )
            ],
          ),
        ),
      ),
    );
  }
}
