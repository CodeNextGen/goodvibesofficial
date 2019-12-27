import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/models/player_status_enum.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:goodvibes/styles/button_decoration.dart';
import 'package:goodvibes/widgets/trail_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';


class SinglePlayer extends StatefulWidget {
  final int index;
  final bool onAdsClick;


  SinglePlayer({Key key, this.index, this.onAdsClick}) : super(key: key);

  @override
  _SinglePlayerState createState() => _SinglePlayerState(onAdsClick: onAdsClick);
}

class _SinglePlayerState extends State<SinglePlayer> with WidgetsBindingObserver{
  AppLifecycleState _appLifecycleState;
  final _locator = locator<MusicService>();
  final userstate = locator<StartupProvider>();
  double dd = 0.0;
  bool isdownloading = false;
  int downloadPercentage = 0;
  bool onAdsClick= false;

  bool isAdLoaded= false;

  AdmobInterstitial rewardAd;

  _SinglePlayerState({
    this.onAdsClick
});

  @override
  void initState() {
    super.initState();
    _locator.getInitialData();
    _locator.getInterestialAds();
    getInterestialAds();
    if(onAdsClick== null)
      setState(() {
     onAdsClick = false;
      });
    print("onAdsClick: $onAdsClick");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if(_locator.rewardAd!= null)
    _locator.rewardAd.dispose();
    _locator.rewardAd = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });
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
                                  setState(() {
                                    _locator.isAdRepeat = true;
                                  });
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
                                    setState(() {
                                    _locator.stopPlaying();
                                    _locator.adCounterII = 0;
                                    });
                                  }
                                  if (userstate.userdata.paid == false) {
                                    _locator.showintrestatialAdsVideo();
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
                                            onTap: ()  {
                                              print('Play button is tapped');
                                              _locator.play();
                                            },
                                            child: ValueListenableBuilder<
                                                PlayerStatus>(
                                                valueListenable:
                                                _locator.playerStatus,
                                                builder: (context, status, _) {
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
//                        Flexible(
//                          child: Column(
//                            children: <Widget>[
//                              IconButton(
//                                icon: Icon(
//                                  _locator.repeat
//                                      ? Icons.repeat
//                                      : Icons.arrow_forward,
//                                  color: Color(0xFF3F3FB6),
//                                ),
//                                onPressed: () => setState(() {
//                                  _locator.repeat = !_locator.repeat;
//                                }),
//                              ),
//                              Text(
//                                'Repeat ${_locator.repeat ? 'ON ' : 'OFF'}',
//                                style: TextStyle(
//                                    color: Color(0xFF3F3FB6), fontSize: 12.0),
//                              )
//                            ],
//                          ),
//                        ),
//                        SizedBox(
//                          width: 14.0,
//                        ),
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
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            ModelTimerSettrr(track: _track)
//
                                    );
                                  }),
                              ValueListenableBuilder(
                                valueListenable: _locator.timerRemainig,
                                builder: (context, t, _) {
                                  return t > Duration(seconds: 0)
                                      ? Text(
                                    '${t
                                        .toString()
                                        .split('.')
                                        .first
                                        .padLeft(8, "0")}',
                                    style: TextStyle(
                                        color: Color(0xFF3F3FB6),
                                        fontSize: 12.0),
                                  )
                                      : Text(
                                    'Timer',
                                    style: TextStyle(
                                        color: Color(0xFF3F3FB6),
                                        fontSize: 12.0),
                                  );
                                },
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
                                                  Opacity(
                                                    child: Center(
                                                      child: Icon(
                                                        isdownloaded == false
                                                            ? Icons.cloud_queue
                                                            : Icons.cloud,
                                                        color:
                                                        Color(0xFF3F3FB6),
                                                      ),
                                                    ),
                                                    opacity:
                                                    isDownloading == false
                                                        ? 1
                                                        : 0,
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
//                                                              downloadPercentage = percantage;

                                                        print(
                                                            "percentage %%% $percantage");
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                              right:
                                                              8.0,
                                                              top: 6.0),
                                                          child: Stack(
                                                            children: <
                                                                Widget>[
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
                                                                  isDownloading ==
                                                                      true
                                                                      ? Color(
                                                                      0xFF3F3FB6)
                                                                      : Colors
                                                                      .transparent,),
                                                                strokeWidth:
                                                                1.0,
                                                                backgroundColor:
                                                                isDownloading ==
                                                                    true
                                                                    ? Colors
                                                                    .black12
                                                                    : Colors
                                                                    .transparent,
                                                              ),
                                                              Opacity(
                                                                child: Icon(
                                                                  Icons
                                                                      .clear,
                                                                  color: Color(
                                                                      0xFF3F3FB6),
                                                                ),
                                                                opacity:
                                                                isDownloading ==
                                                                    true
                                                                    ? 1
                                                                    : 0,
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      })
                                                      : Container(),
                                                ],
                                              ),
                                              onPressed: isDownloading
                                                  ? () {
                                              setState(() {
                                                _locator.is_Downloading = true;
                                              });
                                                print(
                                                    'percentage% ${_locator
                                                        .downloadPercantage
                                                        .value}');
                                                _locator.stopDown();
//                                                _locator.downloadTrackIndex =
//                                                9999;
                                                Fluttertoast.showToast(
                                                    msg:
                                                    'Download cancled !',
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
                                    isDownloading == true
                                        ?
                                    ValueListenableBuilder<int>(
                                        valueListenable:
                                        _locator.downloadPercantage,
                                        builder: (context, percantage, _) {
                                          return Container(
                                            child: Text(
                                              '$percantage %',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff3f3fb6)),
                                            ),
                                          );
                                        })
                                        :
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff3f3fb6)),
                                    ),
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
                                  print("value of d: $d");
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
                                    ? _locator.max.value.inSeconds.toDouble() +
                                    50.0
                                    : 0,
                              );
                            }),
                      ],
                    ),
                  ),

                  TrailButton(),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 1.0,
              left: 15.0,
              right: 15.0,
              child: Consumer<StartupProvider>(
                builder: (context, state, _) =>
                state.userdata.paid == false
                    ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Consumer<AdsProvider>(
                    builder: (context, st, _) =>
                        Center(
                          child: st.footerBanner,
                        ),
                  ),
                )
                    : Container(height: 0.0, width: 0.0,),
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

  getInterestialAds(){
    rewardAd = AdmobInterstitial(
        adUnitId: getRewardBasedVideoAdUnitId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleAdsEvent(event, args, 'Interstial Videos');
        }
    );
    rewardAd.load();
  }

  void handleAdsEvent(AdmobAdEvent event, Map<String, dynamic> args,
      String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print("Ad to load");
        isAdLoaded = true;
        break;
      case AdmobAdEvent.failedToLoad:
        if(isAdLoaded== false){
          rewardAd.load();
        }
        print("Ad failed to load");
        break;
      case AdmobAdEvent.clicked:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.impression:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.opened:

//        if(_appLifecycleState == AppLifecycleState.inactive){
//        setState(() {
//          _locator.musicPlayer.pause();
//          _locator.playerStatus.value = PlayerStatus.isPaused;
//        });
//        }
      setState(() {
        onAdsClick = true;
      });
        print("player state opened: ${_locator.playerStatus.value}");
        print("player state opened: $_appLifecycleState");
        break;
      case AdmobAdEvent.leftApplication:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.closed:
        print("on ad apen  ${_locator.playerStatus.value}");

//        if(_appLifecycleState == AppLifecycleState.resumed){
//        setState(() {
//          _locator.playerStatus.value = PlayerStatus.isPlaying;
//          _locator.musicPlayer.resume();});
//        }
        setState(() {
          onAdsClick = true;
          _locator.play();
        });
        print("player state closed: ${_locator.playerStatus.value}");
        print("player state closed: $_appLifecycleState");
        break;
      case AdmobAdEvent.completed:
        print("on ad close  ${_locator.playerStatus.value}");
        print("on ad close  $_appLifecycleState");
//        setState(() {
//        if (_locator.playerStatus.value == PlayerStatus.isPaused) {
//          _locator.musicPlayer.resume();
//          _locator.playerStatus.value = PlayerStatus.isPlaying;
//        }else
//          _locator.play();
//        });

        setState(() {
          onAdsClick = true;
        });

        print("player state completed: ${_locator.playerStatus.value}");
        break;
      case AdmobAdEvent.rewarded:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.started:
        print("player state started: ${_locator.playerStatus.value}");
        break;
    }
  }

  String getRewardBasedVideoAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/8691691433';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/8691691433';
    }
    return null;
  }

  showintrestatialAdsVideo() async {
    rewardAd.load();
    if (await rewardAd.isLoaded) {
      rewardAd.show();
    }else {
      print('''
          Log.d("TAG", "The interstitial wasn't loaded yet.")
  ''');
    }
  }
}

