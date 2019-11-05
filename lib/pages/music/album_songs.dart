import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:goodvibes/widgets/music_minimized.dart';
import 'package:provider/provider.dart';

class AlbumSongs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RouteSettings data = ModalRoute.of(context).settings;
    print(data.arguments);
    Albums album = data.arguments;
    void openDialog(index) {
      Navigator.of(context).push(
        new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return SinglePlayer(index: index);
          },
          fullscreenDialog: true,
        ),
      );
    }

    return Scaffold(
      body: Stack(children: [
        Consumer<MusicProvider>(
          builder: (BuildContext context, state, _) => Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFFBBDEFB), Color(0xffE4F0F7)],
                radius: 300,
              ),
            ),
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
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Center(
                          child: Text(
                            album.title.toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        // SizedBox(width: 20,),
                        Spacer(
                          flex: 3,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      height: 320 + 15.0,
                      child: state.albumTracks.isNotEmpty
                          ? GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              children: List.generate(state.albumTracks.length,
                                  (index) {
                                return InkWell(
                                  onTap: () {
                                    locator<MusicService>().musics =
                                        state.albumTracks;
                                    locator<MusicService>().songIndex = index;
                                    openDialog(index);
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(state
                                                    .albumTracks[index].image),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        height: 160.0,
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
                                        child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                state.albumTracks.isNotEmpty
                                                    ? state.albumTracks[index]
                                                        .title
                                                    : '',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                      )
                                    ],
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
                  ),
                ]),
          ),
        ),
        Positioned(
          bottom: 1.0,
          left: 15.0,
          right: 15.0,
          child: MusicMinimized(),
        ),
      ]),
    );
  }
}
