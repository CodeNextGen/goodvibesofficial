import 'package:flutter/material.dart';
import 'package:goodvibes/pages/music/album.dart';
import 'package:goodvibes/pages/music/recomended_widget.dart';
import 'package:goodvibes/pages/music/trending_widget.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/header.dart';
import 'package:goodvibes/widgets/trail_button.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final startupProvider = Provider.of<AppSettings>(context);
    // final startupProvider = Provider.of<StartupProvider>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(),
            height: 280.0,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/bg1.png'),
                        fit: BoxFit.cover),
                  ),
                  height: 200.0,
                  child: Header(),
                ),
                Positioned(
                  top: 120.0,
                  left: 30.0,
                  right: 1.0,
                  child: Center(child: AlbumsPage()),
                )
              ],
            ),
          ),
          SizedBox(height: 30.0),
          TrailButton(),
          Padding(
            padding: const EdgeInsets.only(top:10.0, left: 32.0, right: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0, top: 12.0),
                  child: Text(
                    'Trending',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TrendingTracks(),
              ],
            ),
          ),
          Consumer<StartupProvider>(
            builder: (context, state, _) => state.userdata.paid == false
                ? Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Consumer<AdsProvider>(
                      builder: (context, st, _) => Center(
                        child: st.homeBanner,
                      ),
                    ),
                  )
                : Container(),
          ),

          Padding(
            padding: const EdgeInsets.only(top:10.0, left: 32.0, right: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    'Premium tracks',
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Recomended(),
              ],
            ),
          ),
          // Consumer<MusicProvider>(
          //     builder: (context, state, _) => SizedBox(
          //           height: state.isPlaying == false ? 40 : 85,
          //         ))
        ],
      ),
    );
  }
}
