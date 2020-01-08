import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/models/player_status_enum.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:music_player/music_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../config.dart';
import '../locator.dart';

class MusicService {
  List<Track> musics = List();
  int songIndex;
  Track songPlaying = Track();
  int downloadTrackIndex = 9999;
  int currentPlayerIndex = 9999;

  // bool repeatMode = false;
  bool repeat = false;

  // bool isFav = false;
  // bool isDownloaded = false;
  // bool isDownloading = false;
  Duration timer = Duration(seconds: 0);
  Database db;
  MusicPlayer musicPlayer;

  // PlayerStatus playerStatus;
  double pos = 0;
  ValueNotifier<int> downloadPercantage = ValueNotifier(0);
  ValueNotifier<bool> isFav = ValueNotifier(false);
  ValueNotifier<bool> isDownloaded = ValueNotifier(false);
  ValueNotifier<bool> isDownloading = ValueNotifier(false);

  ValueNotifier<Duration> current = ValueNotifier(Duration(seconds: 0));
  ValueNotifier<Duration> max = ValueNotifier(Duration(seconds: 0));
  ValueNotifier<Duration> timerRemainig = ValueNotifier(Duration(seconds: 0));
  ValueNotifier<PlayerStatus> playerStatus =
      ValueNotifier(PlayerStatus.isStopped);
  ValueNotifier<bool> isFirstClickTimer = ValueNotifier(true);

  int downloadId= -1;

  AdmobInterstitial rewardAd;
  bool isAdRepeat = false;
  bool isAdLoaded = false;
  bool is_Downloading = false;

  getInitialData() {
    //get Fav Data
    isFavTrack();
    //get Download data
    isDownloadedTrack();
  }

  getdownloadpercentage(int d, int t) {
    downloadPercantage.value = d * 100 ~/ t;
    if (downloadPercantage.value == 100) {
      downloadPercantage.value = 0;
    }
  }

  implementDownload() async {
    isDownloading.value = true;
    downloadTrackIndex = songIndex;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);

    var downloadpath = await getDatabasesPath();
    // var pathh =  join(downloadpath, t.filename);
    Track t = musics[songIndex];

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String deviceToken = _prefs.getString('notificatioToken');
      String uid = _prefs.getString('uid');
      print("deviceToken $deviceToken");

      Map<String, String> formData = {
        "device_token": deviceToken,
        "device_platform":isAndroid? "android":"ios"
      };
      Dio dio = Dio();
      Response response = await dio.post('''$baseUrl/v1/tracks/${t.id}/download''',
        data: json.encode(formData),
        options: Options(
          headers: {'uuid': uid,
          'Content-Type':'application/json'},
        ),
      );
        downloadId = await response.data["download_id"];
    } on DioError catch (e) {
      print(e);
    }

    print("downloadId $downloadId");
    print("trackId ${t.id}");

    CancelToken cancelToken = CancelToken();
    if(is_Downloading== true) {
      cancelToken.cancel(["User clicked download listner"]);
      is_Downloading = false;
    }
//    try {
      await Dio().download("${t.trackDownloadUrl}", "$downloadpath/${t.filename}",
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          onReceiveProgress: (int d, int t) {
            getdownloadpercentage(d, t);
          },
          cancelToken: cancelToken);