class ModelTimerSettrr extends StatefulWidget {
  final Track track;

//  final int startTimer;

  ModelTimerSettrr({
    this.track,
//    this.startTimer
  });

  @override
  _ModelTimerSettrrState createState() => _ModelTimerSettrrState(track: track);
}

class _ModelTimerSettrrState extends State<ModelTimerSettrr> {
  final _locator = locator<MusicService>();
  final Track track;
  bool isFirstClickTimer = true;

//  int startTimer;
  Duration temp = Duration.zero;

  _ModelTimerSettrrState({
    this.track,
//    this.startTimer
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 320.0,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 280.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(track.image),
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
                                    track.title,
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
                                    track.description,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                  '${track.cname ?? ''}',
                                  style: TextStyle(
                                      color: Color(0xFFBBDEFB),
                                      decoration: TextDecoration.underline),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    track.duration,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                // userstate.userData.paid==false?  Text(
                                //     'Listen 15 min for free',
                                //     style: TextStyle(
                                //         color: Colors.white, fontSize: 12.0),
                                //   ):Container(),
                                Text(
                                  track.composer == null
                                      ? ''
                                      : 'Composer : ${track.composer}',
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
//                                  if (_locator.currentPlayerIndex ==
//                                      _locator.songIndex) {
//                                    _locator.stopPlaying();
//                                  }

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
                  ValueListenableBuilder<Duration>(
                      valueListenable: _locator.timerRemainig,
                      builder: (context, t, _) => CupertinoAlertDialog(
                        title: ValueListenableBuilder(
                          valueListenable: _locator.isFirstClickTimer,
                          builder: (context, firstClick, _) {
                            return firstClick == true
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: Text(
                                    'Set Timer',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  'Music will Auto stop after playing the set timer',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            )
                                : Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  icon: Icon(Icons.close),
                                  color: Colors.black,
                                  onPressed: () =>
                                  {Navigator.pop(context)}),
                            );
                          },
                        ),
                        content: ValueListenableBuilder(
                          valueListenable: _locator.isFirstClickTimer,
                          builder: (context, firstClick, _) {
                            return firstClick == true
                                ? Container(
                              width: MediaQuery.of(context)
                                  .copyWith()
                                  .size
                                  .width,
                              height: MediaQuery.of(context)
                                  .copyWith()
                                  .size
                                  .height /
                                  5,
                              child: CupertinoTimerPicker(
                                mode: CupertinoTimerPickerMode.hm,
                                minuteInterval: 1,
                                secondInterval: 1,
                                initialTimerDuration: temp ?? t,
                                onTimerDurationChanged: (val) {
                                  setState(() {
                                    temp = val;
                                  });
// _locator.timerRemainig.value = val;
                                },
                              ),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: <Widget>[
                                Divider(
                                  color: Color(0xff3f3fb3),
                                  indent: 40,
                                  endIndent: 40,
                                ),
                                Align(
                                  child: Text(
                                    '${t.toString().split('.').first.padLeft(8, "0")}',
                                    style: TextStyle(
                                      color: Color(0xff3f3fb3),
                                      fontSize: 24.0,
                                      letterSpacing: 6.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                Divider(
                                  color: Color(0xff3f3fb3),
                                  indent: 40,
                                  endIndent: 40,
                                ),
                              ],
                            );
                          },
                        ),
                        actions: <Widget>[
                          ValueListenableBuilder<bool>(
                            valueListenable: _locator.isFirstClickTimer,
                            builder: (context, isFirst, _) {
                              return isFirst == true
                                  ? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0),
                                      child: GestureDetector(
                                        onTap: () async {
//                                _locator.timer = Duration(seconds: 0);
//                                _locator.timerRemainig.value = Duration(seconds: 0);
//                                _locator.stopTimer(temp);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                5.0),
                                            border: Border.all(
                                                color: Colors.black),
                                          ),
//                          width: 150.0,
                                          child: Padding(
                                            padding: const EdgeInsets
                                                .fromLTRB(
                                                8.0, 7.0, 8.0, 7.0),
                                            child: Center(
                                              child: Text(
                                                'cancel'
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _locator.timer = temp;
                                          _locator.timerRemainig
                                              .value = temp;
                                          _locator.startTimer();
                                          Navigator.pop(context);
                                          setState(() {
                                            _locator.repeat =
                                            !_locator.repeat;
                                          });
                                          _locator.isFirstClickTimer
                                              .value = false;
                                          print(
                                              "first: $isFirstClickTimer");
                                        },
                                        child: Container(
                                          decoration:
                                          buttonDecoration,
//                          width: 150.0,
                                          child: Padding(
                                            padding: const EdgeInsets
                                                .fromLTRB(
                                                8.0, 7.0, 8.0, 7.0),
                                            child: Center(
                                              child: Text(
                                                'ok'.toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  : GestureDetector(
                                onTap: () {
                                  _locator.timerRemainig.value =
                                      Duration(seconds: 0);
                                  _locator.timer = Duration(seconds: 0);
                                  _locator.stopTimer(temp);
                                  Navigator.pop(context);
//                            setState(() {
//                              _locator.isFirstClickTimer.value = true;
//                            });
                                  _locator.isFirstClickTimer.value =
                                  true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: buttonDecoration,
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical: 12.0,
                                              horizontal: 25),
                                          child: Text(
                                            'cancel'.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
//              ],
//            ),
                        ],
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



