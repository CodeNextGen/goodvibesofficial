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
  static int indexs = 0;
  ScrollController _scrollController = ScrollController();


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
        height: 300,
        child: data.trendingTracks.isNotEmpty
            ? StaggeredGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                staggeredTiles: [
                  StaggeredTile.count(1, 2),
                  for (var i = 2; i <= data.trendingTracks.length; i++)
                    StaggeredTile.count(1, 1)
                ],

                children: List.generate(data.trendingTracks.length, (index) {
                  Track _track = data.trendingTracks[index];
                  print('controller:: $_scrollController');
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
                          width: MediaQuery.of(context).size.width,
//                            height: 125,
//                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(_track.image),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(5.0)),
//                  height: double.infinity,
                        ),
                        Container(
                          width:  MediaQuery.of(context).size.width,
//                          height: 125,
//                  height: double.infinity,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      _track.title,
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset("assets/images/play_1.png"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            _track.duration,
                                            overflow: TextOverflow.fade,
                                            maxLines: 2,
                                            style: TextStyle(color: Colors.white, fontSize: 8.0),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
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

  static int getIndex(){
    return indexs;
  }
}
