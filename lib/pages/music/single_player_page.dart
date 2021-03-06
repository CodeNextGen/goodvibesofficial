import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/models/player_status_enum.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:goodvibes/widgets/trail_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class SinglePlayer extends StatefulWidget {
  final int index;
  SinglePlayer({Key key, this.index}) : super(key: key);

  @override
  _SinglePlayerState createState() => _SinglePlayerState();
}

class _SinglePlayerState extends State<SinglePlayer> {
  final _locator = locator<MusicService>();
  final userstate = locator<StartupProvider>();
  double dd = 0;

  @override
  void initState() {
    _locator.getInitialData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Track _track = _locator.musics[_locator.songIndex];

    void _deleteFavs() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              // height: 370.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100.0,
                          child: Image.asset(
                            'assets/images/notification.png',
                            fit: BoxFit.contain,
                          )),
                    ),
                    Text(
                      'Are you sure you want to remove this track?',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
                        _locator.deletFav();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.9],
                              colors: [
                                Color(0xFF7E2BF5),
                                Color(0xFF3741AE),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Remove'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black54,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'cancel'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    void _deleteDownload() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              // height: 370.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 100.0,
                          child: Image.asset(
                            'assets/images/notification.png',
                            fit: BoxFit.contain,
                          )),
                    ),
                    Text(
                      'Are you sure you want to delete this track ? ',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: () {
                        // int id = state.tracks[index].id;
                        _locator.deleteDown();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.9],
                              colors: [
                                Color(0xFF7E2BF5),
                                Color(0xFF3741AE),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Remove'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black54,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'cancel'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    // final userstate = Provider.of<StartupProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 385.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 350.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(_track.image),
                            fit: BoxFit.cover,
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xAA0E0778),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _track.title,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  child: Text(
                                    _track.description,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                  '${_track.cname ?? ''}',
                                  style: TextStyle(
                                      color: Color(0xFFBBDEFB),
                                      decoration: TextDecoration.underline),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _track.duration,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                // userstate.userData.paid==false?  Text(
                                //     'Listen 15 min for free',
                                //     style: TextStyle(
                                //         color: Colors.white, fontSize: 12.0),
                                //   ):Container(),
                                Text(
                                  _track.composer == null
                                      ? ''
                                      : 'Composer : ${_track.composer}',
                                  style: TextStyle(
                                    color: Color(0xFFBBDEFB),
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Nav buttons back and close stop playing
                        Positioned(
                          top: 0,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.expand_more,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_locator.currentPlayerIndex ==
                                      _locator.songIndex) {
                                    _locator.stopPlaying();
                                  }

                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        //Media control buttons
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 70.0,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    height: 100.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(1.0, 6.0),
                                            blurRadius: 20.0,
                                          ),
                                        ],
                                        color: Color(0xFFFAFAFA),
                                        borderRadius:
                                            BorderRadius.circular(35.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          //prev button
                                          IconButton(
                                            onPressed: _locator.songIndex - 1 <
                                                    0
                                                ? null
                                                : () {
                                                    // state.stopPlaying();
                                                    setState(() {
                                                      _locator.songIndex -= 1;
                                                    });
                                                    _locator.play();
                                                  },
                                            icon: Icon(
                                              Icons.skip_previous,
                                              // color: Color(0xFF3F3FB6),
                                            ),
                                          ),

                                          //play pause button
                                          InkWell(
                                            onTap: () {
                                              print('Play button is tapped');
                                              _locator.play();
                                            },
                                            child: ValueListenableBuilder<
                                                    PlayerStatus>(
                                                valueListenable:
                                                    _locator.playerStatus,
                                                builder: (context, status, _) {
                                                  print('object play button ');
                                                  return Container(
                                                    width: 60,
                                                    height: 60,
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        Icon(
                                                          _locator.songIndex !=
                                                                  _locator
                                                                      .currentPlayerIndex
                                                              ? Icons.play_arrow
                                                              : status ==
                                                                      PlayerStatus
                                                                          .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                          color:
                                                              Color(0xFF3F3FB6),
                                                        ),
                                                        _locator.songIndex ==
                                                                    _locator
                                                                        .currentPlayerIndex &&
                                                                status ==
                                                                    PlayerStatus
                                                                        .isLoading
                                                            ? CupertinoActivityIndicator(
                                                                radius: 28,
                                                              )
                                                            : Container(),
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        width: 2.0,
                                                        color:
                                                            Color(0xFF3F3FB6),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                          //next button
                                          IconButton(
                                            icon: Icon(
                                              Icons.skip_next,
                                            ),
                                            onPressed: _locator.songIndex + 1 >=
                                                    _locator.musics.length
                                                ? null
                                                : () {
                                                    // state.stopPlaying();
                                                    setState(() {
                                                      _locator.songIndex += 1;
                                                    });
                                                    _locator.play();
                                                    // state.playAudio(index);
                                                  },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //functions
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //repeat button
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  _locator.repeat
                                      ? Icons.repeat
                                      : Icons.arrow_forward,
                                  color: Color(0xFF3F3FB6),
                                ),
                                onPressed: () => setState(() {
                                  _locator.repeat = !_locator.repeat;
                                }),
                              ),
                              Text(
                                'Repeat ${_locator.repeat ? 'ON ' : 'OFF'}',
                                style: TextStyle(
                                    color: Color(0xFF3F3FB6), fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 14.0,
                        ),
                        //fav button
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              ValueListenableBuilder<bool>(
                                  valueListenable: _locator.isFav,
                                  builder: (context, fav, _) {
                                    return IconButton(
                                        icon: Icon(
                                          fav == false
                                              ? Icons.favorite_border
                                              : Icons.favorite,
                                          color: Color(0xFF3F3FB6),
                                        ),
                                        onPressed: () {
                                          if (fav == false)
                                            _locator.implementFavourite();
                                          else
                                            _deleteFavs();
                                        });
                                  }),
                              Text(
                                'Favourite',
                                style: TextStyle(
                                    color: Color(0xFF3F3FB6), fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 14.0,
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    _locator.timerRemainig.value >
                                            Duration(seconds: 0)
                                        ? Icons.alarm
                                        : Icons.timer,
                                    color: Color(0xFF3F3FB6),
                                  ),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) =>
                                            ModelTimerSettrr());
                                  }),
                              Text(
                                'Timer',
                                style: TextStyle(
                                    color: Color(0xFF3F3FB6), fontSize: 12.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 14.0,
                        ),
                        Flexible(
                          child: ValueListenableBuilder<bool>(
                              valueListenable: _locator.isDownloading,
                              builder: (context, isDownloading, _) {
                                return Column(
                                  children: <Widget>[
                                    ValueListenableBuilder<bool>(
                                        valueListenable: _locator.isDownloaded,
                                        builder: (context, isdownloaded, _) {
                                          return IconButton(
                                              icon: Stack(
                                                children: [
                                                  Center(
                                                    child: Icon(
                                                      isdownloaded == false
                                                          ? Icons.cloud_queue
                                                          : Icons.cloud,
                                                      color: Color(0xFF3F3FB6),
                                                    ),
                                                  ),
                                                  _locator.songIndex ==
                                                          _locator
                                                              .downloadTrackIndex
                                                      ? ValueListenableBuilder<
                                                              int>(
                                                          valueListenable: _locator
                                                              .downloadPercantage,
                                                          builder: (context,
                                                              percantage, _) {
                                                            return Container(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                semanticsLabel:
                                                                    'Downloading..',
                                                                semanticsValue:
                                                                    '$percantage',
                                                                value:
                                                                    percantage /
                                                                        100.0,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation(
                                                                        Colors
                                                                            .blue),
                                                              ),
                                                            );
                                                          })
                                                      : Container(),
                                                ],
                                              ),
                                              onPressed: isDownloading
                                                  ? () {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              ' Already Downloading!',
                                                          backgroundColor:
                                                              Colors.deepPurple,
                                                          textColor:
                                                              Colors.white70);
                                                    }
                                                  : () {
                                                      if (isdownloaded)
                                                        _deleteDownload();
                                                      else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                ' Download Started...',
                                                            backgroundColor:
                                                                Colors
                                                                    .deepPurple,
                                                            textColor:
                                                                Colors.white70);
                                                        if (_locator
                                                                .isDownloading
                                                                .value ==
                                                            false)
                                                          _locator
                                                              .implementDownload();
                                                      }
                                                    });
                                        }),
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                          color: Color(0xFF3F3FB6),
                                          fontSize: 12.0),
                                    )
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 12),
                    child: Column(
                      children: <Widget>[
                        ValueListenableBuilder<Duration>(
                            valueListenable: _locator.current,
                            builder: (context, current, _) {
                              // print(current);
                              return Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: _locator.songIndex ==
                                        _locator.currentPlayerIndex
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                              current.toString().split('.')[0]),
                                          Text('/'),
                                          Text(_locator.max.value
                                              .toString()
                                              .split('.')[0]),
                                        ],
                                      )
                                    : Container(),
                              );
                            }),
                        ValueListenableBuilder<Duration>(
                            valueListenable: _locator.current,
                            builder: (context, pos, _) {
                              return Slider(
                                onChanged: (d) {
                                  dd = d;
                                    _locator.seekMusic(d);
                                  // if (userstate.userdata.paid != true &&
                                  //     d.toInt() > 15 * 60) {
                                  //   showCupertinoDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         return CupertinoAlertDialog(
                                  //           title: Text('Subscribe'),
                                  //           actions: <Widget>[
                                  //             MaterialButton(
                                  //               child: Text('Cancel'),
                                  //               onPressed: () =>
                                  //                   Navigator.pop(context),
                                  //             ),
                                  //             MaterialButton(
                                  //               child: Text('Buy Premium'),
                                  //               onPressed: () =>
                                  //                   Navigator.pushNamed(
                                  //                       context, 'subscribe'),
                                  //             ),
                                  //           ],
                                  //           content: Text(
                                  //               'Free users are only allowed to listen for first 15 minutes of a track'),
                                  //         );
                                  //       });
                                  // } else {
                                  //   dd = d;
                                  //   _locator.seekMusic(d);
                                  // }
                                },
                                value: _locator.currentPlayerIndex ==
                                        _locator.songIndex
                                    ? pos.inSeconds.toDouble()
                                    : 0,
                                min: 0,
                                max: _locator.currentPlayerIndex ==
                                        _locator.songIndex
                                    ? _locator.max.value.inSeconds.toDouble()
                                    : 0,
                              );
                            }),
                      ],
                    ),
                  ),

                  TrailButton(),
                  SizedBox(
                    height: 20,
                  ),
                  userstate.userdata.paid == false
                      ? Consumer<AdsProvider>(
                          builder: (context, state, _) => state.adbanner,
                        )
                      : Container(),
                ],
              ),
            ),
            ValueListenableBuilder<Duration>(
                valueListenable: _locator.current,
                builder: (context, pos, _) {
                  if (dd > pos.inSeconds.toDouble() && dd != 0.0)
                    return Container(
                      color: Colors.grey.withOpacity(0.4),
                      child: Center(child: CupertinoActivityIndicator()),
                    );
                  else
                    return Container();
                }),
          ],
        ),
      ),
    );
  }
}

class ModelTimerSettrr extends StatefulWidget {
  @override
  _ModelTimerSettrrState createState() => _ModelTimerSettrrState();
}

class _ModelTimerSettrrState extends State<ModelTimerSettrr> {
  final _locator = locator<MusicService>();

  Duration temp;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
        valueListenable: _locator.timerRemainig,
        builder: (context, t, _) => CupertinoAlertDialog(
              title: Text('Set Timer'),
              content: DurationPicker(
                duration: temp ?? t,
                onChange: (val) {
                  setState(() {
                    temp = val;
                  });
                  // _locator.timerRemainig.value = val;
                },
              ),
              actions: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      '${t.toString().split('.').first.padLeft(8, "0")}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Row(
                      children: <Widget>[
                        OutlineButton.icon(
                          icon: Icon(Icons.close),
                          borderSide: BorderSide.none,
                          label: Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        OutlineButton.icon(
                          icon: Icon(Icons.done),
                          borderSide: BorderSide.none,
                          label: Text('Confirm'),
                          onPressed: () {
                            _locator.timer = temp;
                            _locator.timerRemainig.value = temp;
                            _locator.startTimer();
                            // state.calculateRemainingTime();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ));
  }
}
