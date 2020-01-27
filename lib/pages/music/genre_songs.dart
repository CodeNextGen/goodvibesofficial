import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/pages/home/genre_page.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:goodvibes/styles/button_decoration.dart';
import 'package:goodvibes/widgets/music_minimized.dart';
import 'package:provider/provider.dart';

class GenreSongs extends StatefulWidget {
  @override
  _GenreSongsState createState() => _GenreSongsState();
}

class _GenreSongsState extends State<GenreSongs> {
  ScrollController _scrollController ;
  ScrollController _scrollController1;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int id = 0;

  @override
  void initState() {
    super.initState();
    isLoading.value = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RouteSettings data = ModalRoute.of(context).settings;
    Genre genre = data.arguments;
    final musicProvider = Provider.of<MusicProvider>(context);
    _scrollController = ScrollController();
    _scrollController1= ScrollController();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        int pageCount = musicProvider.genreTracksFiltered.length ~/ 20 + 1;
        if (pageCount > 1) {
          isLoading.value = true;
          await musicProvider.getGenreTracks(
              id: genre.id, perpage: pageCount * 20);
          musicProvider.filterGenereTracks(id);
        }
        isLoading.value = false;
      }
    });
    _scrollController1.addListener(() async {
      if (_scrollController1.position.pixels ==
          _scrollController1.position.maxScrollExtent) {
        int pageCOunt = musicProvider.genreTracks.length ~/ 20 + 1;
        if (pageCOunt > 1) {
          isLoading.value = true;
          print('Load More normal');
          print('Track length is ${musicProvider.genreTracks.length}');
          await musicProvider.getGenreTracks(
              id: genre.id, perpage: pageCOunt * 20);
        }
        isLoading.value = false;
      }
    });

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
//              leading: Container(),
              backgroundColor: Colors.transparent,
              expandedHeight: 160.0,
              floating: false,
              pinned: true,
              flexibleSpace: Container(
                width: double.infinity,
                // height: 160.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg1.png'),
                      fit: BoxFit.cover),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            if (musicProvider.gCategory.isNotEmpty)
              SliverAppBar(
                leading: Container(),
                backgroundColor: Colors.transparent,
                expandedHeight: 30.0,
                floating: false,
                pinned: true,
                flexibleSpace: Container(
                  // width: double.infinity,
                  // height: 160.0,
                  color: Colors.white,
                  child: Center(
                      child: ListView.builder(
                    padding: EdgeInsets.all(4),
                    shrinkWrap: true,
                    itemCount: musicProvider.gCategory.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int i) => Container(
                      // height: 22,
                      // padding: EdgeInsets.all(12),

                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            id = musicProvider.gCategory[i].id;
                            musicProvider.genreSelectedIndex = i;
                            i == 0
                                ? musicProvider.clearGenreTracksFilter()
                                : musicProvider.filterGenereTracks(id);
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: musicProvider.genreSelectedIndex == i
                                ? buttonDecoration
                                : buttonWithoutGradient,
                            child: Text(
                              i == 0 ? 'All' : musicProvider.gCategory[i].name,
                              style: musicProvider.genreSelectedIndex == i
                                  ? TextStyle(color: Colors.white)
                                  : TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
              ),

          ];
        },
        body: Stack(
          children: <Widget>[
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (_context, loading, _) {
                if (loading)
                  return Container(
                    color: Colors.blue.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CupertinoActivityIndicator(),
                          Text('Loading ...', style: TextStyle(color: Colors.green,fontSize: 22),)
                        ],
                      ),
                    ),
                  );
                else
                  return Container();
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: musicProvider.genreTracksFiltered.isNotEmpty
                  ? GridView.count(
                      controller: _scrollController,
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 5,
                      children: List.generate(
                          musicProvider.genreTracksFiltered.length, (index) {
                        Track track = musicProvider.genreTracksFiltered[index];
                        return InkWell(
                          onTap: () {
                            // musicProvider.tracks =
                            //     musicProvider.genreTracksFiltered;
                            locator<MusicService>().musics =
                                musicProvider.genreTracksFiltered;
                            locator<MusicService>().songIndex = index;
                            Navigator.of(context).push(
                              new MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return SinglePlayer(index: index);
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  height: 160.0,
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder:
                                        'assets/images/placeholder.jpg',
                                    image: track.image,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 160.0,
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
                                ),
                                Positioned(
                                  bottom: 15.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 22),
                                    child: Text(
                                      track.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  : musicProvider.genreTracks.isNotEmpty
                      ? GridView.count(
                          controller: _scrollController1,
                          crossAxisCount: 2,
                          scrollDirection: Axis.vertical,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                          children: List.generate(
                              musicProvider.genreTracks.length, (index) {
                            Track track = musicProvider.genreTracks[index];
                            return InkWell(
                              onTap: () {
                                // musicProvider.tracks =
                                //     musicProvider.genreTracks;
                                locator<MusicService>().musics =
                                    musicProvider.genreTracks;
                                locator<MusicService>().songIndex = index;
                                Navigator.of(context).push(
                                  new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return SinglePlayer(index: index);
                                    },
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      height: 160.0,
                                      child: FadeInImage.assetNetwork(
                                        fit: BoxFit.cover,
                                        placeholder:
                                            'assets/images/placeholder.jpg',
                                        image: track.image,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 160.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                    ),
                                    Positioned(
                                      bottom: 15.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 22),
                                        child: Text(
                                          track.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        )
                      : Container(
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
            ),
            Positioned(
              bottom: 1.0,
              left: 15.0,
              right: 15.0,
              child: MusicMinimized(),
            ),
          ],
        ),
      ),
    );
  }
}
