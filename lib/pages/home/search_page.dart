import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/pages/music/single_player_page.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/services/player_service.dart';
import 'package:goodvibes/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class DefaultSearchBox extends StatefulWidget {
  @override
  _DefaultSearchBoxState createState() => _DefaultSearchBoxState();
}

class _DefaultSearchBoxState extends State<DefaultSearchBox> {
  TextEditingController txt = TextEditingController();
  String searchtxt;
  Dio dio = Dio();
  int page = 1, perPage = 20;
  List<Track> _tracks = [];
  List<Track> _popularTracks = [];
  String header = 'Popular Tracks';
  bool loading = true;

  getSearchDetails(String text) async {
    loading = true;

    final url = baseUrl + '/v1/tracks/search';
    var response = await dio.get(
      url,
      queryParameters: {'name': text, 'page': page, 'per_page': perPage},
      options: Options(headers: {'Authorization': authorization}),
    );
    List<dynamic> rsp = response.data as List;
    // print(rsp);
    var a = rsp.map<Track>((json) => Track.fromJson(json));

    _tracks.clear();
    _tracks.addAll(a);
    setState(() {
      _popularTracks = _tracks;
      header = 'Search results';
    });
    loading = false;
  }

  getPopularTracks() async {
    loading = true;
    final url = baseUrl + '/v1/tracks/popular';
    var response = await dio.get(
      url,
      queryParameters: {'page': page, 'per_page': perPage},
      options: Options(headers: {'Authorization': authorization}),
    );
    List<dynamic> rsp = response.data as List;
    var a = rsp.map<Track>((json) => Track.fromJson(json));
    _popularTracks.clear();
    _popularTracks.addAll(a);
    setState(() {
      loading = false;
    });
  }

  void openDialog(index) {
    // adstate.showinterestialAds();
    Navigator.of(context).push(
      new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return SinglePlayer(index: index);
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void initState() {
    getPopularTracks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 220.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg1.png'),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Header(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        width: width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Text('Search for what you want'),
                              Expanded(
                                child: TextField(
                                  controller: txt,
                                  onChanged: (val) => searchtxt = val,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search for what you want ..',
                                  ),
                                  onSubmitted: (val) {
                                    getSearchDetails(val);
                                    setState(() {
                                      loading = true;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Color(0xFF0E0778),
                                ),
                                onPressed: () {
                                  getSearchDetails(txt.text);
                                  setState(() {
                                    loading = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: <Widget>[
            //       Text(
            //         'Recent Search',
            //         style:
            //             TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            //       ),
            //       SizedBox(
            //         height: 15.0,
            //       ),
            //       Row(
            //         children: <Widget>[
            //           Expanded(
            //             flex: 1,
            //             child: Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                   color: Color(0xFFE3F2FD),
            //                   borderRadius: BorderRadius.circular(10.0)),
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
            //                 child: Center(child: Text('Solfeggio Frequencies')),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             width: 15.0,
            //           ),
            //           Expanded(
            //             flex: 1,
            //             child: Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                   color: Color(0xFFE3F2FD),
            //                   borderRadius: BorderRadius.circular(10.0)),
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
            //                 child: Center(child: Text('Solfeggio Frequencies')),
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //       SizedBox(
            //         height: 15.0,
            //       ),
            //       Row(
            //         children: <Widget>[
            //           Expanded(
            //             flex: 1,
            //             child: Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                   color: Color(0xFFE3F2FD),
            //                   borderRadius: BorderRadius.circular(10.0)),
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
            //                 child: Center(child: Text('Solfeggio Frequencies')),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             width: 15.0,
            //           ),
            //           Expanded(
            //             flex: 1,
            //             child: Container(
            //               width: double.infinity,
            //               decoration: BoxDecoration(
            //                   color: Color(0xFFE3F2FD),
            //                   borderRadius: BorderRadius.circular(10.0)),
            //               child: Padding(
            //                 padding: const EdgeInsets.symmetric(vertical: 12.0),
            //                 child: Center(child: Text('Solfeggio Frequencies')),
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //       SizedBox(
            //         height: 15.0,
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: loading == false
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$header',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          _popularTracks.isNotEmpty
                              ? Consumer<MusicProvider>(
                                  builder: (context, state, _) => Container(
                                    height: MediaQuery.of(context).size.height -
                                        254,
                                    child: ListView.builder(
                                      itemCount: _popularTracks.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              ListTile(
                                        subtitle: Text(
                                            _popularTracks[index].duration),
                                        title:
                                            Text(_popularTracks[index].title,overflow: TextOverflow.ellipsis,
                                              maxLines: 1,),
                                        leading: Image.network(
                                          _popularTracks[index].image,
                                          width: 40,
                                        ),
                                        // trailing: Icon(Icons.play_arrow),
                                        onTap: () {
                                          locator<MusicService>().musics =
                                              _popularTracks;
                                          locator<MusicService>().songIndex =
                                              index;
                                          openDialog(index);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text('No data Available ..'),
                                ),
                        ],
                      ),
                    )
                  : Center(
                      child: CupertinoActivityIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
