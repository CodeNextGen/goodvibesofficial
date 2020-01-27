import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../config.dart';

class MusicProvider with ChangeNotifier {
  // StartupProvider startupProvider = StartupProvider();
  // final _locator = locator<StartupProvider>();
  Dio dio = Dio();
  List<Albums> albums = [];
  List<Track> albumTracks = [];
  List<Track> trendingTracks = [];
  List<Track> recomended = [];
  List<Track> genreTracks = [];
  List<Track> genreTracksFiltered = [];
  List<Genre> genre = [];
  Database db;

  List<Track> categoryTracks = [];

  List<Categories> gCategory = [];

  MusicProvider() {
    initMusicDatas();
    initDb();
  }

  void initMusicDatas() {
    gettrending();
    getRecomanded();
    // getCategories();
    getAlbums();
    getGenre();
  }

  initDb() async {
    var downloadpath = await getDatabasesPath();
    String path = join(downloadpath, 'data.db');
    db = await openDatabase(path, version: 1);
  }

  getCategoryTracks({int id, int page = 1, int perpage = 20}) async {
    categoryTracks.clear();
    var respons = await dio.get(
      '$baseUrl/v1/tracks',
      queryParameters: {'category_id': id, 'page': page, 'per_page': perpage},
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    List<dynamic> rsp = respons.data as List;
    var a = rsp.map<Track>((json) => Track.fromJson(json));
    categoryTracks.addAll(a);
    notifyListeners();
  }

  getAlbumsTracks({int id, int page = 1, int perpage = 20}) async {
    if (page == 1) albumTracks.clear();
    var respons = await dio.get(
      '$baseUrl/v1/tracks',
      queryParameters: {'album_id': id, 'page': page, 'per_page': perpage},
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    List<dynamic> rsp = respons.data as List;
    var a = rsp.map<Track>((json) => Track.fromJson(json));
    albumTracks.addAll(a);
    // tracks = albumTracks;
    notifyListeners();
    // return albumTracks;
  }

  gettrending() async {
    print('Trending track lenght is ${trendingTracks.length}');
    if (trendingTracks.isEmpty) {
      print('get Trending');
      var respons = await dio.get(
        '$baseUrl/v1/tracks/popular',
        queryParameters: {'page': 1, 'per_page': 8},
        options: Options(
          headers: {'Authorization': authorization},
        ),
      );
      List<dynamic> rsp = respons.data as List;
      print("tracks =>$rsp");
      var a = rsp.map<Track>((json) => Track.fromJson(json));
      // trendingTracks.clear();
      trendingTracks.addAll(a);
      print("tracksDownloadUrl =>${trendingTracks[0].trackDownloadUrl}");
    }

    notifyListeners();
  }

  getRecomanded() async {
    if (recomended.isEmpty) {
      print('get Recomanded');
      var respons = await dio.get(
        '$baseUrl/v1/tracks',
        queryParameters: {'page': 1, 'per_page': 8},
        options: Options(
          headers: {'Authorization': authorization},
        ),
      );
      List<dynamic> rsp = respons.data as List;
      // print(rsp);
      var a = rsp.map<Track>((json) => Track.fromJson(json));
      // recomended.clear();
      recomended.addAll(a);
    }

    notifyListeners();
  }

  getAlbums() async {
    var respons = await dio.get(
      '$baseUrl/v1/albums',
      queryParameters: {'page': 1, 'per_page': 20},
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    List<dynamic> rsp = respons.data as List;
    var a = rsp.map<Albums>((json) => Albums.fromJson(json));
    albums.clear();
    albums.addAll(a);
    albums.insert(1, Albums());
    notifyListeners();
    // return albums;
  }

  getGenre() async {
    genre.clear();
    var respons = await dio.get(
      '$baseUrl/v1/genres',
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    List<dynamic> rsp = respons.data as List;
    var a = rsp.map<Genre>((json) => Genre.fromJson(json));
    genre.addAll(a);
    notifyListeners();
  }

  int genreSelectedIndex = 0;
  getGenereCategory(int id) async {
    gCategory.clear();
    print('get genre category id is $id');
    var respons = await dio.get(
      '$baseUrl/v1/categories',
      queryParameters: {'page': 1, 'per_page': 20, 'genre_id': id},
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    List<dynamic> rsp = respons.data as List;
    var a = rsp.map<Categories>((json) => Categories.fromJson(json));

    // gCategory.insert(0, Categories());
    gCategory.add(Categories());
    gCategory.addAll(a);
    notifyListeners();
  }

  getGenreTracks({int id, int page = 1, int perpage = 20}) async {
    print('id is $id');
    categoryTracks.clear();
    genreTracks.clear();
    var respons = await dio.get(
      '$baseUrl/v1/tracks',
      queryParameters: {'genre_id': id, 'page': page, 'per_page': perpage},
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    List<dynamic> rsp = respons.data as List;
    var a = rsp.map<Track>((json) => Track.fromJson(json));
    if (page == 1) genreTracks.clear();
    genreTracks.addAll(a);
    notifyListeners();
  }

  filterGenereTracks(int id) {
    genreTracksFiltered.clear();
//    genreTracks.clear();
    genreTracks.forEach((Track track) {
      if (track.cid == id) genreTracksFiltered.add(track);
    });
    notifyListeners();
  }

  clearGenreTracksFilter() {
    genreTracksFiltered.clear();
    notifyListeners();
  }
}
