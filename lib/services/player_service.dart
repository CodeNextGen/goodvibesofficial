import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/models/player_status_enum.dart';
import 'package:goodvibes/providers.dart/ads_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:music_player/music_player.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  // Duration timerRemainig = Duration(seconds: 0);
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
    await Dio().download("${t.url}", "$downloadpath/${t.filename}",
        onReceiveProgress: (int d, int t) {
      getdownloadpercentage(d, t);
    });
    print(t.filename);
    await db.rawInsert('''insert into  download
       (id ,title,filename,duration,cid,description,url,cname,composer,image)
       values
        ("${t.id}" , "${t.title}", "${t.filename}", "${t.duration}", "${t.cid}", "${t.description}", "$downloadpath/${t.filename}", "${t.cname}", "${t.composer}", "${t.image}")''');
    getdownloadpercentage(1, 1);
    isDownloading.value = false;
    isDownloaded.value = true;
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
      playerStatus.value = PlayerStatus.isPlaying;
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
        if (timerRemainig.value.inSeconds == 0 && timer.inSeconds > 5) {
          stopPlaying();
          timer = Duration(seconds: 0);
          // if (locator<StartupProvider>().userdata.paid == false &&
          //     d.inMinutes >= 15) {
          //   stopPlaying();
          //   locator<AdsProvider>().showinterestialAds();
          // }
        }
      }
    };

    musicPlayer.onIsLoading = () {
      print('player is loading ');
      playerStatus.value = PlayerStatus.isLoading;
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
      if (locator<StartupProvider>().userdata.paid == false ) {
            // stopPlaying();
            locator<AdsProvider>().showinterestialAds();
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
      }
      timerRemainig.value = timerRemainig.value - Duration(seconds: 1);
      // print('timer is active');
    });
  }

  Future stopDown() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    db = await openDatabase(path);
    await db.close();
    downloadPercantage.value = 100;
   if(isDownloading.value == true){
     isDownloading.value= false;
   }
       isDownloaded.value = false;
  }
}
