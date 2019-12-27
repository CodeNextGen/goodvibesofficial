import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/fab.dart';
import 'package:goodvibes/widgets/music_minimized.dart';
import 'package:provider/provider.dart';
import 'genre_page.dart';
import 'home_page.dart';
import 'meditate.dart';
import 'search_page.dart';
import 'settings_page.dart';

class HomePageNew extends StatefulWidget {
  @override
  _HomePageNewState createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  Widget _lastSelected = HomePage();
  List<Widget> _pages = [
    HomePage(),
    DefaultSearchBox(),
    Discover(),
    SettingsPage(),
  ];

  void _selectedTab(int index) {
    // print(index);
    setState(() {
      _lastSelected = _pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final startupProvider = Provider.of<StartupProvider>(context);
    startupProvider.loggedIn().then((val) {
      if (val != true) Navigator.pushReplacementNamed(context, 'login');
    });
    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return Future.value(true);
          } else {
            var _androidAppRetain = MethodChannel("android_app_retain");
            _androidAppRetain.invokeMethod("sendToBackground");
            return Future.value(false);
          }
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: Stack(children: [
          _lastSelected,
          Positioned(
            bottom: 1.0,
            left: 15.0,
            right: 15.0,
            child:   Consumer<StartupProvider>(
              builder: (context, state, _) => state.userdata.paid == false
                  ? Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Consumer<AdsProvider>(
                  builder: (context, st, _) => Center(
                    child: st.footerBanner,
                  ),
                ),
              )
                  : Container(),
            ),
          ),
          Positioned(
            bottom: 1.0,
            left: 15.0,
            right: 15.0,
            child: MusicMinimized(),
          )
        ]),
        bottomNavigationBar: FABBottomAppBar(
          centerItemText: 'Meditate',
          color: Colors.grey,
          selectedColor: Colors.black,
          notchedShape: FollowerNotchedShape(inverted: true),
          onTabSelected: _selectedTab,
          items: [
            FABBottomAppBarItem(iconData: Icons.home, text: ''),
            FABBottomAppBarItem(iconData: Icons.search, text: ''),
            FABBottomAppBarItem(iconData: Icons.library_music, text: ''),
            FABBottomAppBarItem(iconData: Icons.settings, text: ''),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFab(context),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _lastSelected = Meditate();
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
            colors: [
              Color(0xFF6619A5),
              Color(0xFF4025B2),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/images/logo1.png',
          width: 10.0,
          height: 10.0,
        ),
      ),
    );
  }
}
