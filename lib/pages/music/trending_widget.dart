import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:provider/provider.dart';

class TrendingTracks extends StatelessWidget {
  final startupProvider = locator<StartupProvider>();

  @override
  Widget build(BuildContext context) {
    final adstate = Provider.of<AdsProvider>(context);
    // final musicProvider = Provider.of<MusicProvider>(context);

    void openDialog(index) {
      if (startupProvider.userdata.paid != true) adstate.showinterestialAds();
      Navigator.of(context).push(
        new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SinglePlayer(index: index);
          },
          fullscreenDialog: true,
        ),
      );
    }

    return Consumer<MusicProvider>(
        // stream: null,
        builder: (context, data, _) {
      return Container(
        height: 300 + 15.0,
        child: data.trendingTracks.isNotEmpty
            ? StaggeredGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                scrollDirection: Axis.horizontal,
                staggeredTiles: [
                  StaggeredTile.count(2, 1),
                  for (var i = 2; i <= data.trendingTracks.length; i++)
                    StaggeredTile.count(1, 1)
                ],
                children: List.generate(data.trendingTracks.length, (index) {
                  Track _track = data.trendingTracks[index];
                  return InkWell(
                    onTap: () {
                      // musicProvider.tracks = musicProvider.trendingTracks;
                      locator<MusicService>().musics = data.trendingTracks;
                      locator<MusicService>().songIndex = index;
                      openDialog(index);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(_track.image),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(5.0)),
//                  height: 140.0,
                        ),
                        Container(
                          width: double.infinity,
//                  height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.4, 0.9],
                              colors: [
                                Color(0x114025B2),
                                Color(0xBB6619A5),
                              ],
                            ),
                          ),
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _track.title,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        )
                      ],
                    ),
                  );
                }),
              )
//        GridView.count(
//                crossAxisCount: 2,
//                crossAxisSpacing: 15,
//                mainAxisSpacing: 15,
//                scrollDirection: Axis.horizontal,
//                children: List.generate(data.trendingTracks.length, (index) {
//                  Track _track = data.trendingTracks[index];
//                  return InkWell(
//                    onTap: () {
//                      // musicProvider.tracks = musicProvider.trendingTracks;
//                      locator<MusicService>().musics = data.trendingTracks;
//                      locator<MusicService>().songIndex = index;
//                      openDialog(index);
//                    },
//                    child: Stack(
//                      children: <Widget>[
//                        Container(
//                          decoration: BoxDecoration(
//                              image: DecorationImage(
//                                  image: NetworkImage(_track.image),
//                                  fit: BoxFit.cover),
//                              borderRadius: BorderRadius.circular(5.0)),
//                          height: 160.0,
//                        ),
//                        Container(
//                          width: double.infinity,
//                          height: 160.0,
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(5.0),
//                            gradient: LinearGradient(
//                              begin: Alignment.topCenter,
//                              end: Alignment.bottomCenter,
//                              stops: [0.4, 0.9],
//                              colors: [
//                                Color(0x114025B2),
//                                Color(0xBB6619A5),
//                              ],
//                            ),
//                          ),
//                          child: Align(
//                              alignment: Alignment.bottomCenter,
//                              child: Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text(
//                                  _track.title,
//                                  style: TextStyle(color: Colors.white),
//                                ),
//                              )),
//                        )
//                      ],
//                    ),
//                  );
//                }),
//              )
            : Container(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
      );
    });
  }
}
