import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/music_model.dart';
import 'package:goodvibes/providers.dart/music_provider.dart';
import 'package:goodvibes/widgets/header.dart';
import 'package:provider/provider.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: Container(),
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
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Header(),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 1,
                      right: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Discover all our Relaxing Music',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          // height: double.infinity,
          child: Consumer<MusicProvider>(
            builder: (context, state, _) => Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: state.genre.isNotEmpty
                  ? GridView.count(
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 5,
                      children: List.generate(state.genre.length, (index) {
                        Genre gen = state.genre[index];
                        return InkWell(
                          onTap: () {
                            
                            state.getGenreTracks(id: gen.id, page: 1);
                            state.getGenereCategory(gen.id);
                            Navigator.pushNamed(context, 'genreSongs',
                                arguments: gen);
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
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/placeholder.jpg',
                                    image: gen.image,
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
                                      gen.name,
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
                  : Container(
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
