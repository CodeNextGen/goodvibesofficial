import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/models/player_status_enum.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/services/player_service.dart';

class MusicMinimized extends StatefulWidget {
  @override
  _MusicMinimizedState createState() => _MusicMinimizedState();
}

class _MusicMinimizedState extends State<MusicMinimized> {
  bool minimizeddPlayer = false;

  final _locator = locator<MusicService>();

  @override
  Widget build(BuildContext context) {
    // return Container();
    return ValueListenableBuilder<PlayerStatus>(
        valueListenable: _locator.playerStatus,
        builder: (context, status, _) {
          print('Player status is $status');
          if (status == PlayerStatus.isStopped) {
            return Container();
          } else {
            Track _track = _locator.songPlaying;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: GestureDetector(
                onHorizontalDragEnd: (DragEndDetails drag) {
                  // print(drag);
                  setState(() {
                    minimizeddPlayer = true;
                  });
                },
                onTap: () {
                  if (_locator.musics.contains(_track)) {
                    _locator.songIndex = _locator.currentPlayerIndex;
                  } else {
                    _locator.musics.add(_track);
                    _locator.songIndex = _locator.musics.length - 1;
                    _locator.songIndex = _locator.currentPlayerIndex;
                  }

                  // _locator.songIndex = _locator.currentPlayerIndex;
                  // _locator.musics.add(_track);
                  // _locator.songIndex = _locator.musics.length-1;

                  Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return SinglePlayer();
                      },
                      fullscreenDialog: true));
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: minimizeddPlayer == false
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.2, 0.9],
                                colors: [
                                  Color(0xFF3741AE),
                                  Color(0xFF7E2BF5),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(35.0)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(_track.image),
                                          // radius: 15.0,
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              _track.title,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          onPressed: _locator.songIndex - 1 < 0
                                              ? null
                                              : () {
                                                  // state.player.stop();
                                                  setState(() {
                                                    _locator.songIndex -= 1;
                                                  });
                                                  _locator.play();
                                                  // state.playAudio(state.songIndex);
                                                },
                                          icon: Icon(
                                            Icons.skip_previous,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: IconButton(
                                          onPressed: () {
                                            _locator.play();
                                          },
                                          icon: Icon(
                                            status == PlayerStatus.isPlaying
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: 18.0,
                                            color: Color(0xFF3F3FB6),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: IconButton(
                                          onPressed: _locator.songIndex + 1 >=
                                                  _locator.musics.length
                                              ? null
                                              : () {
                                                  // state.player.stop();
                                                  setState(() {
                                                    _locator.songIndex += 1;
                                                  });
                                                  _locator.play();
                                                },
                                          icon: Icon(
                                            Icons.skip_next,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : FloatingActionButton(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          onPressed: () {
                            setState(() {
                              minimizeddPlayer = false;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Icon(
                                status == PlayerStatus.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Color(0xFF3F3FB6)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                width: 2.0,
                                color: Color(0xFF3F3FB6),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            );
          }
        });
  }
}
