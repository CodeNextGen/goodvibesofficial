import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/pages/notification/getNotifications.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:provider/provider.dart';

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
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
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
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
                      top: 35,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                        onPressed: () => {},
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 8,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Notification',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GetNotifications()
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Card(
//                  color: Colors.white,
//                  elevation: 4,
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Expanded(
//                            flex: 4,
//                            child: Container(
//                              padding:
//                                  const EdgeInsets.only(top: 16.0, left: 16.0),
//                              child: Text(
//                                "Good vibes Added new music Chakra activation",
//                                style: TextStyle(
//                                    fontSize: 16,
//                                    color: Colors.black,
//                                    fontWeight: FontWeight.bold),
//                              ),
//                            ),
//                          ),
//                          Expanded(
//                            flex: 1,
//                            child: Container(
//                              padding:
//                                  const EdgeInsets.only(top: 16.0, right: 10.0),
//                              child: CircleAvatar(
//                                child: Image.asset(
//                                  "assets/images/logo1.png",
//                                  height: 30,
//                                  width: 20,
//                                ),
//                                backgroundColor: Colors.brown,
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                      Padding(
//                        padding:
//                            const EdgeInsets.only(left: 16.0, bottom: 16.0),
//                        child: Text("16 mins ago",
//                            style: TextStyle(
//                              fontSize: 14,
//                              color: Colors.black12,
//                            )),
//                      )
//                    ],
//                  ),
//                ),