//    }catch(e){
//      print("exception $e");
//    }

    await db.rawInsert('''insert into  download
       (id ,title,filename,duration,cid,description,url,cname,composer,image, download_id)
       values
        ("${t.id}" , "${t.title}", "${t.filename}", "${t.duration}", "${t.cid}", "${t.description}", "$downloadpath/${t.filename}", "${t.cname}", "${t.composer}", "${t.image}", "$downloadId")''');
    getdownloadpercentage(1, 1);
    isDownloading.value = false;
    isDownloaded.value = true;
    if(isDownloaded.value == true)
      onDownloadFinished();
  }

  void play() {
    initPlatformState();
    if (songIndex == currentPlayerIndex) {
      if (playerStatus.value == PlayerStatus.isPlaying) {
        musicPlayer.pause();
        playerStatus.value = PlayerStatus.isPaused;
      } else if (playerStatus.value == PlayerStatus.isPaused) {
        musicPlayer.resume();
        playerStatus.value = PlayerStatus.isPlaying;
      }
    } else {
      // musicPlayer = MusicPlayer();
      Track trackplaying = musics[songIndex];
      songPlaying = trackplaying;
      currentPlayerIndex = songIndex;
      musicPlayer.play(MusicItem(
        url: trackplaying.url,
        duration: Duration(minutes: 20),
        albumName: trackplaying.cname,
        artistName: trackplaying.composer,
        trackName: trackplaying.title,
        coverUrl: trackplaying.image,
        id: trackplaying.id.toString(),
      ));
//      playerStatus.value = PlayerStatus.isPlaying;
    }
  }

  void stopPlaying() {
    if (musicPlayer != null) {
      musicPlayer.pause();
      musicPlayer.stop();
      musicPlayer.dispose();
    }
    playerStatus.value = PlayerStatus.isStopped;
    currentPlayerIndex = 9999;
  }

  void resume(){
      musicPlayer.resume();
      playerStatus.value = PlayerStatus.isPlaying;
  }

  void pause(){
      musicPlayer.pause();
      playerStatus.value = PlayerStatus.isPaused;
  }

  initPlatformState() {
    musicPlayer = MusicPlayer();

    musicPlayer.onPlayNext = () {
      if (songIndex < musics.length) songIndex += 1;
      play();
    };
    musicPlayer.onPlayPrevious = () {
      if (songIndex > 0) songIndex -= 1;
      play();
    };

    musicPlayer.onPosition = (position) async {
      // seekPosition.value = position;
      if (max.value.inSeconds > 1) {
        int time = (position * max.value.inSeconds).toInt();
        Duration d = Duration(seconds: time);
        current.value = d;
        // setcurrent(d);
        // print(current.value);
        // if (locator<StartupProvider>().userdata.paid == false &&
        //     d.inMinutes >= 15) {
        //   stopPlaying();
        //   locator<AdsProvider>().showinterestialAds();
        // }

        if (current.value.inMinutes == 20 && current.value.inSeconds == 1206) {
          if (locator<StartupProvider>().userdata.paid == false) {
            showintrestatialAdsVideo();
      }
        }
        if (timerRemainig.value.inSeconds == 0 && timer.inSeconds > 5) {
          stopPlaying();
          timer = Duration(seconds: 0);
        }
        if (timerRemainig.value.inSeconds == 0) {
          isFirstClickTimer.value = true;
        }
      }
    };

    musicPlayer.onIsLoading = () {
      if (locator<StartupProvider>().userdata.paid == false) {
        showintrestatialAdsVideo();
        print('current value: print after loading');
      }
      playerStatus.value = PlayerStatus.isLoading;
      print('player is loading');
    };

    musicPlayer.onIsPlaying = () {
      playerStatus.value = PlayerStatus.isPlaying;
      print('player is playing');
    };
    musicPlayer.onIsPaused = () {
      playerStatus.value = PlayerStatus.isPaused;
      print('player is paused');
    };
    musicPlayer.onIsStopped = () {
      playerStatus.value = PlayerStatus.isStopped;
      print('player is stopped');
    };
    musicPlayer.onCompleted = () {
      if (locator<StartupProvider>().userdata.paid == false) {
           showintrestatialAdsVideo();
      }
      if (repeat) {
        currentPlayerIndex = 9999;
        play();
      } else
        playerStatus.value = PlayerStatus.isStopped;
      print('player is completed');
    };

    musicPlayer.onDuration = (Duration d) {
      if (d != null) {
        max.value = d;
      }
    };
  }

  void seekMusic(d) {
    musicPlayer.seek(d / (max.value.inSeconds));
  }

  isFavTrack() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);

    int id = musics[songIndex].id;
    var a = await db.rawQuery('select * from favourite where id=$id');
    if (a.isNotEmpty)
      isFav.value = true;
    else
      isFav.value = false;
  }

  Future implementFavourite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);
    Track t = musics[songIndex];
    await db.rawInsert('''insert into  favourite
       (id ,title,filename,duration,cid,description,url,cname,composer,image) 
       values
        ("${t.id}" , "${t.title}", "filename", "${t.duration}", "${t.cid}", "${t.description}", "${t.url}", "${t.cname}", "${t.composer}","${t.image}")''');

    isFav.value = true;
  }

  deletFav() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);
    int id = musics[songIndex].id;
    await db.rawDelete('delete from  favourite where id=$id');
    isFav.value = false;
  }

  void deleteDown() async {
    int id = musics[songIndex].id;
    var d = await db.rawQuery('select * from download where id=$id');
    // print(d);
    if (d.isNotEmpty) {
      File file = File(d[0]['url'] + '/' + musics[songIndex].filename);
      file.delete();
      await db.rawDelete('delete from  download where id=$id');
    }
    isDownloaded.value = false;
  }

  isDownloadedTrack() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);
    int id = musics[songIndex].id;
    var a = await db.rawQuery('select * from download where id=$id');
    print('is downloaded track check');
    print(a);
    if (a.isNotEmpty)
      isDownloaded.value = true;
    else
      isDownloaded.value = false;
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (t) {
      if (timerRemainig.value < Duration(seconds: 1)) {
        stopPlaying();
        t.cancel();
        isFirstClickTimer.value = true;
      }
      timerRemainig.value = timerRemainig.value - Duration(seconds: 1);
      isFirstClickTimer.value = false;
      // print('timer is active');
    });
  }

  void stopTimer(Duration duration) {
    Timer.periodic(Duration(seconds: 1), (t) {
//      stopPlaying();
      t.cancel();
      isFirstClickTimer.value = true;
    });
    isFirstClickTimer.value = true;
//
  }

  Future stopDown() async {
    if (isDownloading.value == true) {
      isDownloading.value = false;
    }
    isDownloading.value = false;
    isDownloaded.value = false;

    onDownloadCancled();

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);
    await db.close();
  }

  onDownloadCancled([int downloadIds]) async {
    downloadTrackIndex = songIndex;
    Track t = musics[songIndex];
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String uid = _prefs.getString('uid');
      Response response = await Dio().post('''$baseUrl/v1/tracks/${t.id}/cancel_download?download_id=${downloadId ?? downloadIds}''',
        options: Options(
          headers: {'uuid': uid},
        ),
      );
      print("response delete code: ${response.statusCode}");
    } on DioError catch (e) {
      print(e);
    }
  }

  onDownloadFinished() async {
    downloadTrackIndex = songIndex;
    Track t = musics[songIndex];
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String uid = _prefs.getString('uid');
      Response response = await Dio().post('''$baseUrl/v1/tracks/${t.id}/finish_download?download_id=$downloadId''',
        options: Options(
          headers: {'uuid': uid},
        ),
      );
      print("response success code: ${response.statusCode}");
    } on DioError catch (e) {
      print(e);
    }
  }

  getInterestialAds(){
    rewardAd = AdmobInterstitial(
        adUnitId: getRewardBasedVideoAdUnitId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          handleAdsEvent(event, args, 'Interstial Videos', 0);
        }
    );
    rewardAd.load();
  }

  void handleAdsEvent(AdmobAdEvent event, Map<String, dynamic> args,
      String adType, int adCount) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print("Ad to load");
        print("Ad to load $isAdRepeat");
            isAdLoaded = true;
        break;
      case AdmobAdEvent.failedToLoad:
        if(isAdLoaded== false){
          rewardAd.load();
        }
        rewardAd.load();
        print("Ad failed to load");
        break;
      case AdmobAdEvent.clicked:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.impression:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.opened:
        isAdRepeat = true;
        print("player state opened: ${playerStatus.value} ,, $isAdRepeat");
        if(playerStatus.value == PlayerStatus.isPlaying){
          pause();
        }
        break;
      case AdmobAdEvent.leftApplication:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.closed:
        isAdRepeat = true;
        print("on ad apen");
        print("player state closed: ${playerStatus.value},, $isAdRepeat");
        if(playerStatus.value == PlayerStatus.isPaused){
          resume();
        }
        break;
      case AdmobAdEvent.completed:
        isAdRepeat = true;
        print("player state completed: ${playerStatus.value } ,, $isAdRepeat");
        print("on ad close");
        break;
      case AdmobAdEvent.rewarded:
      // TODO: Handle this case.
        break;
      case AdmobAdEvent.started:
        print("player state started: ${playerStatus.value}");
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
    rewardAd..load();
    if (await rewardAd.isLoaded) {
      rewardAd.show();
    }else {
      print('''
          Log.d("TAG", "The interstitial wasn't loaded yet.")
  ''');
    }
  }
}
